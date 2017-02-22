//
//  String+time.swift
//  miaomiao.v2
//
//  Created by minbaba on 16/5/18.
//  Copyright © 2016年 MiaoquTech Inc. All rights reserved.
//

import Foundation



extension NSDateFormatter {
    
    private static var mq_dateFormatter:NSDateFormatter?

    static var mqFormatter: NSDateFormatter {
        if NSDateFormatter.mq_dateFormatter == nil {
            NSDateFormatter.mq_dateFormatter = NSDateFormatter()
            NSDateFormatter.mq_dateFormatter!.dateFormat = "yyyy-MM-dd HH:mm:ss"
        }
        return NSDateFormatter.mq_dateFormatter!
    }
    
}


extension String {
    
    
    
    
    var toDate:NSDate {
        
        
        
        return NSDateFormatter.mqFormatter.dateFromString(self) ?? NSDate()
    }
}
