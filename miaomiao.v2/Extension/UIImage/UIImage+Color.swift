//
//  UIImage+Color.swift
//  miaomiao.v2
//
//  Created by minbaba on 16/4/28.
//  Copyright © 2016年 MiaoquTech Inc. All rights reserved.
//

import Foundation



extension UIImage {

    
    
    
    class func colorImage(color color:UIColor) -> UIImage {
        
        let rect = CGRectMake(0.0, 0.0, 1.0, 1.0);
        UIGraphicsBeginImageContext(rect.size);
        let context = UIGraphicsGetCurrentContext();
        
        CGContextSetFillColorWithColor(context, color.CGColor);
        CGContextFillRect(context, rect);
        
        let image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
        return image
    }
    
    class func colorImage(hexString hexColor:String) -> UIImage {
        
        let color = UIColor(hexStr: hexColor)
        let rect = CGRectMake(0.0, 0.0, 1.0, 1.0);
        UIGraphicsBeginImageContext(rect.size);
        let context = UIGraphicsGetCurrentContext();
        
        CGContextSetFillColorWithColor(context, color.CGColor);
        CGContextFillRect(context, rect);
        
        let image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
        return image
    }

    
    
}

func blurtImage(image: UIImage, radius: Float) -> UIImage? {
    let context = CIContext(options: nil)
    let inputImage = CIImage(image: image)
    let filter = CIFilter(name: "CIGaussianBlur")
    
    filter?.setValue(inputImage, forKey: kCIInputImageKey)
    filter?.setValue(radius, forKey: "inputRadius")
    
    guard let _ = filter else {
        return nil
    }
    
    // blur image
    let result: CIImage = filter!.valueForKey(kCIOutputImageKey)  as! CIImage
    let cgImage = context.createCGImage(result, fromRect: result.extent)
    
    return UIImage(CGImage: cgImage)
}
