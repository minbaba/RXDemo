//
//  EmojiTextAttachment.swift
//  miaomiao.v2
//
//  Created by minbaba on 16/5/25.
//  Copyright © 2016年 MiaoquTech Inc. All rights reserved.
//

import UIKit

class EmojiTextAttachment: NSTextAttachment {

    var originText = ""
}


extension NSAttributedString {

    var plainString:String {
        
        let str = NSMutableString(string: self.string)
        var base = 0
        
        self.enumerateAttribute(NSAttachmentAttributeName, inRange: NSMakeRange(0, self.length), options: NSAttributedStringEnumerationOptions(rawValue: 0)) { (value, range, stop) in
            
            
            if let att = value as? EmojiTextAttachment {
                
                str.replaceCharactersInRange( NSMakeRange(range.location + base, range.length), withString: att.originText)
                
                base += att.originText.characters.count - 1
            }
            
        }
        
        
        return str as String
    }
    
    
}
