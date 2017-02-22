//
//  BaseCollectionView.swift
//  miaomiao.v2
//
//  Created by minbaba on 16/7/28.
//  Copyright © 2016年 MiaoquTech Inc. All rights reserved.
//

import UIKit

class BaseCollectionView: UICollectionView {

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        setUp()
    }
    
    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: layout)
        
        setUp()
    }
    
    func setUp() {
        
    }
    
}
