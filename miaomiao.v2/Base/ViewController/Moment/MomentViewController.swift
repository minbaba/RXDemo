//
//  MomentViewController.swift
//  miaomiao.v2
//
//  Created by minbaba on 16/4/8.
//  Copyright © 2016年 MiaoquTech Inc. All rights reserved.
//

import UIKit
import RxSwift

class MomentViewController: BaseActivityViewController, UITableViewDelegate, UITableViewDataSource {
    
    var viewModel:MomentViewModel!
    
    final override func viewDidLoad() {
        
        self.automaticallyAdjustsScrollViewInsets = false
        
        self.view.addSubview(listTb)
        listTb.snp_makeConstraints { (make) in
            make.left.right.equalTo(0)
            make.top.equalTo(64)
            make.bottom.equalTo(-49)
        }
        
        listTb.registerClass(MomentCell.self, forCellReuseIdentifier: "moment")
        
        listTb.rx_refresh.bindNext(viewModel.refresh).addDisposableTo(disposeBag)
        listTb.rx_loadMore.bindNext(viewModel.loadMore).addDisposableTo(disposeBag)
        
        viewModel.rx_requestComplete.map { _ in return }.doOnNext({ [weak self] in
            self?.listTb.setHasMore(self?.viewModel.hasMore ?? false)
        }).bindNext(listTb.endRefresh).addDisposableTo(disposeBag)
        
        listTb.delegate = self
        listTb.dataSource = self
        
        listTb.rx_itemSelected.bindNext(viewModel.itemSelected).addDisposableTo(disposeBag)
    
        super.viewDidLoad()
    }
}

extension MomentViewController {
    

}

extension MomentViewController {
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.layouts.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("moment") as! MomentCell
        
        // 判断是否是重用的 cell
        if cell.layout == nil {
            cell.avatorClicked.subscribeNext({[weak self] (userId) in
                
                self?.viewModel.showUserInfo(userId)
            }).addDisposableTo(disposeBag)
            
            cell.likeButton.rx_tap.map { [weak self,weak cell] in
                self?.listTb.indexPathForCell(cell!)
            }.subscribeNext({[weak self] (index) in
                if let index = index {
                self?.viewModel.praiseButtonClicked(index)
                                        
                }
            }).addDisposableTo(disposeBag)
            
            cell.rx_PicTap.subscribeNext({[weak cell] (index) in
                                
                let models = cell!.layout.moment.images.componentsSeparatedByString(",").map { PhotoModel(imageUrlString: $0.mq_imgOriginUrl, sourceImageView: nil, description: nil) }
                let browser = PhotoBrowser(photoModels: models)
                browser.showWithBeginPage(index)
                
            }).addDisposableTo(disposeBag)

            cell.oprationButton.rx_tap.subscribeNext {[weak self, weak cell] (_) in
                if let layout = cell?.layout { self?.viewModel.momentOpration(layout) }
                }.addDisposableTo(disposeBag)
        }
        
        cell.layout = viewModel.layouts[indexPath.row]
        cell.selectionStyle = .None
        return cell
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return CGFloat(viewModel.layouts[indexPath.row].height)
    }
    func tableView(tableView: UITableView, editingStyleForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCellEditingStyle {
        return .None
    }
    
}
