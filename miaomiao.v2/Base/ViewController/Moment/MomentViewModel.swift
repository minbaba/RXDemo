//
//  MomentViewModel.swift
//  miaomiao.v2
//
//  Created by minbaba on 16/4/11.
//  Copyright © 2016年 MiaoquTech Inc. All rights reserved.
//

import UIKit
import RxSwift
import RealmSwift

class MomentViewModel: BaseViewModel {
    
    var urlStr: UrlString!
    
    
    dynamic var hasMore = false
    var currentPage = 1
    dynamic var layouts = [MomentCellLayout]() {
        didSet {
            self.rx_requestComplete.onNext(.MOMENT)
        }
    }
    let updateQueue = dispatch_queue_create("update_queue", DISPATCH_QUEUE_SERIAL)
    
    func itemSelected(indexPath: NSIndexPath) {
        
        let vc = MomentDetailViewController()
        let layout = self.layouts[indexPath.row]
        vc.viewModel.layout = layout
        vc.viewModel.complete = {[weak self] (moment) in
            if let moment = moment {
                self?.layouts.removeAtIndex(indexPath.row)
                self?.layouts.insert(MomentCellLayout(moment: moment), atIndex: indexPath.row)
            } else { self?.layouts.removeAtIndex(indexPath.row) }
        }
        
        self.rx_pushViewController.onNext(vc)
    }
    
    func addMoment() {
        
        let vc = MomentCreateViewController {[weak self] (moment) in
            self?.layouts.insert(MomentCellLayout(moment: moment), atIndex: 0)
        }
        self.rx_pushViewController.onNext(vc)
    }
    
    func refresh() {
        currentPage = 1
        let lastId = 0
        loadMoment(urlStr, parms: ["userId": UserServer.instance.user.userId, "pageNo": self.currentPage, "lastId": lastId, "gender": 2])
    }
    
    func loadMore() {
        currentPage += 1
        
        let lastId = self.layouts.last?.moment.dynamicId ?? 0
        loadMoment(urlStr, parms: ["userId": UserServer.instance.user.userId, "pageNo": self.currentPage, "lastId": lastId, "gender": 2])
    }
    
    func loadMoment(url: UrlString, parms: [String: AnyObject]) {
        let netRequest = NetworkServer.rx_mqResponseJSON(url, parms: parms)
        netRequest.subscribeNext {[weak self] (result) in
            if let b = result.0["hasMore"].bool {
                self?.hasMore = b
            }
            
            if let rows = result.0.dictionary?["rows"] {
                
                dispatch_async(self!.updateQueue, {
                    
                    
                    let arr = rows.array!.map({ (json) -> MomentModel in
                        let model = MomentModel()
                        model.setValuesForKeysWithDictionary(json.dictionaryObject!)
                        return model
                    })
                    
                    let realm = try! Realm()
                    try! realm.write {
                        realm.add(arr, update: true)
                    }
                 
                    
                    dispatch_async(self!.updateQueue, {
                        
                        let arr = arr.map{ MomentCellLayout(moment: $0.copy() as! MomentModel) }
                        if self?.currentPage == 1 { self?.layouts.removeAll() }
                        self?.layouts.appendContentsOf(arr)
                    })
                    
                })
            }
            }.addDisposableTo(disposeBag)
        
    }
    
    func praiseButtonClicked(indexPath: NSIndexPath) {
        
        if let moment = layouts[indexPath.row].moment {
            
            let parms: [String: AnyObject] = ["dynamicId": moment.dynamicId, "userId": UserServer.instance.user.userId, "dynamicUserId": moment.userId]
            var url = UrlString.AddMomentPraiser
            
            if moment.praised {
                url = .DeleteMomentPraise
            }
        
            addPraise(url, parms: parms, complete: {[weak self, weak moment] (_) in
                if url == .AddMomentPraiser {
                    moment?.praised = true
                    moment?.praiseCount += 1
                } else {
                    moment?.praised = false
                    moment?.praiseCount -= 1
                }
                self?.layouts.removeAtIndex(indexPath.row)
                self?.layouts.insert(MomentCellLayout(moment: moment!), atIndex: indexPath.row)
            })
        }
    }
    
    
    func addPraise(url: UrlString, parms: [String: AnyObject], complete: completeHander? = nil) {
        NetworkServer.rx_mqResponseJSON(url, parms: parms).subscribeNext { (element) in
            complete?()
            }.addDisposableTo(disposeBag)
    }
    
    func deletePraise(parms: [String: AnyObject], complete: completeHander? = nil) {
        NetworkServer.rx_mqResponseJSON(.DeleteMomentPraise, parms: parms).subscribeNext { (element) in
            complete?()
        }.addDisposableTo(disposeBag)
    }
    
    func momentOpration(layout: MomentCellLayout) {
        
        let alert = MomentOprationAlert(moment: layout.moment)
        alert.complete = {[weak alert, weak self] _ in
            alert?.hide(true, completed: nil)
            if let index = self?.layouts.indexOf(layout) {
                self?.layouts.removeAtIndex(index)
            }
        }
        alert.show(true, completed: nil)
    }
   


}
