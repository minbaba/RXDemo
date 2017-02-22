//
//  MomentMessageViewController.swift
//  miaomiao.v2
//
//  Created by minbaba on 16/5/24.
//  Copyright © 2016年 MiaoquTech Inc. All rights reserved.
//

import UIKit
import RxSwift

class MomentMessageViewController: ViewController {

    
    let viewModel = MomentMessageViewModel()
    
    
    @IBOutlet weak var contentTb: UITableView!
    
    override func setUpUI() {
        contentTb.registerNib(UINib(nibName: "MomentMessageCell", bundle: nil), forCellReuseIdentifier: "item")
        contentTb.rowHeight = 85

    }
    
    override func bindViewModel() {
        
        viewModel.rx_observeWeakly([dynamicPushMessage].self, "messageList").map { $0 ?? [] }
        .bindTo(contentTb.rx_itemsWithCellIdentifier("item", cellType: MomentMessageCell.self)) {(row, element, cell) in
            
            cell.avator.kf_setImageWithURL(element.headPortrait.mqimageUrl(.Small), forState: .Normal)
            cell.nameLabel.text = element.nickname
            cell.Message.text = element.content
            cell.timeLabel.text = element.createTime
            cell.fistImage.kf_setImageWithURL(element.firstImage.mqimageUrl(.Small))
        }.addDisposableTo(disposeBag)
        
        contentTb.rx_itemSelected.bindNext(viewModel.itemSelected).addDisposableTo(disposeBag)
        contentTb.rx_itemSelected.subscribeNext {[weak self] (index) in
            self?.contentTb.deselectRowAtIndexPath(index, animated: true)
        }.addDisposableTo(disposeBag)
    }
    
    override func getData() {
        viewModel.loadData()
    }
    

}


class dynamicPushMessage: NSObject {
    
    var content = ""
    
    var createTime = ""
    
    var firstImage = ""
    
    var headPortrait = ""
    
    var nickname = ""
    
    var userId = 0
    
    var cid = 0
    
    var dynamicId = 0
    
    override func setValue(value: AnyObject?, forUndefinedKey key: String) {
    }
    
}
