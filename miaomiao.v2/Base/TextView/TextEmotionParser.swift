//
//  TextParser.swift
//  miaomiao.v2
//
//  Created by minbaba on 16/4/26.
//  Copyright © 2016年 MiaoquTech Inc. All rights reserved.
//

import Foundation




protocol TextParserType {
    
    func parse(text:NSMutableAttributedString, range:NSRange) -> NSMutableAttributedString
}


class TextEmotionParser: TextParserType {
    
    static let instance = TextEmotionParser()
    
    
    var regex:NSRegularExpression!
    var mapper:NSDictionary!
    var lock:OSSpinLock!
    
    var mutex = pthread_mutex_t()
    
    
    var emotions: [String]!
    
    var emoticonMapper:NSDictionary! {
        
        didSet {
            
        }
        
    }
    
    
    private init() {

        pthread_mutex_init(&mutex, nil)
        
        var dict = [String: UIImage]()
        
        let arr = ["得意", "坏笑", "大笑", "墨镜微笑", "害羞", "墨镜坏笑", "笑哭", "哭", "坏笑_2", "捂嘴笑", "可怜", "白眼", "汗", "亲亲", "色", "期待", "钱", "蒙眼", "拜拜", "拍拍手", "委屈", "挖鼻子", "摸摸头", "问号", "鄙视", "怒", "喷", "调皮", "睡", "晕", "蒙面吻", "你TM在逗我", "囧", "WTF_惊", "狂汗", "囧哭", "不适", "吐", "邪恶", "赞", "OK", "心", "心碎", "便便"]
        
        
        emotions = arr.map { "[/" + $0 + "]" }
        
        for emotion in arr {
            
            dict["[/" + emotion + "]"] = UIImage(named: "emoji_" + emotion)
        }
        self.emoticonMapper = dict
        
        
        
        pthread_mutex_lock(&mutex)
        mapper = emoticonMapper.copy() as! NSDictionary
        if mapper.count == 0 {
            regex = nil
        } else {
            var pattern = "("
            var allKeys: [AnyObject] = mapper.allKeys
            let charset: NSCharacterSet = NSCharacterSet(charactersInString: "$^?+*.,#|{}[]()\\")
            
            for index in 0..<allKeys.count {
                
                let one: NSMutableString = allKeys[index].mutableCopy() as! NSMutableString
                
                // escape regex characters
                
                var cmax = one.length
                var subIndex = 0
                while subIndex < cmax {
                    let c = one.characterAtIndex(subIndex)
                    if charset.characterIsMember(c) {
                        one.insertString("\\", atIndex: subIndex)
                        subIndex += 1
                        cmax += 1
                    }
                    subIndex += 1
                }
                pattern += one as String
                if index != allKeys.count - 1 {
                    pattern += "|"
                }
            }
            pattern += ")"
            
            do {
                try regex = NSRegularExpression(pattern: pattern, options: NSRegularExpressionOptions(rawValue: 0))
            } catch {
                
            }
        }
        pthread_mutex_unlock(&mutex)

    }
    
    
    
    func replaceRange(range:NSRange, length:Int, inout selectedRange:NSRange) -> NSRange {
        // no change
        if range.length == length {
            return selectedRange
        }
        // right
        if range.location >= selectedRange.location+selectedRange.length {
            return selectedRange
        }
        // left
        if selectedRange.location >= range.location+range.length {
            selectedRange.location = selectedRange.location + length - range.length
            return selectedRange
        }
        // same
        if NSEqualRanges(range, selectedRange) {
            selectedRange.length = length
            return selectedRange
        }
        // one edge same
        if (range.location == selectedRange.location && range.length < selectedRange.length) || (range.location+range.length == selectedRange.location+selectedRange.length && range.length < selectedRange.length) {
            selectedRange.length = selectedRange.length+length-range.length
            return selectedRange
        }
        selectedRange.location = range.location+length
        selectedRange.length = 0
        return selectedRange
    }
    
    
    
    func parse(text: NSMutableAttributedString, range:NSRange = NSMakeRange(0, 0)) -> NSMutableAttributedString {
        
    
        var mapper: NSDictionary?
        var regex: NSRegularExpression?

        pthread_mutex_lock(&mutex)
        mapper = self.mapper
        regex = self.regex
        pthread_mutex_unlock(&mutex)
        
        if mapper!.count == 0 || regex == nil {
            return text
        }
        var matches = regex!.matchesInString(text.string, options: .ReportProgress, range: NSMakeRange(0, text.length))
        if matches.count == 0 {
            return text
        }

        var selectedRange = range ?? NSMakeRange(0, 0)
        var cutLength = 0
        
        let max = matches.count
        for index in 0..<max {
            let one: NSTextCheckingResult = matches[index] 
            var oneRange: NSRange = one.range
            if oneRange.length == 0 {
                continue
            }
            oneRange.location -= cutLength
            let subStr: String = (text.string as NSString).substringWithRange(oneRange)
            let emoticon = mapper?.objectForKey(subStr) as? UIImage
            
            if emoticon == nil {
                continue
            }
            let fontSize: CGFloat = 18
            // CoreText default value
//            let font = UIFont.systemFontOfSize(fontSize)
//            var emotionSize: CGFloat = fontSize
//            emotionSize = 18
            
            let textAttachment = EmojiTextAttachment()
            textAttachment.image = emoticon
            textAttachment.bounds = CGRectMake(0, 0 ,fontSize, fontSize)
            textAttachment.originText = subStr
            let rep = NSAttributedString(attachment: textAttachment)
            text.replaceCharactersInRange(oneRange, withAttributedString: rep)
            
            selectedRange.location += 1
            
            cutLength += oneRange.length - 1
        }
        
        return text
        
        
//        for var i: UInt = 0
//        
//        var max: UInt = matches.count ; i < max ; i++ {
//            
//        }
//        if range {
//            *range = selectedRange
//        }
//        
//        return NSAttributedString()
    }
    
    
    
    
}
