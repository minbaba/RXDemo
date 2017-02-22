//
//  BottomAlertManager.swift
//  miaomiao.v2
//
//  Created by minbaba on 16/6/2.
//  Copyright © 2016年 MiaoquTech Inc. All rights reserved.
//

import UIKit

class BottomAlertManager: AlertManager {

    var view:UIView? {
        didSet {
            if let _ = view {
                var frame = self.view!.frame
                frame.origin = CGPointMake(frame.origin.x, screenHeight)
                self.view?.frame = frame
                maskView.addSubview(view!)
            }
        }
    }
    
    
    
    
    override func show(animated: Bool, completed: ((Void) -> Void)?, onHiden: completeHander? = nil) {
        
        guard let _ = view else {
            return
        }
        
        self.maskView.addSubview(view!)
        
        var frame = self.view!.frame
        frame.origin = CGPointMake(frame.origin.x, screenHeight - frame.size.height)
        if animated {
            UIView.animateWithDuration(0.2, animations: {
                self.view!.frame = frame
            })
        } else {
            self.view!.frame = frame
        }
        super.show(animated, completed: completed, onHiden: onHiden)
    }
    
    override func hide(animated: Bool, completed: ((Void) -> Void)?) {
        guard let _ = view else {
            return
        }
        
        var frame = self.view!.frame
        frame.origin = CGPointMake(frame.origin.x, screenHeight)
        if animated {
            UIView.animateWithDuration(0.2, animations: {
                self.view!.frame = frame
                }, completion: { (b) in
                    self.view!.removeFromSuperview()
            })
        } else {
            self.view!.frame = frame
        }
        super.hide(animated, completed: completed)
    }
    
}
