//
//  UIImage+corenerRadius.swift
//  miaomiao.v2
//
//  Created by minbaba on 16/8/16.
//  Copyright © 2016年 MiaoquTech Inc. All rights reserved.
//

import Foundation


extension UIImage {
    func mbb_drawRectWithRoundedCorner(radius radius: CGFloat, _ sizetoFit: CGSize, corners: UIRectCorner = .AllCorners) -> UIImage {
        let rect = CGRect(origin: CGPoint(x: 0, y: 0), size: sizetoFit)
        
        UIGraphicsBeginImageContextWithOptions(rect.size, false, UIScreen.mainScreen().scale)
        CGContextAddPath(UIGraphicsGetCurrentContext(),
                         UIBezierPath(roundedRect: rect, byRoundingCorners: corners,
                            cornerRadii: CGSize(width: radius, height: radius)).CGPath)
        CGContextClip(UIGraphicsGetCurrentContext())
        
        self.drawInRect(rect)
        CGContextDrawPath(UIGraphicsGetCurrentContext(), .FillStroke)
        let output = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
        
        return output
    }
    
//    func mbb_drawRectWithRoundedCorner(radius radius: CGFloat, _ sizetoFit: CGSize) -> UIImage {
//        let rect = CGRect(origin: CGPoint(x: 0, y: 0), size: sizetoFit)
//        
//        UIGraphicsBeginImageContextWithOptions(rect.size, false, UIScreen.mainScreen().scale)
//        CGContextAddPath(UIGraphicsGetCurrentContext(),
//                         UIBezierPath(roundedRect: rect, byRoundingCorners: UIRectCorner.AllCorners,
//                            cornerRadii: CGSize(width: radius, height: radius)).CGPath)
//        CGContextClip(UIGraphicsGetCurrentContext())
//        
//        self.drawInRect(rect)
//        CGContextDrawPath(UIGraphicsGetCurrentContext(), .FillStroke)
//        let output = UIGraphicsGetImageFromCurrentImageContext();
//        UIGraphicsEndImageContext();
//        
//        return output
//    }
}
