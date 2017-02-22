//
//  String+secret.swift
//  miaomiao.v2
//
//  Created by minbaba on 16/4/7.
//  Copyright © 2016年 MiaoquTech Inc. All rights reserved.
//

import Foundation


// MARK: - 给string 增加MD5 和base64 功能
extension String {
    
    /// md5后的string
    var md5Str:String {
        let cStr = (self as NSString).UTF8String
        let buffer = UnsafeMutablePointer<UInt8>.alloc(16)
        CC_MD5(cStr,(CC_LONG)(strlen(cStr)), buffer)
        let md5String:NSMutableString = NSMutableString();
        for i in 0 ..< 16 {
            md5String.appendFormat("%02X", buffer[i])
        }
        free(buffer)
        return String(md5String);
    }
    
    /// base64后的string
    var base64Str:String {
        let plainData = self.dataUsingEncoding(NSUTF8StringEncoding)
        return (plainData?.base64EncodedStringWithOptions(.Encoding64CharacterLineLength))!
    }
    
    
    var urlEncoding: String {
        let encodedString: String = CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault, (self as CFStringRef), nil, ("!*'();:@&=+$,/?%#[]"), kCFStringEncodingASCII) as String
        return encodedString

    }
}
