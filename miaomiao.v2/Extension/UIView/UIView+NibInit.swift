//
//  UIView+NibInit.swift
//  miaomiao.v2
//
//  Created by minbaba on 16/8/22.
//  Copyright © 2016年 MiaoquTech Inc. All rights reserved.
//


extension UIView {
    class func loadFromNibNamed(nibNamed: String, bundle : NSBundle? = nil) -> UIView? {
        return UINib(
            nibName: nibNamed,
            bundle: bundle
            ).instantiateWithOwner(nil, options: nil)[0] as? UIView
    }
}
