//
//  RemoteMessageServer.swift
//  miaomiao.v2
//
//  Created by minbaba on 16/7/11.
//  Copyright © 2016年 MiaoquTech Inc. All rights reserved.
//

import UIKit
import RxSwift

class RemoteMessageServer {
    
    
    static let instance = RemoteMessageServer()
    static let fileName = "notifyBadgeCount.plist"
    
    let saveQueue = dispatch_queue_create("通知存储", nil)
    
    var messageCount: Int {
        
        var count = 0
        for (_, dict) in messageCountList {
            count += dict["count"] as? Int ?? 0
        }
        
        return count
    }
    
    
    /// 消息数量列表
    private var messageCountList = [Int: [String: AnyObject]]() {
        didSet {

            dispatch_async(saveQueue) { 
                NSKeyedArchiver.archiveRootObject(self.messageCountList, toFile: self.home + "/" + RemoteMessageServer.fileName)
            }
        }
    }
    
    let home = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true).first!
    
    
    private init() {
        
        messageCountList = NSKeyedUnarchiver.unarchiveObjectWithFile(self.home + "/" + RemoteMessageServer.fileName) as? [Int: [String: AnyObject]] ?? [:]
        print(self.messageCountList)

    }
    
    /// 观察者 list
    private var observerList = [BadgeType: ReplaySubject<Int>]()
    
    /**
     添加一条消息
     */
    func addMessage(dict: [String: AnyObject]) {
        
        
        guard let ty = dict["type"] as? Int else {
            return
        }
        guard let type = MessageType(rawValue: String(ty)) else {
            return
        }
        var mDict = dict
        mDict["time"] = NSDate().timeIntervalSince1970 * 1000
        
        switch type {
            
        case .FriendMoment:
            updateCount(for: .FriendMoment, ext: dict)
        case .MomentLike: fallthrough
        case .MomentComment: fallthrough
        case .MomentCommentReplay:
            updateCount(for: .MomentMessage, ext: dict)
        case .NewFriend:
            
            updateCount(for: .NewFriend, ext: dict)
        case .Chat:
            
            updateCount(for: .Chat, ext: dict)
            
        case .NewFollower:
            
            updateCount(for: .NewFlower, ext: dict)
            
        case .MarketAdd:
            updateCount(for: .MarketAdd, ext: dict)
            fallthrough
        case .MarketLike: fallthrough
        case .FriendSaleMe: fallthrough
        case .FriendAddGoods: fallthrough
        case .SomeOneLoving_Owner: fallthrough
        case .SomeOneLoving_Friend:
            
            self.updateCount(for: .Market, ext: dict)
        case .WithDrawSucc: fallthrough
        case .WithFailed: fallthrough
        case .ActivityInfo: fallthrough
        case .CompleteInfo: fallthrough
        case .ShareInfo: fallthrough
        case .LoginInfo: fallthrough
        case .AvatorMessage:
            self.updateCount(for: .System, ext: dict)
            
        default:
            break
        }

//        if let msgType = dict["msgType"] as? Int {
//
//            if msgType == 2 {
//                if ty == 2010 {  }
//            } else if msgType == 1 {
//            }
//            
//        } else {
//                    }
        
        
        AudioServicesPlayAlertSound(1007)
//        AudioServicesDisposeSystemSoundID(1007)
    }
    
    func clear(for badgeType: BadgeType) {
        
        setCount(0, for: badgeType)
    }
    
    func setCount(count: Int, for type: BadgeType) {
        if let _ = messageCountList[type.rawValue] {
            messageCountList[type.rawValue]?["count"] = count
            if let o = observerList[type] {
                o.onNext(count)
            }
        }
    }
    
    func updateCount(for badgeType: BadgeType, ext: [String: AnyObject]) {
        let count = self.count(for: badgeType) + 1
        var ext = ext
        ext["count"] = count
        
        messageCountList[badgeType.rawValue] = ext
        if let o = observerList[badgeType] {
            o.onNext(count)
        }
    }
    
    func count(for badgeType: BadgeType) -> Int {
        if messageCountList[badgeType.rawValue] == nil {
            messageCountList[badgeType.rawValue] = ["count": 0]
        }
        return messageCountList[badgeType.rawValue]!["count"] as! Int
    }
    func ext(for badgeType: BadgeType) -> [String: AnyObject] {
        if messageCountList[badgeType.rawValue] == nil {
            messageCountList[badgeType.rawValue] = ["count": 0]
        }
        return messageCountList[badgeType.rawValue]!
    }
    
    func observer(for type: BadgeType) -> Observable<Int> {
        
        if observerList[type] == nil {
            observerList[type] = ReplaySubject<Int>.create(bufferSize: 1)
            observerList[type]?.onNext(count(for: type))
        }
        
        return observerList[type]!
    }
    
    func observer(for types: [BadgeType]) -> Observable<Int>? {
        
        guard types.count > 0 else {
            return nil
        }
        guard types.count > 1 else {
            return observer(for: types.first!)
        }
        
        let com = { (ob1: Observable<Int>, ob2: Observable<Int>) in
            return Observable.combineLatest(ob1, ob2, resultSelector: { return $0 + $1 })
        }
        
        var ob = com(observer(for: types.first!), observer(for: types[1]))
        for index in 2..<types.count {
            ob = com(ob, observer(for: types[index]))
        }
        return ob
    }
    
    enum BadgeType: Int {
        case MomentMessage
        case FriendMoment
        case NewFriend
        case NewFlower
        case Market
        case Chat
        case System
        case MarketAdd

    }
    
    enum MessageType: String {
        case MarketLike           = "2001"
        case FriendSaleMe         = "2002"
        case FriendAddGoods       = "2003"
        case SomeOneLoving_Owner  = "2004"
        case SomeOneLoving_Friend = "2005"
        case NewFriend            = "3001"
        case NewFollower          = "3002"
        case DeletedByFriend      = "3003"
        case ReceiveChat          = "9527"
        case ReceiveChatTip       = "4001"
        case TipOutTime           = "4002"
        case ReceiveIntroNorTip   = "4003"
        case ReceiveCogNorTip     = "4004"
        case ReceiveIntroRichTip  = "4005"
        case ReceiveCogRichTip    = "4006"
        case LossVip              = "6001"
        case MomentLike           = "5001"
        case MomentComment        = "5002"
        case MomentCommentReplay  = "5003"
        case FriendMoment         = "5004"
        case Chat                 = "1000001"
        case NewViewCount         = "2000001"

        case WithDrawSucc         = "4010"
        case WithFailed           = "4008"
        case ActivityInfo         = "6002"
        case CompleteInfo         = "6003"
        case ShareInfo            = "6004"
        case LoginInfo            = "6005"
        case AvatorMessage        = "1000"
        case MarketAdd            = "2010"

        
//        [4010: "提现成功", 4008: "提现失败", 6002: "抽奖提醒", 6003: "完善资料", 6004: "系统提醒", 6005: "系统提醒", 1000: "系统提醒", 1001: "头像审核不通过"][self.type]
    }
}
