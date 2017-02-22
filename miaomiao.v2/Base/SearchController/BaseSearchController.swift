//
//  BaseSearchController.swift
//  miaomiao.v2
//
//  Created by minbaba on 16/5/6.
//  Copyright © 2016年 MiaoquTech Inc. All rights reserved.
//

import UIKit
import RxSwift

class BaseSearchController: UISearchController {
    
    let statusBarBack = UIView(frame: CGRectMake(0, -20, screenWidth, 20))
    let disposeBag = DisposeBag()
    
    
    let searchButton = UIButton(frame: CGRectMake(0, 64, screenWidth, 49))
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let blurEffect = UIBlurEffect(style: .Light)
        self.view = UIVisualEffectView(effect: blurEffect)
        
        searchButton.setTitleColor(ColorConf.Text.FirstTextColor.toColor(), forState: .Normal)
        searchButton.titleLabel?.font = FontSizeConf.Second.toFont()
        searchButton.contentHorizontalAlignment = .Left
        searchButton.imageEdgeInsets = UIEdgeInsetsMake(0, 12, 0, 0)
        searchButton.titleEdgeInsets = UIEdgeInsetsMake(0, 22, 0, 0)
        searchButton.setImage(UIImage(named: "消息_icon_搜索"), forState: .Normal)
        searchButton.backgroundColor = UIColor.whiteColor()
        let sepLayer = CALayer()
        sepLayer.frame = CGRectMake(12, 48, screenWidth - 24, 1)
        searchButton.layer.addSublayer(sepLayer)
        
        
        
        view.addSubview(searchButton)
        searchButton.hidden = true
        
        
        searchBar.rx_text.distinctUntilChanged().filter({ $0.characters.count > 0 }).subscribeNext {[weak self] (str) in
            
            self?.searchButton.setTitle("搜索:" + str, forState: .Normal)
            self?.searchButton.hidden = false
            
        }.addDisposableTo(disposeBag)
        
        
        
        Observable.combineLatest(searchBar.rx_text.filter({ $0 == "" }), searchButton.rx_tap, resultSelector: { _,_ in true }).bindTo(searchButton.rx_hidden).addDisposableTo(disposeBag)
        
        
        
    }
    
    

    override init(searchResultsController: UIViewController?) {
        
        super.init(searchResultsController: searchResultsController)
        
        self.searchBar.backgroundColor = UIColor.whiteColor()
        
        
        searchBar.addSubview(statusBarBack)
        
        statusBarBack.backgroundColor = ColorConf.View.NavigationBar.toColor()
        
        self.rx_delegate.observe(#selector(UISearchControllerDelegate.willPresentSearchController(_:))).subscribe {[weak self] (event) in
            
            self?.statusBarBack.hidden = false
            self?.searchBar.backgroundColor = ColorConf.View.NavigationBar.toColor()
            
            }.addDisposableTo(disposeBag)
        
        
        self.rx_delegate.observe(#selector(UISearchControllerDelegate.willDismissSearchController(_:))).subscribe {[weak self] (event) in
            
            self?.statusBarBack.hidden = true
            self?.searchBar.backgroundColor = UIColor.whiteColor()
            
            }.addDisposableTo(disposeBag)
        
        
        
        for view in searchBar.subviews[0].subviews {
            if view .isKindOfClass(NSClassFromString("UISearchBarBackground")!) {
                view.removeFromSuperview()
            }
            
            if view .isKindOfClass(NSClassFromString("UISearchBarTextField")!) {
                
                let field = view as! UITextField
                field.mq_setCornerRadius(14)
                field.backgroundColor = ColorConf.View.Seprator.toColor()
                field.tintColor = ColorConf.Text.White.toColor()
            }
            
        }
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    

}
