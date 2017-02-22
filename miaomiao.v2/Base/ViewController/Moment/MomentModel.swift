//
//  File.swift
//  miaomiao.v2
//
//  Created by minbaba on 16/4/11.
//  Copyright © 2016年 MiaoquTech Inc. All rights reserved.
//

import Foundation
import RealmSwift


// MARK: - 动态模型
class MomentModel: ModelProtocol {
    
    dynamic var userId = 0
    
    dynamic var content = "尼日欧诺23个"
    dynamic var dynamicId = 5
    dynamic var headPortrait = "xiaobaihead.jpg"
    dynamic var age = 29
    dynamic var lat = 0
    dynamic var position = ""
    var praiseList = List<MomentPraiser>()
    var commentList = List<MomentComment>()
    dynamic var viewCount = 0
    dynamic var vipType = 0
    dynamic var gender = 0
    dynamic var relationType = 5
    dynamic var visibleRange = 0
    dynamic var createTime = "2016-04-21 15:50:04"
    dynamic var lon = 0
    dynamic var feelingStatus = 1
    dynamic var praiseCount = 0
    dynamic var images = "xxx.jpg"
    dynamic var commentCount = 0
    dynamic var praised = false
    
    dynamic var nickname = ""
    
    var remarkNickname: String {
        return UserServer.instance.remark(for: userId) ?? nickname
    }
    
    
    override func copyWithZone(zone: NSZone) -> AnyObject {
        
        let model = MomentModel()
        var dict = self.attributeDict
        dict["praiseList"] = self.praiseList.map { $0.attributeDict }
        dict["commentList"] = self.commentList.map { $0.attributeDict }
        
        model.setValuesForKeysWithDictionary(dict)
        return model
    }
    

    override static func primaryKey() -> String? {
        return "dynamicId"
    }
    
    
    
    override func setValue(value: AnyObject?, forKey key: String) {
        
        switch key {
        case "praiseList":
            
            for dict in value as! Array<[String: AnyObject]> {
                
                let praiser = MomentPraiser()
                praiser.setValuesForKeysWithDictionary(dict)
                self.praiseList.append(praiser)
            }
            
            break
        case "commentList":
            
            for dict in value as! Array<[String: AnyObject]> {
                
                let comment = MomentComment()
                comment.setValuesForKeysWithDictionary(dict)
                self.commentList.append(comment)
            }
            
            break
        default:
            super.setValue(value, forKey: key)
        }
    }
}


// MARK: - 点赞头像模型
class MomentPraiser: ModelProtocol {
    
    dynamic var userId = 0

    /// 点赞ID
    var praiseId = 61
    /// 会员类型
    var vipType = 1
    /// 性别
    var gender = 0
    /// 上次活动时间
    var lastActiveTime = "1980-11-22 02:52:16"
    /// 恋爱状态
    var feelingStatus = 0
    /// 年龄
    var age = 56
    /// 头像
    var headPortrait = "http://fe.topitme.com/e/77/3d/11036272196073d77eo.jpg"
    
    dynamic var nickname = ""
    
    var remarkNickname: String {
        return UserServer.instance.remark(for: userId) ?? nickname
    }
    
    override static func primaryKey() -> String? {
        return "userId"
    }
}

// MARK: - 评论模型
class MomentComment: ModelProtocol {
    
    dynamic var userId = 0

    
    dynamic var headPortrait = ""
    
    dynamic var content = ""
    
    dynamic var replaiedUserNickname = ""
    
    var dynamicId = 0
    
    
    var commentId = 0
    
    
    var createTime = ""
    
    var replaiedId = 0
    
    dynamic var nickname = ""
    
    var remarkNickname: String {
        return UserServer.instance.remark(for: userId) ?? nickname
    }
    
    override static func primaryKey() -> String? {
        return "commentId"
    }
}


extension Int {

    var momentRelation: String? {
        
        if self >= 0 && self <= 7 {
            return ["陌生", "推荐", "关注", "已买", "好友", "自己", "官方", "拉黑"][self]
        }
        
        return nil
    }
    
    
}


