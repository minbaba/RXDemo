//
//  User.swift
//  miaomiao.v2
//
//  Created by minbaba on 16/5/11.
//  Copyright © 2016年 MiaoquTech Inc. All rights reserved.
//

import UIKit


protocol UserProtocol: NSObjectProtocol {
    var userId: Int {get set}
}


class User: ModelProtocol, UserProtocol {
    
    dynamic var userId = 0
    
    /// 是否是市场官方推荐
    dynamic var authRecommend = false
    
    /// 妙ID
    dynamic var miaoId = ""
    
    /// 上次活跃时间
    dynamic var lastActiveTime = "2016-04-05 19:38:32"
    
    /// 血型
    dynamic var bloodType = 2
    
    /// 年龄
    dynamic var age = 27
    
    /// 更新时间
    dynamic var updateTime = "2016-04-05 19:38:32"
    
    /// 星座
    dynamic var horoscope = 9
    
    /// 创建时间
    dynamic var createTime = "2016-04-05 19:38:32"
    
    /// 居住地
    dynamic var residence = ""
    
    /// 签名
    dynamic var signature = ""
    
    /// vip类型
    dynamic var vipType = 0
    
    /// id
    dynamic var id = 0
    
    /// 体重
    dynamic var weight = 0
    
    /// 故乡
    dynamic var hometown = ""
    
    /// 职业
    dynamic var profession = ""
    
    /// 电话号
    dynamic var mobile = ""
    
    /// vip等级
    dynamic var vipLevel = 0
    
    /// 头像
    dynamic var headPortrait = ""
    
    /// VIP过期时间
    dynamic var vipExpireTime = "2017-10-22 10:11:01"
    
    /// 性别
    dynamic var gender = 0
    
    /// 照片
    dynamic var photos = ""
    
    /// 生日
    dynamic var birthday = "1989-01-10 00:00:00"
    
    /// 身高
    dynamic var stature = 0
    
    /// 感情状态
    dynamic var feelingStatus = 0
    
    /// 市场被推荐数
    dynamic var recommendedCount = 0
    
    /// 共同好友个数
    dynamic var commonFriendsCount = 0
    
    /// 关系
    dynamic var relation = 5
    
    /// 市场推荐的朋友数量
    dynamic var recommendCount = 0
    
    /// 市场被喜欢次数
    dynamic var marketLikedCount = 0
    
    dynamic var cid = 0
    
    /// 昵称
    dynamic var nickname = ""
    
    /// 遇见列表中用户照片数
    dynamic var userPhotosCount = 0
    
    dynamic var school = ""
    
    /// 资料完成度
    dynamic var detailScore = 0
    
    /// 备注
    var remarkNickname: String {
        return UserServer.instance.remark(for: userId) ?? nickname
//        return nickname
    }
    
    override func setValue(value: AnyObject?, forUndefinedKey key: String) {
        if key == "relationForMe" {
            self.setValue(value, forKeyPath: "relation")
        }
    }
    
    override static func ignoredProperties() -> [String] {
        return ["cid"]
    }
    
    override static func primaryKey() -> String? {
        return "userId"
    }
    
    
    func reJudgeAge() {
        
        let date = NSDate().components
        let birthday = self.birthday.toDate.components
        
        self.age = date.year - self.birthday.toDate.components.year
        if birthday.month > date.month || (birthday.month == date.month && birthday.day > date.day) {
             self.age -= 1
        }
    }
}

class Remark: ModelProtocol {
    
    dynamic var otherSideId = 0
    
    dynamic var userId = 0
    
    dynamic var remark = ""
    
    override static func primaryKey() -> String? {
        return "otherSideId"
    }
}

class dynamicInfo: NSObject {
    
    override func setValue(value: AnyObject?, forUndefinedKey key: String) {
        
    }
    
    var dynamicTotal = 0
    var simpleDynamics = [sampleDynamic]()
    
    override func setValue(value: AnyObject?, forKey key: String) {
        
        if key == "simpleDynamics" {
            
            for dict in value as! [[String: AnyObject]] {
                let dy = sampleDynamic()
                dy.setValuesForKeysWithDictionary(dict)
                simpleDynamics.append(dy)
            }
            
        } else {
            super.setValue(value, forKey: key)
        }
        
    }
    
    
    class sampleDynamic: NSObject {
        
        var dynamicId = 0
        var firstImage = ""
    }
}
