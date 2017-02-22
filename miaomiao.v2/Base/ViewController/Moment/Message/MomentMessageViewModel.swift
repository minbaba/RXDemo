//
//  MomentMessageViewModel.swift
//  miaomiao.v2
//
//  Created by minbaba on 16/7/7.
//  Copyright © 2016年 MiaoquTech Inc. All rights reserved.
//

import UIKit

class MomentMessageViewModel: BaseViewModel {

    dynamic var messageList = [dynamicPushMessage]()
    
    
    func loadData() {
        NetworkServer.rx_mqResponseJSON(.DynamicPushList, parms: ["userId": UserServer.instance.user.userId, "pageNO": 1, "lastId": 0]).subscribeNext {[weak self] (result) in
            if let rows = result.0["rows"].arrayObject as? [[String : AnyObject]] {
                
                self?.messageList.appendContentsOf(rows.map({ (dict) -> dynamicPushMessage in
                    let model = dynamicPushMessage()
                    model.setValuesForKeysWithDictionary(dict)
                    return model
                }))
            }
            }.addDisposableTo(disposeBag)
    }
    
    func itemSelected(index: NSIndexPath) {
        
        WaitAlert.instance.show()
        let message = messageList[index.row]
        NetworkServer.rx_mqResponseJSON(.DynamicDetail, parms: ["userId": UserServer.instance.user.userId, "dynamicId": message.dynamicId])
            .subscribe({ (event) in
                dealNetWorkResult(event, stop: {(error) in
                    WaitAlert.instance.hide()
                    }, next: { (result) in
                        let moment = MomentModel()
                        moment.setValuesForKeysWithDictionary(result.0["entity"].dictionaryObject!)
                        let vc = MomentDetailViewController()
                        vc.viewModel.layout = MomentCellLayout(moment: moment)
                        self.rx_pushViewController.onNext(vc)
                })
            }).addDisposableTo(disposeBag)
        
    }
    
}
