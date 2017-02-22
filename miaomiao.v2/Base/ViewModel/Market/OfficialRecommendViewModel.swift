//
//  OfficialRecommendViewModel.swift
//  miaomiao.v2
//
//  Created by minbaba on 16/7/28.
//  Copyright © 2016年 MiaoquTech Inc. All rights reserved.
//

import RealmSwift

class OfficialRecommendViewModel: BaseViewModel {
    
    dynamic var recommendList = [User]()
    var currentPage = 1
    var gender = 2
    dynamic var hasMore = false
    
    override init() {
        super.init()
        
        let realm = try! Realm()
        recommendList = realm.objects(User.self).filter { $0.authRecommend }.map { $0 }
    }
    
    func refresh() {
        currentPage = 1
        getData(currentPage, gender: getGender())
    }
    
    func loadMore() {
        currentPage += 1
        getData(currentPage, gender: getGender())
    }
    
    func getData(pageNo: Int, gender: Int) {
        NetworkServer.rx_mqResponseJSON(.AuthorityRecommend, parms: ["pageNo": pageNo, "gender": gender]).subscribeNext {[weak self] (result) in
            
            if let b = result.0["hasMore"].bool {
                self?.hasMore = b
            }
            if let rows = result.0["rows"].arrayObject as? [[String: AnyObject]] {
                UserServer.instance.userList(rows, addtion: ["authRecommend": true], callBack: { (users) in
                    if pageNo == 1 { self?.recommendList.removeAll() }
                    self?.recommendList.appendContentsOf(users)
                })
            }
            }.addDisposableTo(disposeBag)
    }
    
    func getGender() -> Int{
        return NSUserDefaults.standardUserDefaults().valueForKey("genderKey") as? Int ?? 2
    }
    
}
