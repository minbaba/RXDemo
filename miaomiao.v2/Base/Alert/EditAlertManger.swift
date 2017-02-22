//
//  EditAlertManger.swift
//  miaomiao.v2
//
//  Created by minbaba on 16/8/25.
//  Copyright © 2016年 MiaoquTech Inc. All rights reserved.
//

import UIKit

class EditAlertManger: ChooseAlertManager {
    
   
    var textField: UITextField!
    
    

    convenience init(title: String?, onOk: ((String) -> Void)? = nil) {
        
        let view = UIView(frame: CGRectMake(0, 0, screenWidth - 24, 110))
        let textField = UITextField(frame: CGRectMake(20, 40, screenWidth - 64, 30))
        textField.borderStyle = .None
        textField.layer.addSublayer(Factory.seprator(CGRectMake(0, 29.5, screenWidth - 64, 0.5)))
        view.addSubview(textField)
        
        self.init(title: title, view: view, buttons: ["取消", "确定"], onOk: nil)
        
        self.textField = textField
        self.buttonClicked?.subscribeNext({ [weak self] (index) in
            
            if index == 1 { onOk?(self?.textField.text ?? "") }
            self?.hide(true, completed: nil)
        
            }).addDisposableTo(disposeBag)
        
        
//        NSNotificationCenter.defaultCenter().rx_notification(UIKeyboardWillChangeFrameNotification).subscribeNext { (notifycation) in
//            
//        }
        
    }

    
}
