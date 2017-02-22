//
//  MomentDetailPrasersCell.swift
//  miaomiao.v2
//
//  Created by minbaba on 16/5/26.
//  Copyright © 2016年 MiaoquTech Inc. All rights reserved.
//

import UIKit
import RxSwift

class MomentDetailPrasersCell: UITableViewCell {
    
    var praserButtonList = [UIButton]()
    
    var avatorClicked = PublishSubject<Int>()
    
    var disposeBag: DisposeBag!
    
    
    
    dynamic var praiserList:[MomentPraiser]? {
    
        didSet {

            disposeBag = DisposeBag()
            if praiserList?.count < praserButtonList.count {
                for index in (praiserList?.count)!..<praserButtonList.count {
                    praserButtonList[index].removeFromSuperview()
                }
            }
        
            for index in 0..<praiserList!.count {
                
                let rect = CGRectMake(12 + CGFloat(index) * 35, 5, 30, 30)
                if CGRectGetMaxX(rect) > screenWidth - 12 {
                    break
                }
                
                let avator:UIButton!
                if index < praserButtonList.count {
                    avator = praserButtonList[index]
                } else {
                    avator = UIButton()
                    avator.imageView?.contentMode = .ScaleAspectFill
                    praserButtonList.append(avator)
                }
                
             
                
                avator.kf_setImageWithURL(praiserList![index].headPortrait.mqimageUrl(.Smallest), forState: .Normal, placeholderImage: placeHolderImage)
                avator.frame = rect
                contentView.addSubview(avator)
            }
            
            
            mqRxBindButton(praserButtonList).map {[weak self] (index) -> Int in
                self!.praiserList![index].userId
            }.bindTo(avatorClicked).addDisposableTo(disposeBag)
        }
        
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
//        contentView.snp_makeConstraints { (make) in
//            make.height.equalTo(40)
//            contentView.userInteractionEnabled = true
//        }
        
    }
    
}
