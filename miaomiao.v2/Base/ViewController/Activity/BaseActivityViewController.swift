//
//  BaseActivityViewController.swift
//  miaomiao.v2
//
//  Created by minbaba on 16/7/22.
//  Copyright © 2016年 MiaoquTech Inc. All rights reserved.
//

import UIKit
import RxSwift

class BaseActivityViewController: BaseViewController {

    
    static let adHeight: CGFloat = 65
    
    
    let listTb = RefreshTableView()
    
    let adHeader = UIButton(frame: CGRectMake(0, -adHeight, screenWidth, adHeight))
    
    var seted = false
    
    
    func setupAdHeader(picName: String, urlName: String, tapHiden: Bool = false) {
        if seted { return }
        seted = true
        
        adHeader.backgroundColor = ColorConf.Text.SelectedBlue.toColor()
        adHeader.rx_tap.subscribeNext { [weak self] (_) in
            
            if tapHiden {
                self?.adHeader.removeFromSuperview()
                self?.listTb.contentInset = UIEdgeInsetsZero
            }
            
            guard let activity = AppInfoService.instance.activity else {
                return
            }
            
            let vc = LotteryViewController()
            vc.url = activity.valueForKey(urlName) as? String ?? ""
            vc.hidesBottomBarWhenPushed = true
            self?.pushViewController(vc)
            }.addDisposableTo(disposeBag)
        
        listTb.rx_contentOffset.subscribeNext {[weak self] (point) in
            let yOffset: CGFloat = point.y
            if yOffset < -BaseActivityViewController.adHeight {
                var f: CGRect = self?.adHeader.frame ?? CGRectZero
                f.origin.y = yOffset
                self?.adHeader.frame = f
            }
            }.addDisposableTo(disposeBag)
        
        AppInfoService.instance.rx_isVerifyed.subscribeNext {[weak self] (b) in
            
            let b = b && AppInfoService.instance.isEnableActivities > 0
            self?.listTb.contentInset = UIEdgeInsetsMake( b ? BaseActivityViewController.adHeight: 0, 0, 0, 0)
            if b {
                guard let header = self?.adHeader else {
                    return
                }
                self?.listTb.addSubview(header)
                self?.adHeader.kf_setImageWithURL(NSURL(string: AppInfoService.instance.activity?.valueForKey(picName) as? String ?? "")!, forState: .Normal, placeholderImage: placeHolderImage)
                
            } else {
                self?.adHeader.removeFromSuperview()
            }
            }.addDisposableTo(disposeBag)
        if let viewModel = self.valueForKey("viewModel") as? BaseViewModel {
            viewModel.rx_requestComplete.observeOn(MainScheduler.instance).subscribeNext {[weak self] (_) in
                UIView.animateWithDuration(0.4, animations: {
                    self?.adHeader.frame = CGRectMake(0, -BaseActivityViewController.adHeight, screenWidth, BaseActivityViewController.adHeight)
                })
                }.addDisposableTo(disposeBag)
        }
    }
    
}
