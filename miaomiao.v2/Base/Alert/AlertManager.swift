//
//  AlertManager.swift
//  miaomiao.v2
//
//  Created by minbaba on 16/5/19.
//  Copyright © 2016年 MiaoquTech Inc. All rights reserved.
//

import UIKit
import RxSwift

class AlertManager: NSObject {
    
    
    var rx_hidenEvent:Observable<Void>! {
    
        didSet {
            
            rx_hidenEvent.subscribeNext({[weak self] (_) in
                self?.hide(true, completed: nil)
            }).addDisposableTo(disposeBag)
            
        }
    
    }
    
    var onHiden: completeHander?
    
    var touchHide = true
    
    
    
    var displayView:UIView? {
        
        didSet {
            
            if let _ = oldValue {
                oldValue?.removeFromSuperview()
            }
            
            guard let _ = displayView else {
                return
            }
            maskView.addSubview(displayView!)
            displayView?.center = CGPointMake(screenWidth / 2, screenHeight / 2)
        }
    }
    
    let maskView = UIButton(type: .Custom)
    let disposeBag = DisposeBag()
    
//    static private var ins:AlertManager?
    
    static private var showingArr = [AlertManager]()
    
    override init() {
        
        super.init()
        
        maskView.frame = CGRectMake(0, 0, screenWidth, screenHeight)
        maskView.backgroundColor = UIColor(hexStr: "0000000", alpha: 0.3)
        maskView.rx_tap.subscribeNext {[weak self] (_) in
            if (self?.touchHide ?? false) { self?.hide(true, completed: nil) }
        }.addDisposableTo(disposeBag)
        
    }
    
//    convenience init(displayView:UIView) {
//        
//        self.init()
//        self.displayView = displayView
//    }
    
    
    func show(animated:Bool, completed:((Void) -> Void)?, onHiden: completeHander? = nil) {
        
        self.onHiden = onHiden
        let window = UIApplication.sharedApplication().keyWindow
        window?.addSubview(maskView)
        
        AlertManager.showingArr.append(self)
        completed?()
    }
    
    func hide(animated:Bool, completed:((Void) -> Void)?) {
        
        maskView.removeFromSuperview()
        completed?()
        
        if let index = AlertManager.showingArr.indexOf(self) {
            AlertManager.showingArr.removeAtIndex(index)
        }
        self.onHiden?()
    }
}
