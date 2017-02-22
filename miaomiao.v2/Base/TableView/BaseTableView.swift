//
//  BaseTableView.swift
//  miaomiao.v2
//
//  Created by minbaba on 16/7/7.
//  Copyright © 2016年 MiaoquTech Inc. All rights reserved.
//

import UIKit

class BaseTableView: UITableView {
    
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        setUp()
    }
    
    override init(frame: CGRect, style: UITableViewStyle) {
        super.init(frame: frame, style: style)
        
        setUp()
    }

    convenience init() {
        self.init(frame: CGRectZero, style: .Plain)
    }
    
    func setUp() {
        
    }

    
    
}
