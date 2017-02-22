//
//  ChooseAlertManager.swift
//  miaomiao.v2
//
//  Created by minbaba on 16/7/2.
//  Copyright © 2016年 MiaoquTech Inc. All rights reserved.
//

import UIKit
import RxSwift

class ChooseAlertManager: AlertManager {

    var back: ChooseAlertBackGround!
    var buttonClicked: Observable<Int>? {
        return back.buttonsClicked
    }
    
    convenience init(title: String?, view: UIView, buttons: [String]? = nil, onOk: ((ChooseAlertManager) -> Void)? = nil) {
        self.init()
        
        back = ChooseAlertBackGround(view: view, title: title, buttons: buttons ?? ["确定"])
        
        self.displayView = back
        
        if buttons == nil || buttons?.count == 1 {
            back.buttonsClicked?.subscribeNext({ [weak self] (_) in
                onOk?(self!)
                self?.hide(true, completed: nil)
            }).addDisposableTo(disposeBag)
        }
    }
    
    class func hintStyleAlert(title: String, buttons: [String]?) -> ChooseAlertManager {
        let label = Factory.firstLabel
        label.frame = CGRectMake(0, 0, 240, 100)
        label.text = title
        label.textAlignment = .Center
        return ChooseAlertManager(title: nil, view: label, buttons: buttons)
    }
}
