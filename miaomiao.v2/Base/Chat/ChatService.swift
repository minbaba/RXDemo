//
//  ChatService.swift
//  miaomiao.v2
//
//  Created by minbaba on 16/4/27.
//  Copyright © 2016年 MiaoquTech Inc. All rights reserved.
//

import Foundation
import RxSwift



class ChatService: NSObject, EMChatManagerDelegate, EMGroupManagerDelegate {
    
    let disposeBag = DisposeBag()
    static let officialId = "miaomiao-official"
    
    
    /// 会话列表
    dynamic var conversations = [AnyObject]()
    
    /// 单例
    static let defaultService = ChatService()
    
    /// 收到消息的流
    let rx_receiveMessage = PublishSubject<EMMessage>()
    
    var isLogin: Bool {
        let b = EMClient.sharedClient().isLoggedIn
        if !b {
            HintAlert.showText("聊天服务器登录失败")
            login("emidmiaoqutech\(AppInfoService.instance.currentUserId)", password: "empdmiaoqutech\(AppInfoService.instance.currentUserId)")
        }
        return b
    }
    
    /**
     启动聊天服务
     */
    func setUp() {
        
        let options = EMOptions(appkey: "miaoqukeji#miaomiao")

        
        options.isAutoAcceptFriendInvitation = true
        options.apnsCertName = "miaomiao_dis_push"
        options.isAutoAcceptGroupInvitation = true
        EMClient.sharedClient().initializeSDKWithOptions(options)
        
        NSNotificationCenter.defaultCenter().rx_notification(AppInfoService.userLoginSucc).subscribeNext {[weak self] (_) in
            self?.login("emidmiaoqutech\(AppInfoService.instance.currentUserId)", password: "empdmiaoqutech\(AppInfoService.instance.currentUserId)")
        }.addDisposableTo(disposeBag)
        NSNotificationCenter.defaultCenter().rx_notification(AppInfoService.userLogoutSucc).subscribeNext {[weak self] (noti) in
            self?.loginOut()
            }.addDisposableTo(disposeBag)
        
        EMClient.sharedClient().chatManager.addDelegate(self, delegateQueue: nil)
        EMClient.sharedClient().groupManager.addDelegate(self, delegateQueue: nil)
    }
    
    /**
     登录
     
     - parameter userName:  用户名
     - parameter password:  密码
     - parameter autoLogin: 自动登录
     */
    func login(userName:String, password:String, autoLogin:Bool = true, message: EMMessage? = nil) {
        
        
        EMClient.sharedClient().asyncLoginWithUsername(userName, password: password, success: {[weak self] in
            
            self?.reloadConversations()
            EMClient.sharedClient().options.isAutoLogin = autoLogin
            if let mess = message {
                self?.send(mess)
            }
        }) { (error) in
            
            print(error)
            
            switch error.code {
            case EMErrorUserNotFound:
                self.register(userName, pwd: password)
                break
            default:
                break
            }
        }
    }
    
    /**
     注销
     */
    func loginOut() {
        
        EMClient.sharedClient().asyncLogout(true, success: { 
            
            }) { (error) in
                print(error)
        }
    }
    
    /**
     注册环信账户
     
     - parameter username: 用户名
     - parameter pwd:      密码
     */
    func register(username: String, pwd: String) {
        EMClient.sharedClient().asyncRegisterWithUsername(username, password: pwd, success: { 
            self.login(username, password: pwd)
            }) { (error) in
                switch error.code {
                case EMErrorUserAlreadyExist :
                    self.login(username, password: pwd, message: EMMessage(conversationID: ChatService.officialId, from: ChatService.officialId, to: username, body: EMTextMessageBody(text: "亲爱的妙喵用户，我们为您精心推荐了好多妹子和汉子~~~~\n快到碗里来吧"), ext: nil))
                    break
                case EMErrorNetworkUnavailable:
                    break
                default:
                    self.register(username, pwd: pwd)
                    break
                }
        }
    }
    
    /**
     告知 sdk app 进入前台
     
     - parameter application: app
     */
    func chatServiceToFront(application: UIApplication = UIApplication.sharedApplication()) {
        EMClient.sharedClient().applicationWillEnterForeground(application)
    }
    
    /**
     告知 sdk app 进入后台
     
     - parameter application: app
     */
    func chatServiceToBack(application: UIApplication = UIApplication.sharedApplication()) {
        EMClient.sharedClient().applicationDidEnterBackground(application)
    }
    
    func getConversation(conversationId: String) -> EMConversation {
        return EMClient.sharedClient().chatManager.getConversation(conversationId, type: EMConversationTypeChat, createIfNotExist: true)
    }
    
    func reloadConversations() {
        self.conversations = EMClient.sharedClient().chatManager.getAllConversations() as! [EMConversation]
    }
}


extension ChatService {

    func didUpdateConversationList(aConversationList: [AnyObject]!) {
        self.conversations = aConversationList as! [EMConversation]
    }
    
    func didReceiveMessages(aMessages: [AnyObject]!) {
        
        if let messages = aMessages as? [EMMessage] {
            RemoteMessageServer.instance.addMessage(["type": 1000001])
            for message in messages {
                rx_receiveMessage.onNext(message)
            }
        }
        
        // 后台时添加本地推送
        if UIApplication.sharedApplication().applicationState == .Background {
            let notification = UILocalNotification()
            notification.applicationIconBadgeNumber = RemoteMessageServer.instance.messageCount
            notification.alertBody = "您有一条新消息"
            UIApplication.sharedApplication().scheduleLocalNotification(notification)
        }
        
        self.reloadConversations()
    }
    
    /**
     加入群之后的回调
     
     - parameter aGroup:   加入的群
     - parameter aInviter: 邀请者
     - parameter aMessage: 邀请消息
     */
    func didJoinedGroup(aGroup: EMGroup!, inviter aInviter: String!, message aMessage: String!) {
        
        let conversation = EMClient.sharedClient().chatManager.getConversation(aGroup.groupId, type: EMConversationTypeGroupChat, createIfNotExist: true)
        let ext = JSON(data: aMessage.dataUsingEncoding(NSUTF8StringEncoding)!).dictionaryObject ?? [:]
        
        for message in ChatService.getTipMessages(ext, sender: aInviter, conversationId: conversation.conversationId) {
            conversation.insertMessage(message)
            RemoteMessageServer.instance.addMessage(["type": 1000001])
        }
    }
    
    class func getTipMessages(ext: [String: AnyObject], sender: String, conversationId: String) -> [EMMessage] {
        
        var arr = [EMMessage]()
        
        var notiExt = ext
        notiExt["type"] = "__MM_HL_NOTIFY__"
        notiExt["text"] = notiExt["notify"]
        var message = EMMessage(conversationID: conversationId, from: sender, to: conversationId, body: EMTextMessageBody(text: notiExt["text"] as? String ?? ""), ext: notiExt)
        arr.append(message)
        
        var tipExt = ext
        tipExt["type"] = "__MM_HL_HB__"
        message = EMMessage(conversationID: conversationId, from: sender, to: conversationId, body: EMTextMessageBody(text: tipExt["text"] as? String ?? ""), ext: tipExt)
        arr.append(message)
        
        return arr
    }
    
    func send(message:EMMessage) {
        var ext = message.ext ?? [:]
        ext["sendNickname"] = UserServer.instance.user.nickname
        ext["sendHeadPortrait"] = UserServer.instance.user.headPortrait
        message.ext = ext
        EMClient.sharedClient().chatManager.asyncSendMessage(message, progress: { (progress) in
            
        }) { (message, error) in

        }
    }
    
    static func miaoId(emId: String) -> Int {
        
        if emId.characters.count < 14 {
            return 0
        }
        return Int(emId.substringFromIndex(emId.startIndex.advancedBy(14))) ?? 0
    }
    
    static func emId(miaoId: Int) -> String {
        return "emidmiaoqutech" + "\(miaoId)"
    }
}
