//
//  MomentCellLayout.swift
//  miaomiao.v2
//
//  Created by minbaba on 16/4/11.
//  Copyright © 2016年 MiaoquTech Inc. All rights reserved.
//

import UIKit

class MomentCellLayout: NSObject {
    
    let avatorRect = CGRectMake(12, 20, 40, 40)
    let tagRect = CGRectMake(62, 45, 150, 15)
    let sourceRect = CGRectMake(screenWidth - 12 - 100, 20, 80, 40)
    let oprationRect = CGRectMake(screenWidth - 12 - 50, 20, 50, 40)
    
    var nameLabelRect = CGRectZero
    var typeHintLabelRect = CGRectZero
    var textContentRect:CGRect = CGRectZero
    var imageRectArray = Array<CGRect>()
    var positionRect = CGRectZero
    var timeRect = CGRectZero
    var viewCountRect = CGRectZero
    
    var likeButtonRect = CGRectZero
    var commentButtonRect = CGRectZero
//    var likeHintRect = CGRectZero
//    var commentHintRect = CGRectZero
//    var likeAvatorRectArray = Array<CGRect>()
//    var commentRectArray = Array<(CGRect, NSAttributedString)>()
//    var commentBgRect:CGRect = CGRectZero
    
    var text: NSAttributedString?
    var tagStr: NSAttributedString?
    var subTimeStr: String!
    
    var showImageCount = 6
    var name: NSMutableAttributedString?
    
    
    var moment:MomentModel!
    var height = 0.0
    
    
    private let contentWidth = screenWidth - 24
    
    
    
    init(moment:MomentModel) {
        
        super.init()
        
        self.moment = moment

        
        layoutNameLabelRect()
        layoutTypeHintLabelRect()
        layoutTextContentRect()
        layoutImageRects()
        layoutInfoView()
//        layoutCommentView()
    }
}

extension MomentCellLayout {

    /**
     计算昵称布局
     */
    private func layoutNameLabelRect() {
        
        name = TextEmotionParser.instance.parse(NSMutableAttributedString(string: self.moment.remarkNickname, attributes: [NSFontAttributeName: FontSizeConf.Second.toFont(), NSForegroundColorAttributeName: ColorConf.Text.FirstTextColor.toColor()]))
//        name?.appendAttributedString(UserTagHelper.instance.parse(moment: moment).tagPrefixtStr)
        nameLabelRect = CGRectMake(CGRectGetMaxX(avatorRect) + 10, 0, screenWidth - CGRectGetMaxX(avatorRect) - 83, 20)
        nameLabelRect.origin = CGPointMake(CGRectGetMaxX(avatorRect) + 12, avatorRect.origin.y)
        
        tagStr = UserTagHelper.instance.parse(moment: moment)
    }
    
    /**
     计算来源布局
     */
    private func layoutTypeHintLabelRect()  {
        typeHintLabelRect = CGRectMake(nameLabelRect.origin.x, CGRectGetMaxY(nameLabelRect), contentWidth, avatorRect.size.height - nameLabelRect.size.height);
    }
    
    /**
     计算内容布局
     */
    private func layoutTextContentRect() {
        text = TextEmotionParser.instance.parse(NSMutableAttributedString(string: moment.content, attributes: [NSFontAttributeName: FontSizeConf.Second.toFont(), NSForegroundColorAttributeName: ColorConf.Text.FirstTextColor.toColor()]))
        textContentRect = text?.boundingRectWithSize(CGSizeMake(contentWidth, CGFloat(MAXFLOAT)), options: [.UsesLineFragmentOrigin, .UsesFontLeading], context: nil) ?? CGRectZero
        textContentRect.size.height = textContentRect.height + 1
        textContentRect.origin = CGPointMake(avatorRect.origin.x, CGRectGetMaxY(avatorRect) + 10)
    }
    
    /**
     计算图片内容布局
     */
    private func layoutImageRects() {
        
        imageRectArray.removeAll()
        
        let column = 3
        let imageSpace: CGFloat = 1.0
        let imageWidth = (contentWidth - imageSpace * 2) / CGFloat(column)
        let imageHeight = imageWidth
        let imageOriginY = CGRectGetMaxY(textContentRect) + 10
        
        let imageArr = moment.images.componentsSeparatedByString(",")
        let max = min(showImageCount, imageArr.count)
        for index in 0..<max {
            imageRectArray.append(CGRectMake(CGFloat(index % column) * (imageWidth + imageSpace) + avatorRect.origin.x, imageOriginY + CGFloat(index / column) * (imageSpace + imageHeight), imageWidth, imageHeight))
        }
    }
    
    /**
     计算发布时间、点赞按钮、评论按钮、位置信息
     */
    private func layoutInfoView() {
        
        let orignY = imageRectArray.count > 0 ? CGRectGetMaxY(imageRectArray.last!): CGRectGetMaxY(textContentRect)
        
//        positionRect = CGRectMake(CGRectGetMinX(avatorRect), orignY, contentWidth, 30)
//        if moment.position.characters.count == 0 {
//            positionRect.size.height = 0
//        }
//        orignY = CGRectGetMaxY(positionRect)
        
        subTimeStr = moment.createTime.toDate.intervalDescription()
        timeRect = subTimeStr.boundingRectWithSize(CGSizeMake(CGFloat(MAXFLOAT), CGFloat(MAXFLOAT)), attributes: [NSFontAttributeName:FontSizeConf.Second.toFont()])
        timeRect = CGRectMake(avatorRect.origin.x, orignY, timeRect.width, 30)
        
        viewCountRect = CGRectMake(CGRectGetMaxX(timeRect) + 15, timeRect.origin.y, 150, 30)
        
        likeButtonRect = CGRectMake(avatorRect.origin.x, CGRectGetMaxY(timeRect), contentWidth / 2, 40)
        commentButtonRect = CGRectMake(CGRectGetMaxX(likeButtonRect), CGRectGetMaxY(timeRect), contentWidth / 2, 40)
        
//        var width = String(moment.commentCount).boundingRectWithSize(CGSizeMake(CGFloat(MAXFLOAT), CGFloat(MAXFLOAT)), attributes: [NSFontAttributeName:FontSizeConf.Second.toFont()]).width + 17
//        commentButtonRect = CGRectMake(screenWidth - 12 - width, orignY, width, 25)
//        
//        width = String(moment.praiseCount).boundingRectWithSize(CGSizeMake(CGFloat(MAXFLOAT), CGFloat(MAXFLOAT)), attributes: [NSFontAttributeName:FontSizeConf.Second.toFont()]).width + 17
//        likeButtonRect = CGRectMake(CGRectGetMinX(commentButtonRect) - 20 - width, orignY, width, 25)
//
//        timeRect = CGRectMake(CGRectGetMinX(nameLabelRect), orignY, CGRectGetMinX(likeButtonRect) - CGRectGetMinX(nameLabelRect), 25)
        
        height = Double(CGRectGetMaxY(commentButtonRect)) // + 10
    }
    
    /**
     计算评论区布局
     */
//    func layoutCommentView() {
//        
//        let commentViewWidth = contentWidth
//        commentBgRect = CGRectMake(CGRectGetMinX(nameLabelRect), CGRectGetMaxY(timeRect), commentViewWidth, 0)
//        
//        for index in 0..<moment.praiseList.count {
//            
//            let rect = CGRectMake(5 + 35 * CGFloat(index), 17, 30, 30)
//            if CGRectGetMaxX(rect) < commentViewWidth - 5 {
//                likeAvatorRectArray.append(rect)
//                commentBgRect.size = CGSizeMake(commentViewWidth, 57)
//                likeHintRect = CGRectMake(CGRectGetMinX(nameLabelRect) - 30, CGRectGetMaxY(timeRect) + 17, 30, 30)
//            }
//        }
//        moment.isLiked = moment.praiseList.filter { $0.userId == UserServer.instance.user.userId }.count > 0
//        
//        
//        for index in 0..<moment.commentList.count {
//            
//            let comment = moment.commentList[index]
//            var mAttStr = NSMutableAttributedString(string: comment.remarkNickname + ":" + comment.content, attributes: [NSFontAttributeName: FontSizeConf.Third.toFont()])
//            mAttStr.addAttribute(NSForegroundColorAttributeName, value: ColorConf.Text.MarketName.toColor(), range: NSMakeRange(0, comment.remarkNickname.characters.count + 1))
//            mAttStr.addAttribute(NSForegroundColorAttributeName, value: ColorConf.Text.FirstTextColor.toColor(), range: NSMakeRange(comment.remarkNickname.characters.count + 1, comment.content.characters.count))
//            mAttStr = TextEmotionParser.instance.parse(mAttStr)
//            
//            var rect = mAttStr.boundingRectWithSize(CGSizeMake(commentViewWidth - 10, CGFloat(MAXFLOAT)), options: [.UsesFontLeading, .UsesLineFragmentOrigin], context: nil)
//            
//            if index == 0 {
//                rect.origin = CGPointMake(5, likeAvatorRectArray.count > 0 ? 57: 17)
//                commentHintRect = CGRectMake(CGRectGetMinX(nameLabelRect) - 30, CGRectGetMaxY(timeRect) + rect.origin.y - 5, 30, 30)
//            } else {
//                rect.origin = CGPointMake(5, CGRectGetMaxY(commentRectArray[index - 1].0) + 5)
//            }
//            
//            commentRectArray.append((rect, mAttStr))
//            commentBgRect.size = CGSizeMake(commentViewWidth, CGRectGetMaxY(rect) + 10)
//        }
//        moment.isCommented = moment.commentList.filter { $0.userId == UserServer.instance.user.userId }.count > 0
//        
//        height = Double(CGRectGetMaxY(commentBgRect)) + 10
//    }
    
}
