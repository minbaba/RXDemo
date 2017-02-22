//
//  Observable+timeFilter.swift
//  miaomiao.v2
//
//  Created by minbaba on 16/5/1.
//  Copyright © 2016年 MiaoquTech Inc. All rights reserved.
//

import Foundation
import RxSwift

extension Observable {
    
    func fileter(minTimeInterval:NSTimeInterval) -> Observable<E> {

        var lastTime:NSTimeInterval!
        
        return self.mapWithIndex { ($0, $1, NSDate().timeIntervalSince1970) }.filter { (element, index, time) -> Bool in
            
            if index == 0 {
                lastTime = time
                return true
            }
            if time - lastTime > minTimeInterval {
                lastTime = time
                return true
            }
            
            return false
            }.map{ $0.0 }
    }
    
}
