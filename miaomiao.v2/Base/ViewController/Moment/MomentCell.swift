//
//  MomentCell.swift
//  miaomiao.v2
//
//  Created by minbaba on 16/4/11.
//  Copyright © 2016年 MiaoquTech Inc. All rights reserved.
//

import UIKit
import RxSwift
import Kingfisher

class MomentCell: UITableViewCell {
    
    let avator = UIButton(type: .Custom)
    let nameLabel = UILabel()
    let typeHintLabel = UILabel()
    let contentTextLabel = UILabel()
    var imageArray = Array<UIButton>()
    let positionButton = UIButton()
    
    let timeLabel = UILabel()
    let seprator = Factory.seprator(CGRectMake(12, 0, screenWidth - 24, 0.5))
    
    let likeButton = UIButton()
    let commentButton = UIButton()
//    let likeHint = UIImageView(image: UIImage(named: "动态_icon_nor_赞"))
//    let commentHint = UIImageView(image: UIImage(named: "动态_icon_nor_评论"))
//    var likeAvatorArray = Array<UIButton>()
//    var commentItemArray = Array<UILabel>()
//    let commentBackGround = UIImageView()
    
    let rx_mmLikeAvatorTap = PublishSubject<Int>()
    let rx_PicTap = PublishSubject<Int>()

    let avatorClicked = PublishSubject<Int>()
    private var disposeBag: DisposeBag!
    
    let tagLabel = UILabel()
    let viewCountLabel = Factory.secondLabel
    let oprationButton = UIButton()
    let sourceLabel = Factory.secondLabel
    
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.contentView.addSubview(avator)
        
        self.contentView.addSubview(nameLabel)
        self.contentView.addSubview(typeHintLabel)
        self.contentView.addSubview(contentTextLabel)
        self.contentView.addSubview(timeLabel)
        self.contentView.addSubview(likeButton)
        self.contentView.addSubview(commentButton)
        self.contentView.addSubview(positionButton)
        self.contentView.addSubview(sourceLabel)
//        self.contentView.addSubview(commentBackGround)
//        self.contentView.addSubview(likeHint)
//        self.contentView.addSubview(commentHint)
        
        self.contentView.addSubview(tagLabel)
        self.contentView.addSubview(viewCountLabel)
        self.contentView.addSubview(oprationButton)
        
        nameLabel.font = FontSizeConf.Second.toFont()
        nameLabel.textColor = ColorConf.Text.FirstTextColor.toColor()
        
        sourceLabel.textAlignment = .Right
        
        oprationButton.contentHorizontalAlignment = .Right
        oprationButton .setImage(UIImage(named: "动态_icon_下箭头"), forState: .Normal)
        
        contentTextLabel.numberOfLines = 0
        contentTextLabel.font = FontSizeConf.Second.toFont()
        contentTextLabel.textColor = ColorConf.Text.FirstTextColor.toColor()
        
        positionButton.setImage(UIImage(named: "动态_icon_位置"), forState: .Normal)
        positionButton.titleLabel?.font = FontSizeConf.Third.toFont()
        positionButton.contentHorizontalAlignment = .Left
        positionButton.titleEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0)
        positionButton.setTitleColor(ColorConf.Text.SecondTextColor.toColor(), forState: .Normal)
        
        timeLabel.font = FontSizeConf.Third.toFont()
        timeLabel.textColor = ColorConf.Text.SecondTextColor.toColor()
        
        likeButton.setTitleColor(ColorConf.Text.FirstTextColor.toColor(), forState: .Normal)
        likeButton.titleLabel?.font = FontSizeConf.Third.toFont()
        likeButton.imageEdgeInsets = UIEdgeInsetsMake(0, -2.5, 0, 2.5)
        likeButton.titleEdgeInsets = UIEdgeInsetsMake(0, 2.5, 0, -2.5)
        likeButton.setImage(UIImage(named: "动态_icon_nor_赞"), forState: .Normal)
        likeButton.setImage(UIImage(named: "动态_icon_sel_赞"), forState: .Selected)
        
        commentButton.setTitleColor(ColorConf.Text.FirstTextColor.toColor(), forState: .Normal)
        commentButton.titleLabel?.font = FontSizeConf.Third.toFont()
        commentButton.imageEdgeInsets = UIEdgeInsetsMake(0, -2.5, 0, 2.5)
        commentButton.titleEdgeInsets = UIEdgeInsetsMake(0, 2.5, 0, -2.5)
        commentButton.setImage(UIImage(named: "动态_icon_nor_评论"), forState: .Normal)
        commentButton.setImage(UIImage(named: "动态_icon_sel_评论"), forState: .Selected)
        commentButton.userInteractionEnabled = false
        
//        likeHint.contentMode = .Center
//        likeHint.layer.masksToBounds = true
//        commentHint.contentMode = .Center
//        commentHint.layer.masksToBounds = true
//        
//        commentBackGround.image = UIImage(named: "动态_bg_评论区")?.resizableImageWithCapInsets(UIEdgeInsetsMake(10, 10, 10, 10))
//        commentBackGround.userInteractionEnabled = true
        
        contentView.layer.addSublayer(Factory.seprator(CGRectMake(0, 0, screenWidth, 10)))
        contentView.layer.addSublayer(seprator)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /// 布局模型
    var layout:MomentCellLayout! {
        
        didSet {
            
            // 为每个 layout 更换资源释放池
            disposeBag = DisposeBag()
            
            initView()
            
            avator.frame = (layout?.avatorRect)!
            avator.kf_setImageWithURL(layout.moment.headPortrait.mqimageUrl(.Normal), forState: .Normal, placeholderImage: placeHolderImage, optionsInfo: nil, progressBlock: nil)  { [weak avator] (image, error, cacheType, imageURL) in
                avator?.setImage(image?.mbb_drawRectWithRoundedCorner(radius: 20, CGSizeMake(40, 40)), forState: .Normal)
            }
            avator.rx_tap.map{ [weak self] in self!.layout.moment.userId }.bindTo(avatorClicked).addDisposableTo(disposeBag)
            
            tagLabel.frame = layout.tagRect
            tagLabel.attributedText = layout.tagStr
            
            seprator.frame.origin.y = CGFloat(layout.height) - 40
            
            setUpNameLabel()
            setUptextContent()
            setUpPicContent()
            setUpInfoView()
//            setUpComment()
        }
    }
    
}

// MARKT: - 配置
extension MomentCell {
    
    func removeView(from: Int, to:[UIView]) {
        if from < to.count {
            for index in from..<to.count {
                to[index].removeFromSuperview()
            }
        }
    }
    
    func initView() {
        
        removeView(layout.imageRectArray.count, to: imageArray)
//        removeView(layout.likeAvatorRectArray.count, to: likeAvatorArray)
//        removeView(layout.commentRectArray.count, to: commentItemArray)
    }

    private func setUpNameLabel() {
        nameLabel.attributedText = layout.name
        nameLabel.frame = layout.nameLabelRect
        nameLabel.textColor = (layout.moment.vipType > 0 ? ColorConf.Text.VipStrokColor : .FirstTextColor).toColor()
        
        sourceLabel.text = layout.moment.relationType.momentRelation
        sourceLabel.frame = layout.sourceRect
        
        oprationButton.frame = layout.oprationRect
    }
    
    private func setUptextContent() {
        contentTextLabel.attributedText = layout.text
        contentTextLabel.frame = layout.textContentRect
    }
    
    func setUpPicContent() {
        
        let imageArr = layout.moment.images.componentsSeparatedByString(",")
        for index in 0..<layout.imageRectArray.count {
            
            let imageButton:UIButton!
            if index < imageArray.count {
                imageButton = imageArray[index]
            } else {
                imageButton = UIButton()
                imageButton.imageView?.contentMode = .ScaleAspectFill
                imageButton.imageView?.snp_updateConstraints(closure: { (make) in
                    make.top.left.bottom.right.equalTo(0)
                })
                
                imageArray.append(imageButton)
            }
            
            imageButton.kf_setImageWithURL(imageArr[index].mqimageUrl(.Normal), forState: .Normal, placeholderImage: placeHolderImage)
            imageButton.frame = layout.imageRectArray[index]
            self.contentView.addSubview(imageButton)
        }
        
        mqRxBindButton(imageArray).bindTo(rx_PicTap).addDisposableTo(disposeBag)
    }
    
    private func setUpInfoView() {
        
        positionButton.frame = layout.positionRect
        positionButton.setTitle(layout.moment.position, forState: .Normal)
        
        timeLabel.text = layout.moment.createTime.toDate.intervalDescription()
        timeLabel.frame = layout.timeRect
        
        viewCountLabel.frame = layout.viewCountRect
        viewCountLabel.text = "\(layout.moment.viewCount)次浏览"
        
        likeButton.frame = layout.likeButtonRect
        likeButton.setTitle(String(layout.moment.praiseCount), forState: .Normal)
        likeButton.selected = layout.moment.praised
        
        commentButton.frame = layout.commentButtonRect
        commentButton.setTitle(String(layout.moment.commentCount), forState: .Normal)
//        commentButton.selected = layout.moment.isCommented
    }
    
//    private func setUpComment() {
//        
//        likeHint.frame = layout.likeHintRect
//        commentHint.frame = layout.commentHintRect
//        
//        commentBackGround.frame = layout.commentBgRect
//        for index in 0..<layout.likeAvatorRectArray.count {
//            
//            let avator:UIButton!
//            if index < likeAvatorArray.count {
//                avator = likeAvatorArray[index]
//            } else {
//                avator = UIButton()
//                avator.imageView?.contentMode = .ScaleAspectFill
//                likeAvatorArray.append(avator)
//            }
//            
//            let praiser = layout.moment.praiseList[index]
//            avator.kf_setImageWithURL(praiser.headPortrait.mqimageUrl(.Smallest), forState: .Normal, placeholderImage: placeHolderImage)
//            avator.frame = layout.likeAvatorRectArray[index]
//            commentBackGround.addSubview(avator)
//            avator.rx_tap.map{ [weak praiser] in praiser!.userId }.bindTo(avatorClicked).addDisposableTo(disposeBag)
//        }
//        
//        for index in 0..<layout.commentRectArray.count {
//            
//            let item:UILabel!
//            if index < commentItemArray.count {
//                item = commentItemArray[index]
//            } else {
//                item = UILabel()
//                item.numberOfLines = 0
//                commentItemArray.append(item)
//            }
//            
//            let (rect, str) = layout.commentRectArray[index]
//            item.frame = rect
//            item.attributedText = str
//            commentBackGround.addSubview(item)
//        }
//    }
}
