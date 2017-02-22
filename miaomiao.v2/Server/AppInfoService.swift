//
//  AppInfoService.swift
//  miaomiao.v2
//
//  Created by minbaba on 16/6/2.
//  Copyright © 2016年 MiaoquTech Inc. All rights reserved.
//

import UIKit
import RxSwift
import RealmSwift

class AppInfoService: NSObject {
    
    static var userLoginSucc = "miaoqu_noty_login_success"
    static var userLogoutSucc = "miaoqu_noty_logout_success"

    let disposeBag = DisposeBag()
    
    static let instance = AppInfoService()
    
    static let baseInfoKey = "45ryu230a@n2x302"
    
    static let signKey = "mIo98aiqing"
//    static let signName = "sign_secret_key"
    
    private var infos = [String: String]()
    
    var activity: ActivityInfo?
    var isEnableActivities = 0
    
    
    var currentUserId: Int {
        set {
            NSUserDefaults.standardUserDefaults().setInteger(newValue, forKey: "currentUserId")
        }
        get {
            return NSUserDefaults.standardUserDefaults().integerForKey("currentUserId") ?? 0
        }
    }
    
    /// 是否有登录用户
    var isLogin: Bool { return currentUserId > 0 }
    
    
    var token:String! {
        set {
            NSUserDefaults.standardUserDefaults().setValue(newValue, forKey: "UserTokend")
        }
        get {
            return NSUserDefaults.standardUserDefaults().stringForKey("UserTokend") ?? ""
        }
    }
    
    /// 是否通过审核
    dynamic var verifyed = false
    var rx_isVerifyed: Observable<Bool> {
        return rx_observeWeakly(Bool.self, "verifyed").map { $0 ?? false }.distinctUntilChanged()
    }
    

    private override init() {
    
        // 在(application:didFinishLaunchingWithOptions:)中进行配置
        let config = Realm.Configuration(
            // 设置新的架构版本。这个版本号必须高于之前所用的版本号（如果您之前从未设置过架构版本，那么这个版本号设置为 0）
            schemaVersion: 5,
            
            // 设置闭包，这个闭包将会在打开低于上面所设置版本号的 Realm 数据库的时候被自动调用
            migrationBlock: { migration, oldSchemaVersion in
                // 目前我们还未进行数据迁移，因此 oldSchemaVersion == 0
                if (oldSchemaVersion < 5) {
                    // 什么都不要做！Realm 会自行检测新增和需要移除的属性，然后自动更新硬盘上的数据库架构
                }
        })
        
        // 告诉 Realm 为默认的 Realm 数据库使用这个新的配置对象
        Realm.Configuration.defaultConfiguration = config
    }
    
    func setUp() {
        
        reloadInfo()
        
        NSNotificationCenter.defaultCenter().rx_notification(AppInfoService.userLogoutSucc).subscribeNext {[weak self] (_) in
            
            self?.currentUserId = 0
            let nvc = UINavigationController(rootViewController: LoginViewController())
            nvc.customStyle = true
            (UIApplication.sharedApplication().delegate as! AppDelegate).window?.rootViewController = nvc
            
            ChatService.defaultService.loginOut()
            
        }.addDisposableTo(disposeBag)
    }
    
    func reloadInfo() {
        
        
        let realm = try! Realm()
        for info in realm.objects(AppInfoConfigure.self) { self.infos[info.configKey] = info.configValue }
        
        NetworkServer.rx_mqResponseJSON(.AppInfo, parms: ["appId": "1"]).subscribe({ (event) in
            
            dealNetWorkResult(event, stop: nil, next: { (result) in
                guard let _ = result.0.dictionary?["rows"] else {
                    return
                }
                if let rows = JSON(data: (result.0.dictionary?["rows"]?.string?.stringByRemovingPercentEncoding!.aesCBCDecryptFromBase64(AppInfoService.baseInfoKey)!.dataUsingEncoding(NSUTF8StringEncoding)!)!).arrayObject {
                    
                    var arr = [AppInfoConfigure]()
                    for dict in rows {
                        arr.append(AppInfoConfigure(value: dict))
                    }
                    
                    for info in arr {
                        self.infos[info.configKey] = info.configValue
                    }

                    try! realm.write({
                        realm.add(arr, update: true)
                    })
                }
            })
            
        }).addDisposableTo(disposeBag)
        
    }
    
    var version: String {
        return (NSBundle.mainBundle().infoDictionary?["CFBundleShortVersionString"] ?? "1.0.0") as! String
    }
        
    func getReleseInfo() {
        
        NetworkServer.rx_mqResponseJSON(.AppReleaseInfo, parms: ["appVersion": version, "appTypeId": 1]).subscribe({[weak self] (event) in
            dealNetWorkResult(event, stop: { (error) in
                if let _ = error { HintAlert.hide() }
                }, next: { (result) in
                
                if let dict = JSON(data: result.0["activitiesUrl"].string!.dataUsingEncoding(NSUTF8StringEncoding)!).dictionaryObject {
                    let ac = ActivityInfo()
                    ac.setValuesForKeysWithDictionary(dict)
                    self?.activity = ac
                    self?.isEnableActivities = result.0["isEnableActivities"].int ?? 0
                }
                
                if let isVerifyed = result.0["isVerifyed"].int {
                    self?.verifyed = isVerifyed > 0
                }
                
                if let upgrade = result.0["upgrade"].int {
                    if upgrade > 0 {
                        let ac = UIAlertController(title: "您的版本过低", message: result.0["updateLog"].string, preferredStyle: .Alert)
                        ac.addAction(UIAlertAction(title: "去升级", style: .Default, handler: { (_) in
                            
                            let url = result.0["updateUrl"].string!
                            
                            UIApplication.sharedApplication().openURL(NSURL(string: url)!)
                        }))
                        if let isForceUpgrade = result.0["isForceUpgrade"].int {
                            if isForceUpgrade < 1 {
                                ac.addAction(UIAlertAction(title: "不更新", style: .Default, handler: {[weak ac] (_) in
                                    ac?.dismissViewControllerAnimated(true, completion: nil)
                                }))
                            }
                        }
                        
                        UIApplication.sharedApplication().keyWindow?.rootViewController?.presentViewController(ac, animated: false, completion: nil)
                    }
                }
            })
        }).addDisposableTo(disposeBag)
    }

    class func info(for key: String) -> String {
        if let str = self.instance.infos[key] {
            return str
        } else {
             HintAlert.showText("网络错误，请重试")
                return ""            
        }
    }
    
    class func machine() -> String {
        var systemInfo = utsname()
        uname(&systemInfo)
        return withUnsafePointer(&systemInfo.machine, { (ptr) -> String? in
            let int8Ptr = unsafeBitCast(ptr, UnsafePointer<CChar>.self)
            return String.fromCString(int8Ptr)
        }) ?? ""
    }
    
    func updateLastTime() {
        if self.isLogin {
            
            NetworkServer.rx_mqResponseJSON(.UpdateLastActive, parms: ["userId": self.currentUserId, "appTypeId": 1, "phoneType": AppInfoService.machine(), "lon": 0, "lat": 0, "netWorkType": 0])
        }
    }
}


class AppInfoConfigure: ModelProtocol {
    dynamic var configValue = ""
    dynamic var configKey = ""
    dynamic var type = ""
    
    override static func primaryKey() -> String? {
        return "configKey"
    }
}

class ActivityInfo: NSObject {
    dynamic var recommendToFriendPic = ""
    
    dynamic var dynamicPic = ""
    
    dynamic var seeMePeoplePic = ""
    
    dynamic var dynamic = ""
    
    dynamic var seeMePeople = ""
    
    dynamic var recommendToFriend = ""
    
    dynamic var attentionToMePeople = ""
    
    dynamic var attentionToMePeoplePic = ""

    
    override func setValue(value: AnyObject?, forUndefinedKey key: String) {
        
    }
}
