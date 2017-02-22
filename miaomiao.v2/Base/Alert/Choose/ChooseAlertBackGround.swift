//
//  ChooseAlertBackGround.swift
//  miaomiao.v2
//
//  Created by minbaba on 16/7/2.
//  Copyright © 2016年 MiaoquTech Inc. All rights reserved.
//

import UIKit
import RxSwift

class ChooseAlertBackGround: UIView {
    
    
//    let okButton = UIButton(type: .System)
//    let contentView = UIView()
    
    var buttonsClicked: Observable<Int>?
    
    
//    static let width: CGFloat = 280
    
//    override init(frame: CGRect) {
//        super.init(frame: frame)
//        
//        self.addSubview(titleLabel)
//        titleLabel.layer.addSublayer(Factory.seprator(CGRectMake(0, 49.5, frame.width, 0.5)))
//        titleLabel.textAlignment = .Center
//        titleLabel.snp_makeConstraints { (make) in
//            make.top.left.right.equalTo(0)
//            make.height.equalTo(50)
//        }
//        
//        self.addSubview(contentView)
//        contentView.snp_makeConstraints {[weak titleLabel] (make) in
//            make.left.right.equalTo(0)
//            make.top.equalTo(titleLabel!.snp_bottom)
//        }
//        
//        self.addSubview(okButton)
//        okButton.titleLabel?.font = titleLabel.font
//        okButton.setTitleColor(titleLabel.textColor, forState: .Normal)
//        okButton.setTitle("确定", forState: .Normal)
//        okButton.layer.addSublayer(Factory.seprator(CGRectMake(0, 0, frame.width, 0.5)))
//        okButton.snp_makeConstraints {[weak contentView] (make) in
//            make.left.bottom.right.equalTo(0)
//            make.height.equalTo(50)
//            make.top.equalTo(contentView!.snp_bottom)
//        }
        
//        self.backgroundColor = UIColor.whiteColor()
//    }
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    convenience init(view:UIView, title: String? = nil, buttons: [String] = []) {
        
        var height = view.frame.height + 100
        if title == nil { height -= 50 }
        if buttons.count == 0 { height -= 50 }
        
        self.init(frame: CGRectMake(0, 0, view.frame.width, height))
        self.backgroundColor = UIColor.whiteColor()
        
        /**
         *    设置标题 label
         */
        if title?.characters.count > 0 {
            let titleLabel = Factory.firstLabel
            titleLabel.text = title
            titleLabel.layer.addSublayer(Factory.seprator(CGRectMake(0, 49.5, frame.width, 0.5)))
            titleLabel.frame = CGRectMake(0, 0, frame.width, 50)
            titleLabel.textAlignment = .Center
            addSubview(titleLabel)
        }
        
        // 设置定制view
        view.frame.origin = CGPointMake(0, title?.characters.count > 0 ? 50: 0)
        addSubview(view)
        
        /**
         *    设置下方按钮
         */
        guard buttons.count > 0 else {
            return
        }
        var buttonArr = [UIButton]()
        let buttonWidth = frame.width / CGFloat(buttons.count)
        for index in 0..<buttons.count {
            let button = createButton(with: buttons[index], frame: CGRectMake(buttonWidth * CGFloat(index), height - 50, buttonWidth, 50))
            addSubview(button)
            buttonArr.append(button)
        }
        buttonsClicked = mqRxBindButton(buttonArr)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func createButton(with title: String, frame: CGRect) -> UIButton {
        
        let button = UIButton(type: .System)
        button.frame = frame
        button.titleLabel?.font = FontSizeConf.Second.toFont()
        button.setTitleColor(ColorConf.Text.FirstTextColor.toColor(), forState: .Normal)
        button.setTitle(title, forState: .Normal)
        button.layer.addSublayer(Factory.seprator(CGRectMake(0, 0, frame.width, 0.5)))
        
        return button
    }
}
