//
//  Double+Money.swift
//  miaomiao.v2
//
//  Created by minbaba on 16/6/2.
//  Copyright © 2016年 MiaoquTech Inc. All rights reserved.
//

import UIKit

extension Double {
    
    
    var moneyStr: String {
        
        return String(format: "%.2f", self)
    }
    
    
}



extension Int {
    var moneyStr: String {
        return String(format: "%.2f", self)
    }
    
}

extension Float {
    var moneyStr: String {
        return String(format: "%.2f", self)
    }
    
}
