//
//  TextParser.swift
//  miaomiao.v2
//
//  Created by 郑敏 on 16/4/26.
//  Copyright © 2016年 MiaoquTech Inc. All rights reserved.
//

import Foundation


protocol TextParserType {
    
    func parse(text:String) -> NSAttributedString ;
}


class TextEmotionParser: TextParserType {
    
    func parse(text: String) -> NSAttributedString {
        
        
        return NSAttributedString()
    }
    
}