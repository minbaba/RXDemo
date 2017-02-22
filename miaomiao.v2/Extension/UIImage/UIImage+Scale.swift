//
//  UIImage+Scale.swift
//  miaomiao.v2
//
//  Created by minbaba on 16/5/23.
//  Copyright © 2016年 MiaoquTech Inc. All rights reserved.
//

import Foundation


var imagePressRound = 0


func injectFace(image: UIImage?) -> Bool {
    if let image = image {
        let detector = CIDetector(ofType: CIDetectorTypeFace, context: nil, options: [CIDetectorAccuracy: CIDetectorAccuracyHigh])
        
        
        let arr = detector.featuresInImage(CIImage(image: image)!) as? [CIFaceFeature]
        
        for feature in arr ?? [] {
            if feature.hasLeftEyePosition && feature.hasRightEyePosition && feature.hasMouthPosition {
                return true
            }
        }
    }
    return false
}


extension UIImage {
    func dynamicImage() -> UIImage {
        let newImage: UIImage = self.resize(1080)
        imagePressRound = 0
        return newImage.press(500 << 10)
    }
    
    func headImage() -> UIImage {
        let newImage: UIImage = self.resize(720)
        imagePressRound = 0
        return newImage.press(500 << 20)
    }
    
    func marketImage() -> UIImage {
        let newImage: UIImage = self.resize(720)
        imagePressRound = 0
        return newImage.press(500 << 20)
    }
    
    
    
    

    func press(than: Int) -> UIImage {
        var jpegData: NSData = UIImageJPEGRepresentation(self, 1)!
        if jpegData.length > than {
            jpegData = UIImageJPEGRepresentation(self, 0.8)!
            if jpegData.length < than || imagePressRound > 10 {
                return UIImage(data: jpegData)!
            } else {
                imagePressRound += 1
                return UIImage(data: jpegData)!.press(than)
            }
        } else {
            return UIImage(data: jpegData)!
            
        }
    }
    
    
    func resize(to: Float) -> UIImage {
        if self.size.height < CGFloat(to) && self.size.width < CGFloat(to) {
            return self
        }
        var targetHeight: CGFloat
        var targetWidth: CGFloat
        let bili: CGFloat = self.size.width/self.size.height
        if bili > 1 {
            targetWidth = CGFloat(to)
            targetHeight = targetWidth/bili
        } else {
            targetHeight = CGFloat(to)
            targetWidth = targetHeight*bili
            
        }
        UIGraphicsBeginImageContext(CGSizeMake(targetWidth, targetHeight))
        self.drawInRect(CGRectMake(0, 0, targetWidth, targetHeight))
        let newImage: UIImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage
    }
    
    
}
