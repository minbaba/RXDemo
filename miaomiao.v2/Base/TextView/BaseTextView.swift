//
//  BaseTextView.swift
//  miaomiao.v2
//
//  Created by minbaba on 16/4/26.
//  Copyright © 2016年 MiaoquTech Inc. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa


class BaseTextView: UITextView {
    
    let disposeBag = DisposeBag()
    
    override var font: UIFont? {
        set {
            placeHolderLabel.font = newValue
            super.font = newValue
        }
        get {
            return super.font ?? FontSizeConf.Second.toFont()
        }
    }
    
    override var textColor: UIColor? {
        set {
            super.textColor = newValue
        }
        get {
            return super.textColor ?? ColorConf.Text.FirstTextColor.toColor()
        }
    }

    
    override var text: String! {
    
        set {
            self.attributedText = NSMutableAttributedString(string: newValue, attributes: [NSFontAttributeName: font!, NSForegroundColorAttributeName: textColor!])
        }
        get {
            return super.textStorage.plainString
        }
    }
    
    override var attributedText: NSAttributedString! {
        
        set {
            super.attributedText = TextEmotionParser.instance.parse(newValue.mutableCopy() as! NSMutableAttributedString)
        }
        get {
            return super.attributedText
        }
    }
    
    
    override var textContainerInset: UIEdgeInsets {
        set {
            
            placeHolderLabel.snp_updateConstraints { (make) in
                make.left.right.equalTo(3 + newValue.left)
                make.top.equalTo(newValue.top)
            }
            super.textContainerInset = newValue
        }
        get {
            return super.textContainerInset
        }
    }
    
    
    var placeHolder: String? {
    
        set {
            self.placeHolderLabel.text = newValue
        }
        get {
            return placeHolderLabel.text
        }
        
    }
    
    var placeHolderLabel = UILabel()
    
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        configure()
    }
    
    
    
    override init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: frame, textContainer: textContainer)
        configure()
    }
    
    
    func insertEmoji(emoji:String) {
        let att = TextEmotionParser.instance.parse(NSMutableAttributedString(string: emoji))
        self.textStorage.insertAttributedString(att, atIndex: selectedRange.location)
        
        self.selectedRange = NSMakeRange(selectedRange.location + 1, selectedRange.length)
    }
    
    /**
     基础配置，绑定响应
     */
    func configure() {
        
        self.font = FontSizeConf.Second.toFont()
        self.textColor = ColorConf.Text.FirstTextColor.toColor()
        self.placeHolderLabel.textColor = ColorConf.Text.SecondTextColor.toColor()
        
        for view in self.subviews {
            if view.isKindOfClass(NSClassFromString("_UITextContainerView")!) {
                view.addSubview(placeHolderLabel)
                placeHolderLabel.snp_updateConstraints { (make) in
                    make.left.right.equalTo(3)
                    make.top.equalTo(8)
                }
            }
        }
        
        self.rx_text.subscribeNext {[weak self] (str) in
            
            self?.textStorage.addAttributes([NSFontAttributeName: self?.font ?? UIFont.systemFontOfSize(0), NSForegroundColorAttributeName: self?.textColor ?? UIColor.whiteColor()], range: NSMakeRange(0, self?.textStorage.length ?? 0))
            self?.placeHolderLabel.hidden = str.characters.count > 0
        }.addDisposableTo(disposeBag)
        
    }

    
        /// 注册第一响应者
    var rx_becomeFirstResponder: ControlEvent<Void> {
        
        let source =  NSNotificationCenter.defaultCenter().rx_notification(UITextViewTextDidBeginEditingNotification, object: self)
        .map { _ in return }
        return ControlEvent(events: source)
    }

        /// 注销第一响应者
    var rx_resignFirstResponder: ControlEvent<Void> {
        
        let source = NSNotificationCenter.defaultCenter().rx_notification(UITextViewTextDidEndEditingNotification, object: self)
            .map{ _ in return }
        return ControlEvent(events: source)
    }
    
    
}
