//
//  AppDelegate+PayOpration.swift
//  miaomiao.v2
//
//  Created by minbaba on 16/6/15.
//  Copyright © 2016年 MiaoquTech Inc. All rights reserved.
//

import Foundation

extension AppDelegate: WXApiDelegate {
    
    
    func dealPayOption(option: [String : AnyObject], url: NSURL) {
        if let app = option["UIApplicationOpenURLOptionsSourceApplicationKey"] as? String {
            if app == "com.tencent.xin" {
                
                WXApi.handleOpenURL(url, delegate: self)
            } else if app == "com.alipay.iphoneclient" {
                
                
                AlipaySDK.defaultService().processOrderWithPaymentResult(url, standbyCallback: { (result) in
                    
                    NSNotificationCenter.defaultCenter().postNotificationName(PayViewModel.payResultNoti, object: (result["resultStatus"] as? String) == "9000" ? "ok": "faild")
//                    NSNotificationCenter.defaultCenter().postNotificationName(PayViewModel.payResultNoti, object: "succ")
                })
                
            }
        }
    }
    
    
    func onResp(resp: BaseResp!) {
        if let resp = resp as? PayResp {
            if WXErrCode(resp.errCode) == WXSuccess {
                NSNotificationCenter.defaultCenter().postNotificationName(PayViewModel.payResultNoti, object: "succ")
            } else {
                NSNotificationCenter.defaultCenter().postNotificationName(PayViewModel.payResultNoti, object: "faild")
                
            }
        }
        
        
        if resp.isKindOfClass(SendAuthResp.self) {
            // SendAuthResp *response=(SendAuthResp *)resp;
//            NSNotificationCenter.defaultCenter().postNotificationName(MQHL_WECHAT_CODE_NOTIFICATION, object: response.code, userInfo: nil)
        }

    }
    
    func onReq(req: BaseReq!) {
        
    }
    
}
