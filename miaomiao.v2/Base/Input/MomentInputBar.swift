//
//  MomentInputBar.swift
//  miaomiao.v2
//
//  Created by minbaba on 16/5/27.
//  Copyright © 2016年 MiaoquTech Inc. All rights reserved.
//

import UIKit
import RxSwift

class MomentInputBar: UIView {

    @IBOutlet var inputBar: UIView!
    @IBOutlet weak var textInput: BaseTextView!
    @IBOutlet weak var textHeight: NSLayoutConstraint!
    @IBOutlet weak var commitButton: UIButton!
    @IBOutlet weak var emojiButton: UIButton!
    
    let disposeBag = DisposeBag()
    
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setUp()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUp()
    }
    
    func setUp() {
        NSBundle.mainBundle().loadNibNamed("MomentInputBar", owner: self, options: nil)
        addSubview(inputBar)
        inputBar.snp_makeConstraints { (make) in
            make.top.left.bottom.right.equalTo(0)
        }
        
        textInput.textContainerInset = UIEdgeInsetsMake(0, 0, 0, 0)
        textInput.rx_text.subscribeNext {[weak self] (_) in
            
            self?.textHeight.constant = min(CGFloat(100.0), max(CGFloat(15.0), (self?.textInput.contentSize.height)!))
            
            }.addDisposableTo(disposeBag)
        
        emojiButton.rx_tap.subscribeNext {[weak self] (_) in
            self?.emojiButton.selected = !self!.emojiButton.selected
            if self!.emojiButton.selected {
                KeyBoardService.instance.show(KeyBoardService.emojiKey)
                self?.textInput.becomeFirstResponder()
            } else {
                KeyBoardService.instance.showDefaultKeyBoard()
            }
            }.addDisposableTo(disposeBag)
        textInput.rx_becomeFirstResponder.map { false }.bindTo(emojiButton.rx_selected).addDisposableTo(disposeBag)
        
        textInput.rx_becomeFirstResponder.subscribeNext {[weak self] (_) in
            self?.textHeight.constant = min(CGFloat(100.0), max(CGFloat(15.0), (self?.textInput.contentSize.height)!))
            }.addDisposableTo(disposeBag)
        textInput.rx_resignFirstResponder.subscribeNext {[weak self] (_) in
            self?.textHeight.constant = 15
            }.addDisposableTo(disposeBag)

    }
    
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        textInput.becomeFirstResponder()
    }
    
}
