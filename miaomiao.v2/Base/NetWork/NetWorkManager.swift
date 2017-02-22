//
//  MQNetWorkManager.swift
//  miaomiao.v2
//
//  Created by minbaba on 16/3/18.
//  Copyright © 2016年 minbaba. All rights reserved.
//

import Foundation
import RxSwift
import Alamofire
import Kingfisher
import QiNiuSdk

enum UrlString:String {
    
    /// 获取热门标签
    case HotTopic = "topic/hot/few"
    
    
    /// 第三方账号注册
    case ThirdRegister = "sso/user/third/party/register"
    /// 第三方登录
    case ThirdLogin = "sso/user/third/party/login"
    /// 资源服务器
    case AppInfo = "sso/app/appconfig/query"
    /// App发布信息
    case AppReleaseInfo = "sso/app/apprelease/query"
    //修改密码
    case ChangPassWord = "sso/user/password/update"
    /// 登录
    case LOGIN = "sso/user/login"
    /// 获取注册短信验证码
    case RegisterAuthCode = "sso/user/captcha/register/apply"
    /// 验证注册短信验证码是否有效
    case CheckRegisterAuchCode = "sso/user/captcha/validate"
    /// 验证注册邀请码
    case CheckInvateCode = "sso/user/inviter/validate"
    /// 注册
    case Register = "sso/user/register"
    /// 获取修改密码短信验证码
    case ReviseAuthCode = "sso/user/captcha/password/apply"
    /// 通过验证码修改密码
    case ForgotPwd = "sso/user/forget/password/update"
    /// 七牛token
    case ResourceToken = "sso/app/qiniu/uploadtoken/get"
    
    /// 获取关心的动态列表
    case InterestDynamicList = "dynamic/v210/list"
    /// 获取推荐的动态列表
    case RecommendDynamicList = "dynamic/recommend/list"
    /// 获取动态详情
    case DynamicDetail = "dynamic/v210/detail"
    /// 动态推送列表
    case DynamicPushList = "dynamic/notification/list"
    /// 首页动态
    case MOMENT = "dynamic/notfriend/list"
    /// 好友圈动态
    case FriendMoment = "dynamic/friend/list"
    /// 获取某人的动态列表
    case UserMoment = "dynamic/v210/user/list"
    /// 添加动态
    case AddMoment = "dynamic/v210/save"
    /// 获取动态评论
    case MomentCommentList = "dynamic/comment/query"
    /// 添加一条动态点赞
    case AddMomentPraiser = "dynamic/praise/save"
    /// 获取动态点赞列表
    case MomentPraiseList = "dynamic/praise/query"
    /// 删除动态点赞
    case DeleteMomentPraise = "dynamic/praise/delete"
    /// 添加一条评论
    case AddMomentComment = "dynamic/comment/save"
     /// 获取动态缩略
    case SampleDynamicInfo = "dynamic/simple"
    
    /// 更新最后活跃时间
    case UpdateLastActive = "uc/userdetail/useraction/log/add"
    /// 修改备注
    case SetRemark = "uc/user/remark/set"
    /// 查询备注列表
    case RemarkList = "uc/user/remark/list"
    /// 举报
    case Report = "uc/userinform/inform/save"
    /// 根据手机号或id查询用户
    case SearchContacts = "uc/userdetail/summary"
    /// 查看他人详情
    case OtherDetail = "uc/userdetail/detail"
    /// 获取共同好友
    case CommonFriend = "uc/userdetail/get/common/friends"

    /// 获取已注册的手机联系人
    case RegisteredContacts = "contacts/match/mobiles/"
    /// 关注的人列表
    case InterestList = "contacts/attention/list"
    /// 来认识我的人列表
    case CognizeMeList = "contacts/acquaintance/list/passivity"
    /// 我去认识的人列表
    case MyCognizeList = "contacts/acquaintance/list/initiative"
    /// 好友列表
    case FriendList = "contacts/list"
    /// 好友申请列表
    case FriendRequestList = "contacts/request/friend"
    
    /// 更新用户签名
    case UpdateSign = "pc/user/V210/signature/update"
    /// 更新用户头像
    case UpdateUserAvator = "pc/user/V210/head/update"
    /// 更新用户相册
    case UpdateUserPhotots = "pc/user/V210/photos/update"
    /// 查询黑名单
    case BlockList = "pc/user/blacklist"
    /// 移除黑名单
    case CancleBlock = "pc/user/blacklist/remove"
    /// 更新用户详情
    case UpdateUserDetail = "pc/user/detail/update"
    /// 用户详情
    case UserDetail = "pc/user/detail"
    /// 用户缩略信息
    case SampleInfo = "pc/user/summary"
    /// 查询零钱明细
    case MoneyDetail = "pc/wallet/list"
    /// 查询会员到期时间
    case VipOverTime = "pc/user/vip/expire"
    /// 获取对我感兴趣的人的统计
    case InterestNote = "pc/user/interest/count"
    /// 看过我的人列表
    case SeeMeList = "pc/user/visitme/list"
    /// 关注我的人列表
    case InterestMeList = "pc/user/attentme/list"
    //提现
    case WithdrawCash = "pc/wallet/cash/apply"
    //提现记录
    case WithdrawRecord = "pc/wallet/cash/apply/list"
    
    
    /// 接受好友请求
    case AcceptFriendRequest = "rs/friendship/accept"
    /// 认识前检测
    case CognizeInfo = "rs/acquaintance/get/check/result"
    /// 中间人列表
    case MiddlemenList = "rs/acquaintance/get/different/group/middlemen"
    
    
    /// 市场请求别人上架某人
    case MarketRequestRecommend = "singlemarket/myfriends/putaway/me/notice"
    /// 市场喜欢某人
    case MarketAddLike = "singlemarket/usertolike/add"
    /// 市场评论
    case AddMarketComment = "singlemarket/comment/submit"
    /// 更新上下架状态
    case UpdateMarketStatus = "singlemarket/shelve/update"
    /// 删除市场的单身狗
    case DeleteGoods = "singlemarket/recommend/delete"
    /// 上架
    case AddGoods = "singlemarket/putaway"
    /// 获取可上架好友列表
    case CanAddList = "singlemarket/putaway/friends/get"
    /// 查询售卖中好友列表
    case ShelveList = "singlemarket/shelve/recommends/get"
    /// 查询下架中好友列表
    case UnshelveList = "singlemarket/unshelve/recommends/get"
    /// 官方推荐列表
    case AuthorityRecommend = "singlemarket/official/recommends/get"
    /// 照片墙形式获取市场列表
    case StoreGoodsList = "singlemarket/secondary/friends/photoswall/get"
    /// 分组形式获取市场列表
    case StoreClassesList = "singlemarket/myfriends/recommends/columnsshow/get"
    /// 被上架人的信息
    case GoodsInfo = "singlemarket/presentee/userinfo/detail/get"
    /// 被上架人点赞信息
    case GoodsLikesInfo = "singlemarket/newuserlikers/get"
    /// 获取市场行情列表
    case MarketInfoList = "singlemarket/quotations/get"
    /// 上架记录
    case GoodsRecommendList = "singlemarket/allrecommends/for/user/get"
    /// 市场详情评价列表
    case MarketCommentList = "singlemarket/comment/findByPage"
    /// 获取某市场主的市场信息
    case MarketDetail = "singlemarket/market/detail/get"
    
    /// 官方红包认识
    case OfficialCognize = "wallet/payment/official/guide"
    /// 官方认识红包价格查询
    case OfficialTipPrice = "wallet/product/official"
    /// 获取提现信息
    case WithdrawInfo = "wallet/cash/condition"
    /// 查询会员价格
    case VipPrice = "wallet/product/vip"
    /// 查询余额
    case BalanceCount = "wallet/account/balance"
    /// 余额支付
    case BalancePay = "wallet/payment/balance/pay"
    /// 支付宝支付
    case AliPay = "wallet/payment/ali/pay"
    /// 微信支付
    case WechatPay = "wallet/payment/wechat/pay"
    /// IAP
    case ApplePay = "wallet/payment/apple/pay"
     /// 支付结果查询
    case PayStatus = "wallet/payment/status"
    /// 拆红包
    case OpenTip = "wallet/redpacket/open"
    
    /// 获取女性特权信息
    case FemaleCognizeChance = "rs/acquaintance/chance"
    /// 清空擦肩而过列表
    case ClearDislikeList = "rs/clear/touch/list"
    /// 解除好友关系
    case RemoveFriend = "rs/friendship/remove,已删除"
    /// 拉黑某人
    case BlockUser = "rs/save/blacklist,已加入拉黑列表"
    /// 取消拉黑
    case UnBlockUser = "rs/remove/blacklis,已移出拉黑列表"
    /// 通讯录批量加好友
    case AddPhoneContacts = "rs/auto/add/contacts/friends"
    /// 手动关注
    case Attention = "rs/set/manual/attention,关注成功"
    /// 取消关注
    case CancleAttention = "rs/remove/attention,取消关注成功"
    /// 添加好友
    case AddFriend = "rs/friend/add,请求已发送"
    /// 小铃铛认识
    case RingCognize = "rs/acquaintance/save/by/product"
    /// 保存认识中间人
    case SaveMiddleman = "rs/acquaintance/save/middlemen"
     //动态删除
    case DeleteDynamic = "dynamic/delete"
    
    /// 分享朋友圈获得抽奖次数
    case AddShareCount = "ad/lottery/sharemoment"
    /// 用户签到
    case AddRegisterCount = "ad/lottery/checkin"
    
    /// 获取遇见的人列表
    case EncounterDisLikeList = "discover/meet/list/touch"
    /// 遇见关注某人
    case EncounterLike = "discover/meet/attention"
    /// 遇见中不喜欢（擦肩而过）
    case EncounterDisLike = "discover/meet/touch"
    /// 获取遇见用户列表
    case EncounterList = "discover/meet/list"
    
    /// 获取系统消息列表
    case AuthorityNotifiList = "notification/systemmessage/for/curlogin/user/get"
    
    /// 带前缀的完整url地址
    var completeMentUrl:String {
        
        if !AppInfoService.instance.verifyed && self == CognizeInfo {
            HintAlert.showText("请求发送成功")
            return ""
        }
        
        if self == .AppInfo {
            return "http://minbaba.com/sso-api/" + self.rawValue
        }
        
        return AppInfoService.info(for: self.rawValue.componentsSeparatedByString("/").first!) + "/" + self.rawValue.componentsSeparatedByString(",").first!
    }
    
    var completHint: String? {
        return self.rawValue.componentsSeparatedByString(",").count >= 2 ? self.rawValue.componentsSeparatedByString(",")[1]: nil
    }
    
}



/**
 处理网络请求的事件
 
 - parameter stop:     事件
 - parameter complete: 结束事件
 - parameter next:     管道元素事件
 */
func dealNetWorkResult<T>(event: RxSwift.Event<T>, stop: ((error: ErrorType?) -> Void)?, next: ((result: T) -> Void)?) {
    
    if event.isStopEvent {
        stop?(error: event.error)
    } else if let result = event.element {
        next?(result: result)
    }
}

// MARK: - 网络层封装
class NetworkServer {
    
    static let instance = NetworkServer()
    let rx_netStatus = PublishSubject<NetworkReachabilityManager.NetworkReachabilityStatus>()
    
    
    var manager: NetworkReachabilityManager?
    private init() {
        
        manager = NetworkReachabilityManager(host: "http://minbaba.com")
        manager?.listener = {status in
            self.rx_netStatus.onNext(status)
        }
        manager?.startListening()
    }
    
    /**
     创建一个可观察的网络请求
     
     - parameter url:   请求的地址
     - parameter parms: 请求的参数
     
     - returns: 可观察的返回数据（返回的json，请求的地址）
     */
    class func rx_mqResponseJSON(url:UrlString, parms:[String:AnyObject]? = nil) -> Observable<(JSON, UrlString)> {
        
        let request = Alamofire.request(.POST, url.completeMentUrl, parameters: parms, encoding: .URL, headers: headers(url.completeMentUrl))
        
        return rx_request(request).map{ ($0, url) }.doOnNext({ result in
            if let hint = url.completHint {
                HintAlert.showText(hint)
            }
        })
    }
    
    
    /**
     上传
     
     - parameter url:         url
     - parameter data:        上传的数据
     - parameter contentType: 类型参数
     - parameter parms:       接口参数
     
     - returns: 可观察的返回数据（返回的json，请求的地址）
     */
    class func rx_upload(url: UrlString, data: NSData, contentType: String = "application/json", parms: [String: AnyObject]? = nil) -> Observable<(JSON, UrlString)> {
        
        var urlStr = url.completeMentUrl
        var header = headers(urlStr)
        
        if url == .RegisteredContacts {
            urlStr += String(parms!["userId"] as! Int)
            header = headers(urlStr)
        } else {
            urlStr = formUrl(urlStr, parms: parms)
            
            
            
        }
        
        header["Content-Type"] = contentType
        
        let request = Alamofire.upload(.POST, urlStr, headers: header, data: data)
//        request.request?.URLRequest.setValue(contentType, forHTTPHeaderField: "Content-Type")
        
        return rx_request(request).map{ ($0, url) }
    }
    
    /**
     生成 get 风格的 url
     
     - parameter url:   原始url
     - parameter parms: 参数列表
     
     - returns: 拼接后的url
     */
    class func formUrl(url: String, parms: [String: AnyObject]?) -> String {
        
        var urlStr = url
        if let parms = parms {
            urlStr += "?"
            for (key, value) in parms {
                urlStr += key.urlEncoding + "=" + "\(value)".urlEncoding + "&"
            }
            urlStr.removeAtIndex(urlStr.startIndex.advancedBy(urlStr.characters.count - 1))
        }
        return urlStr
    }
    
    /**
     生成请求鉴权头的内容
     
     - parameter url: 请求的url
     
     - returns: 鉴权头内容
     */
    class func headers(url: String) -> [String: String] {
        
        // 获取 uri
        var arr = url.stringByReplacingOccurrencesOfString("http://", withString: "").componentsSeparatedByString("/")
        arr.removeAtIndex(0)
        let uri = "/" + arr.joinWithSeparator("/")
        
        return ["token": AppInfoService.instance.token.aesCBCEncrypt(AppInfoService.info(for: "token_secret_key"))?.base64String.urlEncoding ?? "", "userId": "\(AppInfoService.instance.currentUserId)", "sign": (uri + AppInfoService.instance.token + AppInfoService.signKey).md5Str.lowercaseString.base64Str, "x": "\(Int64(NSDate().timeIntervalSince1970))000".aesCBCEncrypt(AppInfoService.baseInfoKey)?.base64String.urlEncoding ?? ""]
    }
    
    /**
     对请求进行响应式封装
     
     - parameter request: 请求
     
     - returns: 响应式的返回
     */
    private class func rx_request(request:Alamofire.Request) -> Observable<JSON> {
        return Observable<(JSON)>.create({ observer -> Disposable in
        
           request.responseString(completionHandler: { response in
                
                if response.result.isSuccess {
                    
                    if let jsonData = response.data {
                        
                        // 进行错误代码的解析
                        do {
                            print("\n\n>>>>>>>>>>\n" + (request.request?.URL?.absoluteString)! + " >>>>>>>>>>\n")
                            let obj = try resultCodeParse(jsonData)
                            observer.onNext((obj))
                            observer.onCompleted()
                        } catch {
                            observer.onError(error)
                        }
                        
                    }
                    
                } else {
                    print(response.result.error)
                    let code = response.result.error?.code
                    if code == -1001 {
                        HintAlert.showText("请求超时!")
                    } else if code != -999 {
                        HintAlert.showText("网络似乎有问题哦!")
                    }
//                    if request.request?.URLString.characters.count > 0 {
//                                          }
                    observer.onCompleted()
                }
            })
            
            return AnonymousDisposable {
                request.cancel()
            }
        }).shareReplay(1)
    }
    
    
    
    
    
    /**
     对返回的数据中的code 和 messege 进行剥离
     
     - parameter data: 服务器返回的数据
     
     - throws: 如果返回的是错误代码，将其包装成 error 并抛出
     
     - returns: 剥离后的数据
     */
    class func resultCodeParse(data:NSData) throws -> JSON {
        
        let json = JSON(data: data)
        print(String(data: data, encoding: NSUTF8StringEncoding))
        
        guard !json["success"].boolValue else {
            return json["resultMap"]
        }
        
        
        // 鉴权失败 退出登录
        if json["code"].string == "C00995" {
            
            if AppInfoService.instance.isLogin {
                NSNotificationCenter.defaultCenter().postNotificationName(AppInfoService.userLogoutSucc, object: nil)
            }
        } else {
            HintAlert.showText(json["description"].string ?? "")
        }
        
        throw NSError(domain: "com.miaoqu.server", code: 0, userInfo: json.dictionaryObject)
    }
    
}



// MARK: - 扩展 String 添加图片地址相关方法
extension String {
    
    enum SizeType: String {
        case Smallest = "smallest"
        case Small = "small"
        case Normal = "normal"
        case Big = "big"
        case Biggest = "biggest"
        case Origin = ""
    }
    
    func mqimageUrl(size: SizeType) -> NSURL {
        return NSURL(string: imageUrl(size.rawValue)) ?? NSURL()
    }
    
    
    var mq_imgOriginUrl:String {
        
        return QiNiuService.instance.resourcePrefix + "/" + self
    }
    
    
    
    func imageUrl(prefix:String) -> String {
        
        // 如果是本地图片 直接返回源地址
        if self =~ "^file://" {
            return self
        }
    
        func makeUrl(subfix: String) -> String {
            var ret = self.mq_imgOriginUrl
            if subfix.characters.count > 0 {
                ret += "-" + subfix
            }
            
            return ret
        }
        
//        for subfix in ["","biggest","big","normal","small","smallest"] {
//            
//            let url = makeUrl(subfix)
//            
//            if subfix == prefix {
//                return url
//            }
//            if KingfisherManager.sharedManager.cache.cachedImageExistsforURL(NSURL(string: url)!) {
//                return url
//            }
//        }
        
        return makeUrl(prefix)
    }
    
    
    
//    func toUrl() -> NSURL {
//        return NSURL(string: self)!
//    }
    
}


