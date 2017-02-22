//
//  NSDate+Extension.swift
//  miaomiao.v2
//
//  Created by minbaba on 16/6/25.
//  Copyright © 2016年 MiaoquTech Inc. All rights reserved.
//

import Foundation

extension NSDate {

    var astro: String {
        
        let m = self.components.month
        let d = self.components.day
        let astroString: NSString = "魔羯水瓶双鱼白羊金牛双子巨蟹狮子处女天秤天蝎射手魔羯"
        let astroFormat: NSString = "102123444543"
        var result: String
        result = "\(astroString.substringWithRange(NSMakeRange(m * 2 - (d < (Int(astroFormat.substringWithRange(NSMakeRange((m - 1), 1)))! + 19) ? 1: 0) * 2, 2)))"
        return result

    }
    
}
