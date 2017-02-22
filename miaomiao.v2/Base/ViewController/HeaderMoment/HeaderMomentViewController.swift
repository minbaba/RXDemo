//
//  HeaderMomentViewController.swift
//  miaomiao.v2
//
//  Created by minbaba on 16/4/26.
//  Copyright © 2016年 MiaoquTech Inc. All rights reserved.
//

import UIKit
import RxSwift

class HeaderMomentViewController: MomentViewController {

    /// 表头
    @IBOutlet var tbHeader: UIView!
    /// 表头背景图
    @IBOutlet weak var headerImage: UIImageView!
    /// 头像
    @IBOutlet weak var headerAvator: UIImageView!
    /// 昵称
    @IBOutlet weak var headerName: UILabel!
    
    
    var navAlpha: CGFloat = 1
    

    override func loadView() {
        super.loadView()
        NSBundle.mainBundle().loadNibNamed("HeaderMomentViewController", owner: self, options: nil)
    }
    
    
    
    override func setUpUI() {
        self.automaticallyAdjustsScrollViewInsets = false
        
        let header = UIView(frame: CGRectMake(0, 0, screenWidth, 40))
        header.backgroundColor = UIColor.whiteColor()
        listTb.tableHeaderView = header
        
        headerAvator.mq_setCornerRadius(2.5)
        headerAvator.mq_setBorderColor(UIColor.whiteColor(), width: 1)
        listTb.contentInset = UIEdgeInsetsMake(188, 0, 0, 0)
        tbHeader.frame = CGRectMake(0, -188, screenWidth, 188)
        listTb.addSubview(tbHeader)
    }
    
    
    override func bindViewModel() {
        
        listTb.rx_contentOffset.subscribeNext {[weak self] (point) in
            let yOffset: CGFloat = point.y
            if yOffset < -188 {
                var f: CGRect = self?.tbHeader.frame ?? CGRectZero
                f.origin.y = yOffset
                self?.tbHeader.frame = f
            }
            
            self?.navAlpha = min(max(yOffset / 100.0 + 1, 0), 1)
            self?.navigationController?.customBar?.alpha = self!.navAlpha

        }.addDisposableTo(disposeBag)
        
        
        viewModel.rx_requestComplete.observeOn(MainScheduler.instance).subscribeNext {[weak self] (_) in
            UIView.animateWithDuration(0.4, animations: {
                self?.tbHeader.frame = CGRectMake(0, -188, screenWidth, 188)
            })
            }.addDisposableTo(disposeBag)
    }
    
   

}


extension HeaderMomentViewController {
    
   
    
    override func viewWillAppear(animated: Bool){
        super.viewWillAppear(animated)
        
        
        listTb.snp_updateConstraints { (make) in
            make.top.bottom.equalTo(0)
        }
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        navigationController?.customBar?.alpha = navAlpha
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        
        navigationController?.customBar?.alpha = 1
    }
    
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
        
        
    }
}


