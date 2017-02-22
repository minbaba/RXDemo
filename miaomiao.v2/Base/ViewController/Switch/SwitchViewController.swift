//
//  SwitchViewController.swift
//  miaomiao.v2
//
//  Created by minbaba on 16/5/12.
//  Copyright © 2016年 MiaoquTech Inc. All rights reserved.
//

import UIKit

class SwitchViewController: BaseViewController {
    
    
    
    @IBOutlet private weak var storeButton: UIButton!
    @IBOutlet private weak var authorityButton: UIButton!
    let pickerHintLayer = CALayer()
    
    @IBOutlet weak var contentScrollView: UIScrollView!
    
    var viewControllers:[UIViewController]! {
        
        didSet {
            setUpControllers()
        }
        
    }
    
    var titles:[String]? {
    
        didSet {
            
            self.storeButton.setTitle(titles?.first, forState: .Normal)
            self.authorityButton.setTitle(titles?.last, forState: .Normal)
            self.storeButton.setTitle(titles?.first, forState: .Selected)
            self.authorityButton.setTitle(titles?.last, forState: .Selected)
        }
    }
    
    var buttons:[UIButton] {
        return[storeButton, authorityButton]
    }
    
    

    final override func viewDidLoad() {
        super.viewDidLoad()
        
        self.automaticallyAdjustsScrollViewInsets = false
        
        pickerHintLayer.frame = CGRectMake(0, 48 + 64, screenWidth / 2, 2)
        pickerHintLayer.backgroundColor = ColorConf.Text.SelectedBlue.toColor().CGColor
        self.view.layer.insertSublayer(pickerHintLayer, atIndex: 0)
    }
    
    
    override func loadView() {
        super.loadView()
        
        NSBundle.mainBundle().loadNibNamed("SwitchViewController", owner: self, options: nil)
    }
}


extension SwitchViewController {
    
    func setUpControllers() {
        let firstView = viewControllers.first!.view
        let secondView = viewControllers.last!.view
        
        contentScrollView.addSubview(firstView)
        contentScrollView.addSubview(secondView)
        
        let height = self.isFirstViewController() ? screenHeight - 163: screenHeight - 114
        firstView.snp_makeConstraints {[weak secondView] (make) in
            make.top.left.bottom.equalTo(0)
            make.right.equalTo(secondView!.snp_left)
            make.size.equalTo(CGSizeMake(screenWidth, height))
        }
        secondView.snp_makeConstraints { (make) in
            make.top.right.bottom.equalTo(0)
            make.size.equalTo(CGSizeMake(screenWidth, height))
        }
        
        bindSwitch()
    }
    
    
    func bindSwitch() {
        
        let tapChange = mqRxBindButton(storeButton, authorityButton)
        tapChange.subscribeNext { [weak self] (tag) in
            
            self?.storeButton.selected = tag == 0
            self?.authorityButton.selected = tag != 0
            self?.pickerHintLayer.position = CGPointMake((tag == 0) ? screenWidth / 4: screenWidth * 3 / 4, 49 + 64)
            }.addDisposableTo(disposeBag)
        tapChange
            .map { CGPointMake(screenWidth * CGFloat($0), 0) }.subscribeNext {[weak contentScrollView] (point) in
                contentScrollView?.setContentOffset(point, animated: true)
            }.addDisposableTo(disposeBag)
        contentScrollView.rx_contentOffset.subscribeNext {[weak self] (point) in
            
            self?.storeButton.selected = point.x < screenWidth / 2
            self?.authorityButton.selected = point.x >= screenWidth / 2
            self?.pickerHintLayer.position = CGPointMake((screenWidth / 4) + (screenWidth * 0.5) * (point.x / screenWidth), 113)
            
            }.addDisposableTo(disposeBag)
    }
    
  }


extension SwitchViewController {
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        viewControllers?.first?.viewWillAppear(animated)
        viewControllers?.last?.viewWillAppear(animated)
    }
    
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        viewControllers?.first?.viewDidAppear(animated)
        viewControllers?.last?.viewDidAppear(animated)
    }
    
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        viewControllers?.first?.viewWillDisappear(animated)
        viewControllers?.last?.viewWillDisappear(animated)
    }
    
    
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
        viewControllers?.first?.viewDidDisappear(animated)
        viewControllers?.last?.viewDidDisappear(animated)
    }
    
}
