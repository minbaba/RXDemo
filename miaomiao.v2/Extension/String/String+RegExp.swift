//
//  String+RegExp.swift
//  miaomiao.v2
//
//  Created by minbaba on 16/4/7.
//  Copyright © 2016年 MiaoquTech Inc. All rights reserved.
//

import Foundation




struct RegexHelper {
    var regex: NSRegularExpression?
    
    init(pattern: String) {
        
        do {
           try regex = NSRegularExpression(pattern: pattern,
                                        options: .CaseInsensitive)
        } catch {
            print(error)
        }
    }
    
    func match(input: String) -> Bool {
        if let matches = regex?.matchesInString(input,
                                                options: NSMatchingOptions.ReportProgress,
                                                range: NSMakeRange(0, input.characters.count)) {
            return matches.count > 0
        } else {
            return false
        }
    }
}

infix operator =~ {
associativity none
precedence 130
}

func =~(lhs: String, rhs: String) -> Bool {
    return RegexHelper(pattern: rhs).match(lhs)
}
