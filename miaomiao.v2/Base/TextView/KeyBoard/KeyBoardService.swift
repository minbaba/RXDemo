//
//  KeyBoardService.swift
//  miaomiao.v2
//
//  Created by minbaba on 16/5/27.
//  Copyright © 2016年 MiaoquTech Inc. All rights reserved.
//

import UIKit
import RxSwift
//import IQKeyboardManagerSwift

class KeyBoardService {
    
    static let emojiKey = "keyboard_emoji"
    
    
    var emojiView = UIView(frame: CGRectMake(0, 0, screenWidth, 220))
    
    
    let disposeBag = DisposeBag()
    var firstResponder: UITextInput?
    
    var keyBordDict = [String: UIView]()
    
    
    static let instance = KeyBoardService()
    
    private init () {
        
        NSNotificationCenter.defaultCenter().rx_notification(UIKeyboardWillShowNotification).subscribeNext {[weak self] (noti) in
            
            self?.firstResponder = self?.findFirstResponder(UIApplication.sharedApplication().keyWindow!)
            if let keyBoard = self?.keyBoard {
                for view in (self?.keyBordDict.values)! {
                    dispatch_async(dispatch_get_main_queue(), {
                        if (view.superview == nil) {
                        keyBoard.addSubview(view)
                            
                            view.snp_makeConstraints(closure: { (make) in
                                make.top.left.bottom.right.equalTo(0)
                            })
                        }
                        if !view.hidden {
                            keyBoard.bringSubviewToFront(view)
                        }
                        
                    })
                }

            }
        }.addDisposableTo(disposeBag)
        
        NSNotificationCenter.defaultCenter().rx_notification(UIKeyboardDidHideNotification).subscribeNext {[weak self] (_) in
            self?.showDefaultKeyBoard()
        }.addDisposableTo(disposeBag)
    }
    
    func keyboardChange() -> Observable<(Double, CGFloat)> {
        return NSNotificationCenter.defaultCenter().rx_notification(UIKeyboardWillChangeFrameNotification).map { (notification) -> (Double, CGFloat) in
            //获取信息
            let info = notification.userInfo!
            //获取动画时间
            let duration = info[UIKeyboardAnimationDurationUserInfoKey]?.doubleValue ?? 0
            //获取结束时键盘大小
            let endKeyboardRect = info[UIKeyboardFrameEndUserInfoKey]!.CGRectValue()
            //计算y坐标偏移值
            let yOffset: CGFloat = screenHeight - endKeyboardRect.origin.y
            //执行动画
            return (duration, yOffset)
        }
    }
    
    var keyBoard:UIView? {
        var keyboardView: UIView?
        let windows = UIApplication.sharedApplication().windows
        
        for window in windows.reverse() {
            keyboardView = findKeyBoard(window)
            if let _ = keyboardView {
                return keyboardView
            }
        }
        
        
        return nil
    }
    
    func findKeyBoard(suView:UIView) -> UIView? {
        for subView in suView.subviews {
            if strstr(object_getClassName(subView), "UIKeyboard") != nil {
                return subView
            } else {
                let tempView = findKeyBoard(subView)
                if let _ = tempView {
                    return tempView
                }
            }
        }
        return nil
    }
    
    func findFirstResponder(suView:UIView) -> UITextInput? {
        
        if suView.isFirstResponder() {
            return suView as? UITextInput
        }
        
        for view in suView.subviews {
            
            if let first = findFirstResponder(view) {
                return first
            }
        }
        return nil
    }
    
    func add(keyBoard:UIView, key:String) {
        
        // 如果已经注册过该键盘名 则将之前的删除
        if keyBordDict[key] != nil {
            keyBordDict.removeValueForKey(key)
        }
        keyBoard.hidden = true
        keyBordDict[key] = keyBoard
    }
    
    func showDefaultKeyBoard() {
        for value in keyBordDict.values {
            value.hidden = true
        }
    }
    
    func show(key:String) {
        
        for element in keyBordDict {
            element.1.hidden = element.0 != key
            element.1.superview?.bringSubviewToFront(element.1)
        }
        
    }
}


extension KeyBoardService {
    
    func setUpEmoji() {
        
        emojiView.backgroundColor = UIColor.whiteColor()
        let emojiContent = UIScrollView()
        emojiView.addSubview(emojiContent)
        
        emojiContent.snp_makeConstraints {[weak self] (make) in
            make.height.equalTo(180)
            make.width.equalTo(screenWidth)
            make.center.equalTo((self?.emojiView)!)
        }
        emojiContent.center = CGPointMake(screenWidth / 2.0, 110)
        emojiContent.showsHorizontalScrollIndicator = false
        emojiContent.pagingEnabled = true
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), {[weak self] in
            
            emojiContent.pagingEnabled = true
            var rects = [CGRect]()
            let h_space = (screenWidth - 260) / 6.0
            let v_space: CGFloat = 20
            var max_x: CGFloat = 0
            
            
            var index = -1
            while rects.count < TextEmotionParser.instance.emotions.count {
                
                index += 1
                if index % 28 == 6 {
                    continue
                }
                var x = CGFloat((index % 28) % 7) * (30 + h_space)
                x += (CGFloat(index / 28) * screenWidth) + 25
                let y = CGFloat((index % 28) / 7) * (30 + v_space)
                rects.append(CGRectMake(x, y, 30, 30))
                max_x = max(max_x, CGRectGetMaxX(rects.last!) + 25)
            }
            
            dispatch_async(dispatch_get_main_queue(), {	// 添加emoji
                
                var buttons = [UIButton]()
                for index in 0..<TextEmotionParser.instance.emotions.count {
                    let button = UIButton(frame: rects[index])
                    button.setBackgroundImage(TextEmotionParser.instance.emoticonMapper[TextEmotionParser.instance.emotions[index]]! as? UIImage, forState: .Normal)
                    
                    emojiContent.addSubview(button)
                    buttons.append(button)
                }
                // 调整 max_x
                if max_x > CGFloat(floor(max_x / screenWidth)) * screenWidth {
                    max_x = (floor(max_x / screenWidth) + 1) * screenWidth
                }
                
                // 添加删除按钮
                for index in 0..<Int(max_x / screenWidth) {
                    let button = UIButton(frame: CGRectMake(screenWidth * CGFloat(index) + screenWidth - 55, 0, 30, 30))
                    button.setBackgroundImage(UIImage(named: "会话_icon_删除emoji"), forState: .Normal)
                    //                    button.setBackgroundImage(UIImage(named: "会话窗口_icon_清除emoji_click"), forState: .Normal)
                    
                    emojiContent.addSubview(button)
                    buttons.append(button)
                }
                emojiContent.contentSize = CGSizeMake(max_x, 130)
                
                mqRxBindButton(buttons).subscribeNext({(index) in
                    
                    if let textView = self?.firstResponder as? BaseTextView {
                        if index < TextEmotionParser.instance.emotions.count {
                            textView.insertEmoji(TextEmotionParser.instance.emotions[index])
                        } else {
                            textView.deleteBackward()
                        }
                    }
                    
                }).addDisposableTo(self!.disposeBag)
                self?.add(self!.emojiView, key: KeyBoardService.emojiKey)
            })
            
        })

    }


}


