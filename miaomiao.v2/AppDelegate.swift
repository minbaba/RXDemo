//
//  AppDelegate.swift
//  miaomiao.v2
//
//  Created by minbaba on 16/3/18.
//  Copyright © 2016年 MiaoquTech Inc. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift
import JSPatch

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    static let miaomiaoScheme = "miaomiao"


    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        
        self.window = UIWindow(frame: UIScreen.mainScreen().bounds)
        self.window?.makeKeyAndVisible()
        
        // 启动地图服务
//        MapService.defaultService.setUp()
        
        setUpUmengSdk()
        
        IQKeyboardManager.sharedManager().enable = true
        IQKeyboardManager.sharedManager().enableAutoToolbar = false
        IQKeyboardManager.sharedManager().shouldResignOnTouchOutside = true
        
        // 初始化UI配置
        UIServer.instance.setUpAppearance()
        
        // 初始化聊天服务
        ChatService.defaultService.setUp()
        
        // 初始化键盘管理器
        KeyBoardService.instance.setUpEmoji()
        
        // 注册个推
        GetuiService.instance.registerUserNotification(application)
        
        // 获取信息
        AppInfoService.instance.setUp()
        
        // 初始化微信api
//        WXApi.registerApp("")
        
        /// 启动jspatch
        JSPatch.startWithAppKey("")
        
        UserServer.instance.setUp()
        
        
        setUpViewController()
        return true
    }

    func applicationWillResignActive(application: UIApplication) {
        
    }

    func applicationDidEnterBackground(application: UIApplication) {
        ChatService.defaultService.chatServiceToBack(application)
    }

    func applicationWillEnterForeground(application: UIApplication) {
        ChatService.defaultService.chatServiceToFront(application)
        
    }

    func applicationDidBecomeActive(application: UIApplication) {
        
        // 获取更新信息
        AppInfoService.instance.getReleseInfo()
        // 更新活跃时间
        AppInfoService.instance.updateLastTime()
        // 清除badge
        application.applicationIconBadgeNumber = 0
        
        /// 同步js补丁
        JSPatch.sync()
        
        UserServer.instance.loadInterestedMeData()
        
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        
        
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }

    func application(application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: NSData) {
        
        // 向个推注册
        GetuiService.instance.registerDeviceToken(deviceToken)
        EMClient.sharedClient().bindDeviceToken(deviceToken)
    }
    
    func application(app: UIApplication, openURL url: NSURL, options: [String : AnyObject]) -> Bool {
        
        let result = UMSocialSnsService.handleOpenURL(url)
        if !result {
            self.dealPayOption(options, url: url)
        }
        
        return result
    }
    
}

// MARK: - 设置友盟SDK相关
extension AppDelegate {
    func setUpUmengSdk() {
        MobClick.startWithAppkey("", reportPolicy: BATCH, channelId: nil)
        MobClick.setAppVersion(AppInfoService.instance.version)
        
        UMSocialData.setAppKey("")
        UMSocialWechatHandler.setWXAppId("", appSecret: "", url: "http://minbaba.com")
        UMSocialQQHandler.setQQWithAppId("", appKey: "", url: "http://minbaba.com")
        UMSocialData.defaultData().extConfig.wxMessageType = UMSocialWXMessageTypeImage
        UMSocialData.defaultData().extConfig.qqData.qqMessageType = UMSocialQQMessageTypeImage
    }
}

// MARK: - 初始化界面
extension AppDelegate {

    func setUpViewController() {
        
        // 得到当前应用的版本号
        let currentAppVersion = AppInfoService.instance.version
        // 取出之前保存的版本号
        let appVersion = NSUserDefaults.standardUserDefaults().stringForKey("appVersion")
        
        if AppInfoService.instance.isLogin {
            NSNotificationCenter.defaultCenter().postNotificationName(AppInfoService.userLoginSucc, object: nil)
        }
        
        if appVersion == nil || appVersion != currentAppVersion {
            
            // 保存最新的版本号
            NSUserDefaults.standardUserDefaults().setValue(currentAppVersion, forKey: "appVersion")
            self.window?.rootViewController = LoginGuideViewController()
            self.window?.backgroundColor = ColorConf.Text.White.toColor()
        }else{
            
            let vc = UINavigationController(rootViewController: GuideViewController())
            vc.customStyle = true
            vc.hideBar = true
            self.window?.rootViewController = vc
            self.window?.backgroundColor = ColorConf.Text.White.toColor()
           
            if AppInfoService.instance.isLogin {
                let tbBar = MainTabBarController(route: nil)
                window?.rootViewController = tbBar
            }
        }
    }

}

