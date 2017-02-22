//
//  MQBaseViewController.swift
//  miaomiao.v2
//
//  Created by minbaba on 16/3/18.
//  Copyright © 2016年 minbaba. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import Kingfisher

let imageViewTagBegin = 300
let labelTagBegin = 500
let buttonTagBegin = 400

// MARK: - 生命周期
class BaseViewController: UIViewController {
    
    var disposeBag = DisposeBag()
    var addLeftReturnItem = true
    var shoudReturn = true
    
  
    override func loadView() {
        
        super.loadView()
        
        let fileName = "\(self.classForCoder)"
        if NSFileManager().fileExistsAtPath(NSBundle.mainBundle().pathForResource(fileName, ofType: ".nib") ?? "") {
            NSBundle.mainBundle().loadNibNamed(fileName, owner: self, options: nil)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
                        /**
         初始化 UI
         */
        setUpUI()
        
        /**
         绑定
         */
        bindViewModel()
        
        /**
         加载数据
         */
        getData()
        
        
        if let model = valueForKey("viewModel") as? BaseViewModel {
            model.rx_pushViewController.observeOn(MainScheduler.instance).observeOn(MainScheduler.instance)
                .subscribeNext {[weak self] (vc) in
                self?.pushViewController(vc)
                }.addDisposableTo(disposeBag)
            
            model.rx_present.observeOn(MainScheduler.instance).observeOn(MainScheduler.instance).subscribeNext {[weak self] (vc) in
                self?.presentViewController(vc)
                }.addDisposableTo(disposeBag)
            
            model.rx_pop.observeOn(MainScheduler.instance).subscribeNext({[weak self] (vc) in
                if let vc = vc {
                    self?.navigationController?.popToViewController(vc, animated: true)
                } else {
                    self?.navigationController?.popViewControllerAnimated(true)
                }
            }).addDisposableTo(disposeBag)
            
            model.rx_observeWeakly(String.self, "title").subscribeNext({[weak self] (title) in
                self?.title = title
                }).addDisposableTo(disposeBag)
        }

        
        // Do any additional setup after loading the view.
    }
    
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        if addLeftReturnItem && (navigationController != nil) && (navigationController?.viewControllers.first != self) {
            addLeftReturnItem = false
            addLeftReturnButon()
        }
        
        MobClick.beginLogPageView("\(classForCoder)")
    }
    
    
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
        
        // 清除内存缓存
        KingfisherManager.sharedManager.cache.clearMemoryCache()
        MobClick.endLogPageView("\(classForCoder)")

    }
    
    
    
    deinit {
        
        print("-----------------------------> 销毁\(self.classForCoder)")
    }
}


// MARK: - 留给子类重写的方法
extension BaseViewController {
    
    /**
     绑定 viewModel 和事件
     */
    func bindViewModel() { }
    
    /**
     初始化UI, 所有UI初始化功能在此实现
     */
    func setUpUI() {}
    
    /**
     加载数据
     */
    func getData() {}
}


// MARK: - 私有方法
extension BaseViewController {
    
    /**
     在 navigationBar 左侧添加返回按钮
     */
    func addLeftReturnButon() {
        let item = UIBarButtonItem(image: UIImage(named: "nav_icon_返回"), style: .Plain, target: nil, action: nil)
        item.mq_tap.filter { [weak self] in self?.shoudReturn ?? false }.subscribeNext {[weak self] _ in
            self?.navigationController?.popViewControllerAnimated(true)
        }.addDisposableTo(disposeBag)
        self.navigationItem.leftBarButtonItem = item
        
        if navigationController?.respondsToSelector(Selector("interactivePopGestureRecognizer")) == true {
            navigationController!.interactivePopGestureRecognizer?.delegate = nil
            navigationController?.interactivePopGestureRecognizer?.enabled = true
        }
    }
    
    /**
     push 到 另外一个BaseViewController
     
     - parameter vc: 将要 push 到的 vc
     */
    func pushViewController(vc:UIViewController) {
        
        if vc.isKindOfClass(UINavigationController.self) {
            presentViewController(vc, animated: true, completion: nil)
        }
        
        if isFirstViewController() {
            vc.hidesBottomBarWhenPushed = true
            navigationController?.pushViewController(vc, animated: true)
            
        } else {
            
            if let nvc = navigationController {
                nvc.pushViewController(vc, animated: true)
            } else {
                presentViewController(vc, animated: true, completion: nil)
            }
        }
    }
    
    /**
     模态显示一个vc
     
     - parameter vc: 模态显示的vc
     */
    func presentViewController(vc: UIViewController) {
        if let _ = tabBarController {
            tabBarController!.presentViewController(vc, animated: true, completion: nil)
        } else if let _ = navigationController {
            navigationController!.presentViewController(vc, animated: true, completion: nil)
        } else {
            presentViewController(vc, animated: true, completion: nil)
        }
    }
    
    /**
     是否是第一个viewController
     
     - returns: 是否
     */
    func isFirstViewController() -> Bool {
        
        if let nvc = self.navigationController {
            
            return nvc.viewControllers.first == self
        }
        return false
    }
    
    
    /**
     绑定文字到label
     
     - parameter source: 源
     - parameter label:  label
     */
    func bindSourceToLabel(source: Observable<String?>, label: UILabel) {
        source
            .subscribeNext { text in
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    label.text = text
                })
            }
            .addDisposableTo(disposeBag)
    }

    
    override func valueForUndefinedKey(key: String) -> AnyObject? {
        return nil
    }
}
