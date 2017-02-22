//
//  String+Bounding.swift
//  miaomiao.v2
//
//  Created by minbaba on 16/4/25.
//  Copyright © 2016年 MiaoquTech Inc. All rights reserved.
//

import Foundation


extension String {

    
    func boundingRectWithSize(size: CGSize, options: NSStringDrawingOptions = [.UsesLineFragmentOrigin, .UsesFontLeading], attributes: [String : AnyObject]? = nil, context: NSStringDrawingContext? = nil) -> CGRect {
        return (self as NSString).boundingRectWithSize(size, options: options, attributes: attributes, context: context)
    }
    
}
