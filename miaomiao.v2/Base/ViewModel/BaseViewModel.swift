//
//  BaseViewModel.swift
//  miaomiao.v2
//
//  Created by minbaba on 16/4/11.
//  Copyright © 2016年 MiaoquTech Inc. All rights reserved.
//

import RxSwift

class BaseViewModel:NSObject {
    
    dynamic var title: String?
    
    
    var disposeBag = DisposeBag()
    
     /// 跳转到viewCotroller
    let rx_pushViewController = PublishSubject<UIViewController>() 
    
    let rx_present = PublishSubject<UIViewController>()
    
    let rx_pop = PublishSubject<UIViewController?>()
    
    /// 网络加载完成
    let rx_requestComplete = PublishSubject<UrlString>()
    
    func showUserInfo(userId: Int) {
        rx_pushViewController.onNext(UserInfoViewController.vcFor(userId))
//        rx_pushViewController.onNext(UserDetailViewController())
    }

    deinit {
        
        print("-----------------------------> 销毁\(self.classForCoder)")
    }
}
