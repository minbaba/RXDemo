//
//  String+sub.swift
//  miaomiao.v2
//
//  Created by minbaba on 16/4/12.
//  Copyright © 2016年 MiaoquTech Inc. All rights reserved.
//

import Foundation

extension String {
    subscript (r: Range<Int>) -> String {
        get {
            let startIndex = self.startIndex.advancedBy(r.startIndex)
            let endIndex = self.startIndex.advancedBy(r.endIndex)
            
            return self[startIndex..<endIndex]
        }
    }
}
