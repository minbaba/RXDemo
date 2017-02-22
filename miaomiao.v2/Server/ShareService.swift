//
//  ShareService.swift
//  miaomiao.v2
//
//  Created by 郑敏 on 16/7/5.
//  Copyright © 2016年 MiaoquTech Inc. All rights reserved.
//

import UIKit
import RxSwift
import Kingfisher

class ShareService {
    
    static let instance = ShareService()
    
    static let shareImagePath = "http://7xseyj.com2.z0.glb.qiniucdn.com/share.jpg"
    var shareImage: UIImage { return iv.image ?? UIImage(named: "分享_icon_logo")! }
    
    private let iv = UIImageView()
    
    var rx_shareResult = PublishSubject<Bool>()
    
    func share(message: Message) {
        
        switch message.type {
        case .WX: fallthrough
        case .WXTimeline:
            self.shareToWX(message)
            break
            
        case .QQ: fallthrough
        case .Qzone:
            self.shareToQQ(message)
            break
        }
    }
    

    private init() {
        let _ = TencentOAuth(appId: "1105021599", andDelegate: nil)
        
        print(ShareService.shareImagePath.mqimageUrl(.Origin).absoluteString)
        KingfisherManager.sharedManager.cache.removeImageForKey(ShareService.shareImagePath)
        iv.kf_setImageWithURL(NSURL(string: ShareService.shareImagePath)!)
    }
    func shareToWX(message: Message) {
        
        let imageObject = WXImageObject()
        imageObject.imageData = UIImageJPEGRepresentation(message.image, 1)
        
        let messageObject = WXMediaMessage()
        messageObject.setThumbImage(message.image.resize(400).press(32 << 10))
        messageObject.mediaObject = imageObject
        
        let req = SendMessageToWXReq()
        req.message = messageObject
        req.bText = false
        req.scene = Int32( (message.type == .WX ? WXSceneSession: WXSceneTimeline).rawValue )
        
        
        WXApi.sendReq(req)
    }
    
    func shareToQQ(message: Message) {
        
        
        let obg = QQApiImageObject(data: UIImageJPEGRepresentation(message.image!, 1), previewImageData: UIImageJPEGRepresentation(message.image!, 1), title: message.title, description: message.description)
        let req = SendMessageToQQReq(content: obg)
        
        if message.type == .QQ {
            QQApiInterface.sendReq(req)
        } else {
            QQApiInterface.SendReqToQZone(req)
        }
    }
    
    func installedType() -> [ShareType] {
        
        var arr = [ShareType]()
        if QQApiInterface.isQQInstalled() {
            arr.append(.QQ)
            arr.append(.Qzone)
        }
        if WXApi.isWXAppInstalled() {
            arr.append(.WX)
            arr.append(.WXTimeline)
        }
        
        return arr
    }
    
    func dealResp(resp: BaseResp!) {
        if let resp = resp as? SendMessageToWXResp {
            rx_shareResult.onNext(WXErrCode(resp.errCode) == WXSuccess)
        }
    }
    
    enum ShareType: String {
        case QQ = "QQ好友"
        case Qzone = "QQ空间"
        case WX = "微信好友"
        case WXTimeline = "微信朋友圈"
    }
    
    struct Message {
        var title = ""
        var description = ""
        var url = ""
        var image: UIImage!
        
        var type = ShareType.WX
        
    }
}
