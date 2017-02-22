//
//  GetuiService.swift
//  miaomiao.v2
//
//  Created by minbaba on 16/6/3.
//  Copyright © 2016年 MiaoquTech Inc. All rights reserved.
//


class GetuiService: NSObject, GeTuiSdkDelegate {
    
    static let instance = GetuiService()
    
    static var getuiClientId = "miaoqu_getui_clientId_key"
    var clientId = NSUserDefaults.standardUserDefaults().stringForKey(GetuiService.getuiClientId) ?? "" {
        didSet {
            NSUserDefaults.standardUserDefaults().setValue(clientId, forKey: GetuiService.getuiClientId)
        }
    }
    
    
    private override init() {
        super.init()
        
        GeTuiSdk.startSdkWithAppId("8rftInCEog9qVTe2Jt3paA", appKey: "oib2N8Lwn69sv9mjoN5bhA", appSecret: "eyJ1qE6pnd5X3A7K3u83X1", delegate: self);

    }
    
    /** 注册用户通知(推送) */
    func registerUserNotification(application: UIApplication) {
        let result = UIDevice.currentDevice().systemVersion.compare("8.0.0", options: NSStringCompareOptions.NumericSearch)
        if (result != NSComparisonResult.OrderedAscending) {
            UIApplication.sharedApplication().registerForRemoteNotifications()
            
            let userSettings = UIUserNotificationSettings(forTypes: [.Badge, .Sound, .Alert], categories: nil)
            UIApplication.sharedApplication().registerUserNotificationSettings(userSettings)
        } else {
            UIApplication.sharedApplication().registerForRemoteNotificationTypes([.Alert, .Sound, .Badge])
        }
    }
    
    func registerDeviceToken(deviceToken: NSData) {
        var token = deviceToken.description.stringByTrimmingCharactersInSet(NSCharacterSet(charactersInString: "<>"));
        token = token.stringByReplacingOccurrencesOfString(" ", withString: "")
        
        // [3]:向个推服务器注册deviceToken
        GeTuiSdk.registerDeviceToken(token)
    }
    
}

extension GetuiService {
    
    /** SDK启动成功返回cid */
    func GeTuiSdkDidRegisterClient(clientId: String!) {
        
        self.clientId = clientId
    }
    
    /** SDK遇到错误回调 */
    func GeTuiSdkDidOccurError(error: NSError!) {
        // [EXT]:个推错误报告，集成步骤发生的任何错误都在这里通知，如果集成后，无法正常收到消息，查看这里的通知。
        NSLog("\n>>>[GeTuiSdk error]:%@\n\n", error.localizedDescription);
    }
    
    /** SDK收到sendMessage消息回调 */
    func GeTuiSdkDidSendMessage(messageId: String!, result: Int32) {
        // [4-EXT]:发送上行消息结果反馈
        let msg:String = "sendmessage=\(messageId),result=\(result)";
        NSLog("\n>>>[GeTuiSdk DidSendMessage]:%@\n\n",msg);
    }
    
    func GeTuiSdkDidReceivePayloadData(payloadData: NSData!, andTaskId taskId: String!, andMsgId msgId: String!, andOffLine offLine: Bool, fromGtAppId appId: String!) {
        do {
            let dict = try! NSJSONSerialization.JSONObjectWithData(payloadData, options: .MutableContainers) as! [String : AnyObject]
            print(dict)
            RemoteMessageServer.instance.addMessage(dict)
        } catch {
            
        }

    }

}
