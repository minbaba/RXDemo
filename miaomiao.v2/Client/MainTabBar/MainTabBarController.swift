//
//  MainTabBarController.swift
//  miaomiao.v2
//
//  Created by minbaba on 16/4/25.
//  Copyright © 2016年 MiaoquTech Inc. All rights reserved.
//

import UIKit
import RxSwift
import WebKit

class MainTabBarController: UITabBarController {
    
    let disposeBag = DisposeBag()
    
    var routeVc: UIViewController?
    convenience init(route: UIViewController?) {
        self.init()
        routeVc = route
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        let nameArr = ["妙喵", "发现", "单身市场", "消息", "我的"]
          
        let vcArr = [UINavigationController(rootViewController: MiaoViewController()),
                     UINavigationController(rootViewController: ViewController()),
                     UINavigationController(rootViewController: ViewController()),
                     UINavigationController(rootViewController: ViewController()),
                     UINavigationController(rootViewController: ViewController())]
        self.viewControllers = vcArr
        
        for index in 0...4 {
            vcArr[index].title = index == 2 ? nil: nameArr[index]
            vcArr[index].customStyle = true
            vcArr[index].hideBar = true
            
            let item = self.tabBar.items![index]
            item.image = UIImage(named: "tab_bar_" + nameArr[index])?.imageWithRenderingMode(.AlwaysOriginal)
            item.selectedImage = UIImage(named: "tab_bar_sel_" + nameArr[index])?.imageWithRenderingMode(.AlwaysOriginal)
            
            if index != 2 {
                item.setTitleTextAttributes([NSForegroundColorAttributeName: ColorConf.Text.FirstTextColor.toColor()], forState: .Normal)
                item.setTitleTextAttributes([NSForegroundColorAttributeName: ColorConf.Text.SelectedBlue.toColor()], forState: .Selected)
            } else {
                item.setTitleTextAttributes([NSForegroundColorAttributeName: UIColor.clearColor()], forState: .Normal)
                item.setTitleTextAttributes([NSForegroundColorAttributeName: UIColor.clearColor()], forState: .Selected)
            }
        }
        self.selectedIndex = 2
    }

    
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        
        if let route = routeVc {
            routeVc = nil
            (self.viewControllers?[2] as? UINavigationController)?.pushViewController(route, animated: true)
        }
        
        // 判断是否是第一次进入应用
        guard firstApper else {
            return
        }
        firstApper = false
        
        self.getFemalePrivilege()
//        AppInfoService.instance.rx_isVerifyed.subscribeNext {[weak self] (b) in
//            
//            if b && AppInfoService.instance.isEnableActivities > 0 {
//                // 获取活动信息
//                self?.getActivityInfo()
//            }
//            
//        }.addDisposableTo(disposeBag)
        
        
        // 修改 tabbar 分割线
        for view in self.tabBar.subviews {
            if view.isKindOfClass(NSClassFromString("_UITabBarBackgroundView")!) {
                view.hidden = true
                // 添加背景
                let bar = UIView(frame: CGRectMake(0, 0, screenWidth, 49))
                bar.backgroundColor = UIColor.whiteColor()
                bar.tag = 100
                self.tabBar.insertSubview(bar, atIndex: 0)
                // 添加分割线
                let seprator: UIView = UIView(frame: CGRectMake(0, 0, screenWidth, 0.5))
                seprator.backgroundColor = ColorConf.View.Seprator.toColor()
                bar.addSubview(seprator)
            } else if view.isKindOfClass(NSClassFromString("UIImageView")!) {
                view.hidden = true
            }
        }
        
        setUpBadges()
    }

    func setUpBadges() {
        self.tabBar.rx_observeWeakly(UIBarButtonItem.self, "selectedItem").subscribeNext {[weak self] (item) in
            self?.tabBar.selectedItem?.getImageView().clearBadge()
            }.addDisposableTo(disposeBag)
        
        let dict: [Int: [RemoteMessageServer.BadgeType]] = [0: [.MomentMessage, .FriendMoment], 3: [.Chat, .NewFriend, .Market, .System], 4: [.NewFlower]]
        for index in 0..<self.tabBar.items!.count {
            
            
            let item = self.tabBar.items![index]
            
            for view in item.getActualBadgeSuperView().subviews {
                print(view.classForCoder)
            }
            
            item.getImageView().badgeCenterOffset = CGPointMake(-5, 5)
            
            if let type = dict[index] {
                RemoteMessageServer.instance.observer(for: type)?.filter { $0 > 0 }.subscribeNext({[weak self] (count) in
                    if self?.selectedIndex != index {
                        
                        if index == 0 || index == 3 {
                            
                            item.getImageView().showBadgeWithStyle(.Number, value: count, animationType: .None)
                        } else {
                            item.getImageView().showBadge()
                        }
                    }
                    }).addDisposableTo(disposeBag)
            }
        }
        
    }

    
}
