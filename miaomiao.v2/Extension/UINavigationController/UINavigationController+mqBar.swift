//
//  UINavigationController+mqBar.swift
//  miaomiao.v2
//
//  Created by minbaba on 16/4/25.
//  Copyright © 2016年 MiaoquTech Inc. All rights reserved.
//

import Foundation

extension UINavigationController {
    
    
    var hideBar:Bool {
        
        get {
        
            var hide = true
            
            for view in self.navigationBar.subviews {
                
                if view.isKindOfClass(NSClassFromString("_UINavigationBarBackground")!) {
                    hide = view.hidden
                }
            }
            
            return hide
        }
    
        set {
        
            if let view = navigationBar.viewWithTag(100) {
                
                view.hidden = !newValue
            } else {
                let view = NavigationBackGroundView(frame: CGRectMake(0, -20, screenWidth, 64))
                view.nav = self
                view.tag = 100
                view.backgroundColor = ColorConf.View.NavigationBar.toColor()
                self.navigationBar.insertSubview(view, atIndex: 0)
                view.hidden = !newValue
            }
            
            for view in self.navigationBar.subviews {
                
                if view.isKindOfClass(NSClassFromString("_UINavigationBarBackground")!) {
                    view.hidden = newValue
                }
            }
            
        }
    
    }
    
    var customBar: UIView? {
        return self.navigationBar.viewWithTag(100)
    }
    
    

    
    var customStyle:Bool  {
        
        get {
            return self.customStyle
        }
        
        set(show) {
            
            if show {
                
                if #available(iOS 8.2, *) {
                    self.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName:ColorConf.Text.White.toColor(), NSFontAttributeName:UIFont.systemFontOfSize(17, weight: 2)]
                } else {
                    self.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName:ColorConf.Text.White.toColor(), NSFontAttributeName:UIFont.systemFontOfSize(17)]
                }
                
//                self.navigationBar.translucent = false
                
                UINavigationBar.appearance().barTintColor = UIColor(hexStr: "202020")
                
            } else {
//                self.navigationBar.viewWithTag(100)?.removeFromSuperview()
            }
        }
        
    }
    
}

