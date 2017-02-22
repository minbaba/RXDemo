//
//  MomentDetailHeader.swift
//  miaomiao.v2
//
//  Created by minbaba on 16/5/26.
//  Copyright © 2016年 MiaoquTech Inc. All rights reserved.
//

import UIKit
import RxSwift
//动态详情
class MomentDetailHeader: UIView {
    
    let avator = UIButton(type: .Custom)
    let nameLabel = UILabel()
    let typeHintLabel = UILabel()
    let contentTextLabel = UILabel()
    var imageArray = Array<UIButton>()
    let positionButton = UIButton()
    let timeLabel = UILabel()
    let likeButton = UIButton()
    let commentButton = UIButton()
    
    let disposeBag = DisposeBag()
    
    let viewCountLabel = Factory.secondLabel
    let oprationButton = UIButton()
    let sourceLabel = Factory.secondLabel
    let tagLabel = UILabel()
    
    let seprator = Factory.seprator(CGRectMake(12, 0, screenWidth - 24, 0.5))
    let bottomSep = Factory.seprator(CGRectMake(0, 0, screenWidth, 10))
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.addSubview(avator)
        
        self.addSubview(nameLabel)
        self.addSubview(typeHintLabel)
        self.addSubview(contentTextLabel)
        self.addSubview(timeLabel)
        self.addSubview(likeButton)
        self.addSubview(commentButton)
        self.addSubview(positionButton)
        self.addSubview(sourceLabel)
        
        self.addSubview(tagLabel)
        self.addSubview(viewCountLabel)
        self.addSubview(oprationButton)
        
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
//        commentButton.userInteractionEnabled = false
        
        backgroundColor = ColorConf.View.White.toColor()
        
        self.layer.addSublayer(bottomSep)
        self.layer.addSublayer(Factory.seprator(CGRectMake(0, 0, screenWidth, 10)))
        self.layer.addSublayer(seprator)
    }
    
    var layout: MomentCellLayout! {
    
        didSet {
            initView()
            
            avator.frame = (layout?.avatorRect)!
            avator.kf_setImageWithURL(layout.moment.headPortrait.mqimageUrl(.Normal), forState: .Normal, placeholderImage: placeHolderImage, optionsInfo: nil, progressBlock: nil)  { [weak avator] (image, error, cacheType, imageURL) in
                avator?.setImage(image?.mbb_drawRectWithRoundedCorner(radius: 20, CGSizeMake(40, 40)), forState: .Normal)
            }
            
            tagLabel.frame = layout.tagRect
            tagLabel.attributedText = layout.tagStr
            
            seprator.frame.origin.y = CGFloat(layout.height) - 40
            setUpNameLabel()
            setUptextContent()
            setUpPicContent()
            setUpInfoView()
            
            self.frame = CGRectMake(0, 0, screenWidth, CGFloat(layout.height) + 10)
            bottomSep.frame.origin.y = CGFloat(layout.height)
        }
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


extension MomentDetailHeader {
    
    func removeView(from: Int, to:[UIView]) {
        if from < to.count {
            for index in from..<to.count {
                to[index].removeFromSuperview()
            }
        }
    }
    
    func initView() {
        
        removeView(layout.imageRectArray.count, to: imageArray)
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
            self.addSubview(imageButton)
        }
        
        mqRxBindButton(imageArray).subscribeNext {[weak self] (index) in
            let models = self!.layout.moment.images.componentsSeparatedByString(",").map { PhotoModel(imageUrlString: $0.mq_imgOriginUrl, sourceImageView: nil, description: nil)
            }
            let browser = PhotoBrowser(photoModels: models)
            browser.showWithBeginPage(index)
        }.addDisposableTo(disposeBag)
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
    
}

