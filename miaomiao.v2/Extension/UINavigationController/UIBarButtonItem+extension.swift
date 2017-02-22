//
//  UIBarButtonItem+extension.swift
//  miaomiao.v2
//
//  Created by minbaba on 16/7/7.
//  Copyright © 2016年 MiaoquTech Inc. All rights reserved.
//

import Foundation
import RxSwift


var mq_item_tap_key: UInt8 = 0
var mq_item_dispose_key: UInt8 = 0



extension UIBarButtonItem {
    
    var mq_tap: PublishSubject<Void> {
        
        if let value = objc_getAssociatedObject(self, &mq_item_tap_key) {
            return value as! PublishSubject<Void>
        }
        
        let observer = PublishSubject<Void>()
        self.rx_tap.bindTo(observer).addDisposableTo(disposeBag)
        
        objc_setAssociatedObject(self, &mq_item_tap_key, observer, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        return observer
    }
    
    private var disposeBag: DisposeBag {
        if let value = objc_getAssociatedObject(self, &mq_item_dispose_key) {
            return value as! DisposeBag
        }
        
        let dis = DisposeBag()
        
        objc_setAssociatedObject(self, &mq_item_dispose_key, dis, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        
        return dis
    }
    
    
}
