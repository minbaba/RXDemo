//
//  UserServer.swift
//  miaomiao.v2
//
//  Created by minbaba on 16/5/24.
//  Copyright © 2016年 MiaoquTech Inc. All rights reserved.
//

import UIKit
import RxSwift
import RealmSwift

class UserServer: NSObject {
    
    var sampInfoRequestList = [Int]()
    let queue = dispatch_queue_create("用户资料更新", nil)
    
    var interestCountNote = InterestCountNote()
    
    static var instance = UserServer()
    dynamic var user = User() { didSet {
        rx_infoUpdate.onNext(user)
        } }
    dynamic var friends = [User]() { didSet {
        rx_friendUpdate.onNext(friends)
        }
    }
    let rx_friendUpdate = ReplaySubject<[User]>.create(bufferSize: 1)
    
    
    let disposeBag = DisposeBag()
    
    /// 本地用户资料更新
    let rx_infoUpdate = PublishSubject<User>()
    
    /// 数据库
    let realm = try! Realm()
    
    var remarkList: Results<Remark>!
    
    
    static var currentId:Int! {
        return UserServer.instance.user.userId
    }

    
    private override init() {
        super.init()
    }
    
    /**
     初始化
     */
    func setUp() {
        NSNotificationCenter.defaultCenter().rx_notification(AppInfoService.userLoginSucc).subscribeNext {[weak self] (noti) in
            self?.update()
            self?.addContacts()
            }.addDisposableTo(disposeBag)
        NSNotificationCenter.defaultCenter().rx_notification(AppInfoService.userLogoutSucc).subscribeNext {[weak self] (noti) in
            self?.friends = []
            }.addDisposableTo(disposeBag)
        
        NetworkServer.instance.rx_netStatus.subscribeNext { (status) in
            if status != .Unknown && status != .NotReachable {
                if AppInfoService.instance.isLogin { self.reloadFriendList() }
            }
        }.addDisposableTo(disposeBag)
        
        remarkList = realm.objects(Remark)
    }
    
    /**
     更新本地个人资料
     */
    func update() {
        
        let userId = AppInfoService.instance.currentUserId
        var user = realm.objectForPrimaryKey(User.self, key: userId)?.copy() as? User
        if user == nil {
            user = User()
            user?.userId = userId
        }
        
        user?.userId = userId
        self.user = user!
        
        NetworkServer.rx_mqResponseJSON(.UserDetail, parms: ["userId": userId]).subscribeNext { (result) in
            
            if let dict = result.0["entity"].dictionaryObject {
                self.userInfo(dict, callBack: { (user) in
                    self.user = user
                })
            }
            
            }.addDisposableTo(disposeBag)
    }
    
    /**
     更新朋友列表
     */
    func reloadFriendList() {
        NetworkServer.rx_mqResponseJSON(.FriendList, parms: ["userId": UserServer.instance.user.userId]).subscribeNext {[weak self] (element) in
            
            if let rows = element.0["rows"].arrayObject as? [[String: AnyObject]] {
                self?.userList(rows, callBack: { (users) in
                    self?.friends = users
                })
            }
            }.addDisposableTo(disposeBag)
    }
    
    /**
     异步 通过用户id获取某用户摘要信息
     
     - parameter userId:   用户的id
     - parameter asynBack: 获取后的回调
     */
    func sampleInfo(userId: Int, asynBack:((User) -> Void)){
        guard userId > 0 else { return }
        userInfo(userId, asynBack: asynBack, url: .SampleInfo, parms: ["userId": userId])
    }
    
    /**
     异步 通过用户id获取某用户详细信息
     
     - parameter userId:   用户的id
     - parameter asynBack: 获取后的回调
     */
    func fullnfo(userId: Int, asynBack:((User) -> Void)){
        
        if userId == user.userId {
            asynBack(user.copy() as! User)
            return
        }
        
        var parms = ["userId": self.user.userId]
        if !(userId == self.user.userId) { parms["targetUserId"] = userId}
        userInfo(userId, asynBack: {[weak self] (user) in
        
            if userId == self?.user.userId {
                self?.user = user
            }
            asynBack(user)
            }, url: .OtherDetail, parms: parms)
    }
    
    
    private func userInfo(userId: Int, asynBack:((User) -> Void), url: UrlString = .SampleInfo, parms:[String: AnyObject] = [:]) {
        let user = realm.objectForPrimaryKey(User.self, key: userId)
        
        if user != nil {
            asynBack(user!.copy() as! User)
        }
        
        // 限制简单资料请求次数
        if url == .SampleInfo {
            if sampInfoRequestList.contains(userId) { return }
            sampInfoRequestList.append(userId)
        }
        
        NetworkServer.rx_mqResponseJSON(url, parms: parms).subscribeNext({[weak self] (result) in
            
            if let dict = result.0["entity"].dictionaryObject {
                if url != .SampleInfo || user == nil {
                    self!.userInfo(dict, callBack: { (user) in
                        asynBack(user)
                    })
                }
            }
            }).addDisposableTo(disposeBag)
    }
    
    /**
     通过属性数组返回一组用户实例
     
     - parameter listObject: 属性数组
     - parameter addtion:    添加属性
     - parameter map:        需要映射的 key 的映射列表
     - parameter callBack:   异步回调
     */
    func userList(listObject:[[String: AnyObject]], addtion: [String: AnyObject] = [:], map: [String: String]? = nil, callBack: ([User] -> Void)?) {
        
        
        dispatch_async(queue) {
            var arr = [User]()
            let realm = try! Realm()
            
            // 复制函数
            let setValue = { (dict: [String: AnyObject], user: User) in
                for (originKey, value) in dict {
                    var key = originKey
                    if let k = map?[originKey] { key = k }
//                    if key == User.primaryKey() { continue }
                    user.setValue(value, forKey: key)
                }
                user.setValuesForKeysWithDictionary(addtion)
            }
            
            // 获取 List
            for dict in listObject {
                var user = realm.objectForPrimaryKey(User.self, key: dict[User.primaryKey()!]!)?.copy() as? User
                if user == nil {
                    user = User()
                    setValue(dict, user!)
                    setValue(addtion, user!)
                    
                } else {
                    setValue(dict, user!)
                }
                
                
                arr.append(user!)
            }
            
            try! realm.write({
                realm.add(arr, update: true)
            })
            
            let ret = arr.map { $0.copy() as! User }
            dispatch_async(dispatch_get_main_queue(), { 
                callBack?(ret)
            })
        }
    }
    
    func userInfo(values: [String: AnyObject], callBack: (User -> Void)?) {
        
        
        dispatch_async(queue) {
            let realm = try! Realm()
            var user = realm.objectForPrimaryKey(User.self, key: values[User.primaryKey()!]!)?.copy() as? User
            if user == nil {
                user = User()
                user?.setValuesForKeysWithDictionary(values)
                
            } else {
                for (key, value) in values {
                    if key == User.primaryKey() {
                        continue
                    }
                    user?.setValue(value, forKey: key)
                }
            }
            
            try! realm.write({
                realm.add(user!, update: true)
            })
            let u = user!.copy() as! User
            dispatch_async(dispatch_get_main_queue(), { 
                callBack?(u)
            })
        }
    }
    
    /**
     匹配通讯录 自动加好友
     */
    func addContacts() {
        
        SystemContactsService.instance.getContacts {[weak self] (_) in
            
            let realm = try! Realm()
            let str = "[" + (realm.objects(ContactsModel).map({ "{\"" + $0.phone + "\":\"" + $0.name + "\"}" }) as NSArray) .componentsJoinedByString(",") + "]"
            print(str)
           
//            NetworkServer.rx_upload(UrlString.AddPhoneContacts, data: str.dataUsingEncoding(NSUTF8StringEncoding)!, contentType: "application/json", parms: ["userId": self!.user.userId]).subscribeNext({ (_) in
//                }).addDisposableTo(self!.disposeBag)
        }
    }
    
    
    /**
     获取指定id用户的备注
     
     - parameter userId: id
     
     - returns: 备注
     */
    func remark(for userId: Int) -> String? {
        
        var ret: String?
        safeSynMainQueen { (_) in
            
            if let remark = self.realm.objectForPrimaryKey(Remark.self, key: userId) {
                ret = "\((remark.copy() as? Remark)!.remark)"
            }
        }
        return ret
    }
    /**
     删除指定用户的备注
     
     - parameter userId: id
     
     - returns: 备注
     */
    func deleteRemark(with userId: Int) {
        safeSynMainQueen { (_) in
            let remark = self.remarkList.filter { $0.otherSideId == userId }.first
            if let remark = remark {
                try! self.realm.write({
                    self.realm.delete(remark)
                })
            }
        }
    }
    /**
     加载备注列表
     */
    func loadRemarks(userId: Int) {
        NetworkServer.rx_mqResponseJSON(.RemarkList, parms: ["userId": userId]).subscribeNext {[weak self] (result) in
            
            if let rows = result.0["rows"].arrayObject {
                let arr = rows.map { Remark(value: $0) }
                try! self?.realm.write({
                    self?.realm.add(arr, update: true)
                })
                self?.remarkList = self!.realm.objects(Remark)
            }
            
        }.addDisposableTo(disposeBag)
    }
    
    /**
     刷新关心我的人数据
     */
    func loadInterestedMeData() {
        NetworkServer.rx_mqResponseJSON(.InterestNote, parms: ["userId": UserServer.instance.user.userId])
            .retry(2)
            .subscribeNext {[weak self] (result) in
                
                let note = InterestCountNote()
                note.setValuesForKeysWithDictionary(result.0["entity"].dictionaryObject ?? [:])
                self?.interestCountNote = note
                
                let count = note.newAttentionedCount + note.newViewedCount
                RemoteMessageServer.instance.addMessage(["type": "3002"])
                RemoteMessageServer.instance.setCount(count, for: .NewFlower)
                
            }.addDisposableTo(disposeBag)
    }
}
