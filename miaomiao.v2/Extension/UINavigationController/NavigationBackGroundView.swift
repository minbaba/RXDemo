//
//  NavigationBackGroundView.swift
//  miaomiao.v2
//
//  Created by minbaba on 16/4/25.
//  Copyright © 2016年 MiaoquTech Inc. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift


class NavigationBackGroundView: UIView {
    
    
    let control:UIControl = UIControl()
    var nav:UINavigationController?
    
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = ColorConf.View.NavigationBar.toColor()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        
        guard let nav = self.nav else {
            return
        }
        let point = touches.first?.locationInView(self)
        
        if point?.x < 64 {
            nav.viewControllers.last?.navigationItem.leftBarButtonItem?.mq_tap.onNext()
            
        } else if point!.x > self.frame.size.width - 64 {
            
            nav.viewControllers.last?.navigationItem.rightBarButtonItem?.mq_tap.onNext()
        }
        
        
    }

}
