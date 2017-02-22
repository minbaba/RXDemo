//
//  RefreshTableView.swift
//  miaomiao.v2
//
//  Created by minbaba on 16/7/7.
//  Copyright © 2016年 MiaoquTech Inc. All rights reserved.
//

import UIKit
import RxSwift

class RefreshTableView: BaseTableView {

    let rx_refresh = PublishSubject<Void>()
    let rx_loadMore = PublishSubject<Void>()
    
    var refreshHeader: MJRefreshHeader?
    var refreshFooter: MJRefreshFooter?
    
    private var _hasMore = false
    
    
    var couldRefresh = true {
        didSet {
            mj_header = couldRefresh ? refreshHeader: nil
        }
    }
    var couldLoadMore = true {
        didSet {
            
            guard _hasMore else { return }
            mj_footer = couldLoadMore ? refreshFooter: nil
        }
    }
    
    
    override func setUp() {
        super.setUp()
        
        refreshHeader = MJRefreshNormalHeader(refreshingBlock: { [weak self] in
            self?.rx_refresh.onNext()
            })
        mj_header = refreshHeader
        
        refreshFooter = MJRefreshAutoNormalFooter(refreshingBlock: { [weak self] in
            self?.rx_loadMore.onNext()
        })
//        mj_footer = refreshFooter
//        refreshFooter?.automaticallyHidden = true
    }
    
    func setHasMore(hasMore: Bool) {
        
        _hasMore = hasMore
        guard couldLoadMore else { return }
        
        safeSynMainQueen { (_) in
            
            self.mj_footer = hasMore ? self.refreshFooter: nil
//            self.mj_footer.endRefreshingWithNoMoreData()
//            if self.mj_footer == nil && hasMore {
//                self.mj_footer = self.refreshFooter
//            }
//            if self.mj_footer != nil && !hasMore {
//                self.mj_footer = nil
//            }
        }
    }
    
    func endRefresh() {
        
        safeSynMainQueen { (_) in
            self.reloadData()
            self.refreshHeader?.endRefreshing()
            self.refreshFooter?.endRefreshing()
        }
        
    }

    func beginRefresh() {
        if let header = self.mj_header {
            header.beginRefreshing()
        }
    }
}
