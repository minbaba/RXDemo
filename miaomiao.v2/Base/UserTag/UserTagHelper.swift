//
//  UserTagHelper.swift
//  miaomiao.v2
//
//  Created by minbaba on 16/4/12.
//  Copyright © 2016年 MiaoquTech Inc. All rights reserved.
//

import UIKit


func safeSynMainQueen(hander: completeHander) {
    if NSThread.isMainThread() {
        hander()
    } else {
        dispatch_sync(dispatch_get_main_queue()) {
            hander()
        }
    }
}

class UserTagHelper {
    
    var maxX = 0.0
    
    
    
    static let instance = UserTagHelper()
    
    var spaceAtt = NSAttributedString(attachment: NSTextAttachment())
    var attachments = [String: NSAttributedString]()
    let button = UIButton(frame: CGRectMake(0, 0, 35, 12))

    private init() {
        
        safeSynMainQueen {
            
            self.button.titleLabel?.font = UIFont.systemFontOfSize(12)
            self.button.setTitleColor(UIColor.whiteColor(), forState: .Normal)
            self.button.mq_setCornerRadius(1)
        }
    }
    
    
    func parse(moment moment:MomentModel, type: TagClass...) -> NSAttributedString {
        
        let user = User()
        user.setValuesForKeysWithDictionary(moment.attributeDict)
        
        return self.parse(user, types: type.count > 0 ? type: [.Gender, .Feeling, .Vip])
    }
    
    func parse(user user:User, type: TagClass...) -> NSAttributedString {
        
        return self.parse(user, types: type.count > 0 ? type: [.Gender, .Feeling, .Vip])
    }
    
    private func parse(user:User, types: [TagClass]) -> NSAttributedString {
        
        var tagModelArr = Array<UserTagModel>()
        for type in types {
            
            if type == .Vip {
                if user.vipType > 0 {
                    tagModelArr.append(UserTagModel(type: .Vip))
                }
            } else if type == .Gender {
                let type = UserTagModel.ModelType(rawValue: user.gender + 3)
                tagModelArr.append(UserTagModel(type: type!, text: String(user.age)))
            } else if type == .Feeling {
                tagModelArr.append(UserTagHelper.feelingTag(user.feelingStatus))
            }
            
        }
        return self.uerTagAtts(tagModelArr)
        
    }

    
    static func feelingTag(status: Int) -> UserTagModel {
        
        return UserTagModel(type: UserTagModel.ModelType(rawValue: max(status - 1, 0)) ?? .Alone, text: status.feelingStatus)
    }
    
    
    func uerTagAtts(tags: [UserTagModel]) -> NSAttributedString {
        
        let ret = NSMutableAttributedString()
        
        for index in 0..<tags.count {
            let ty = tags[index]
            
            var key = "\(ty.type)"
            if ty.type == .Male || ty.type == .FeMale {
                key += ty.text
            }
            
            var attr: NSAttributedString!
            if let attach = attachments[key] {
                attr = attach
            } else {
                let attachment = NSTextAttachment()
                self.button.frame = ty.rect
                self.button.backgroundColor = ty.color?.toColor()
                safeSynMainQueen {
                    
                    self.button.setTitle(ty.text, forState: .Normal)
                    if let img = ty.image {
                        self.button.setImage(UIImage(named: img), forState: .Normal)
                    } else {
                        self.button.setImage(nil, forState: .Normal)
                    }
                    self.button.setNeedsDisplay()
                    UIGraphicsBeginImageContextWithOptions(ty.rect.size, false, UIScreen.mainScreen().scale)
                    self.button.layer.renderInContext(UIGraphicsGetCurrentContext()!)
                    let image = UIGraphicsGetImageFromCurrentImageContext()
                    UIGraphicsEndImageContext()
                    
                    attachment.image = image
                }
                
                attachment.bounds = CGRectMake(0, -2.5, ty.rect.size.width, ty.rect.size.height)
                attr = NSAttributedString(attachment: attachment)
                attachments[key] = attr
            }
            ret.appendAttributedString(attr)
            if index < tags.count - 1 {
                ret.appendAttributedString(spaceAtt)
            }
        }
        
        ret.addAttributes([NSKernAttributeName: 3], range: NSMakeRange(0, ret.length))
        return ret
    }
    
    enum TagClass {
        case Gender
        case Vip
        case Feeling
    }
}

extension NSAttributedString {

    var tagPrefixtStr: NSMutableAttributedString {
        
        let ret = NSMutableAttributedString(attributedString: UserTagHelper.instance.spaceAtt)
        ret.appendAttributedString(self)
        ret.addAttributes([NSKernAttributeName: 3], range: NSMakeRange(0, ret.length))
        return ret
    }
    
    var tagSubfixtStr: NSMutableAttributedString {
        
        let ret = NSMutableAttributedString(attributedString: self)
        ret.appendAttributedString(UserTagHelper.instance.spaceAtt)
        ret.addAttributes([NSKernAttributeName: 3], range: NSMakeRange(0, ret.length))
        return ret
    }
}

