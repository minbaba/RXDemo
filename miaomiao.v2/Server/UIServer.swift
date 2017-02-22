//
//  UIServer.swift
//  miaomiao.v2
//
//  Created by minbaba on 16/5/17.
//  Copyright © 2016年 MiaoquTech Inc. All rights reserved.
//

import UIKit


let placeHolderImage = UIImage(named: "刷新_bg_placeholder")



class UIServer {
    
    static let instance = UIServer()
    
    
    private init() {
        
    }
}


extension UIServer {
    func setUpAppearance() {
        
        UITabBarItem.appearance().setTitleTextAttributes([NSForegroundColorAttributeName:ColorConf.Text.SelectedBlue.toColor()], forState: .Selected)
        UITabBarItem.appearance().titlePositionAdjustment = UIOffsetMake(0, -2);
        
        
        let tableView = UITableView.appearance()
        tableView.separatorColor = ColorConf.View.Seprator.toColor()
        tableView.separatorInset = UIEdgeInsetsZero
        tableView.tableFooterView = UIView()
        tableView.backgroundColor = ColorConf.View.BackGround.toColor()
        
        
        let barButtonItem = UIBarButtonItem.appearance()
        if #available(iOS 8.2, *) {
            barButtonItem.setTitleTextAttributes([NSForegroundColorAttributeName:ColorConf.Text.White.toColor(), NSFontAttributeName:UIFont.systemFontOfSize(14, weight: 2)], forState: .Normal)
        } else {
            barButtonItem.setTitleTextAttributes([NSForegroundColorAttributeName:ColorConf.Text.White.toColor(), NSFontAttributeName:UIFont.systemFontOfSize(14)], forState: .Normal)
        }
        barButtonItem.tintColor = ColorConf.Text.White.toColor()
        
        
        let button = UIButton.appearance()
        //        button.setTitleColor(ColorConf.Text.SelectedBlue.toColor(), forState: .Normal)
        button.setTitleColor(ColorConf.Text.SecondTextColor.toColor(), forState: .Disabled)
        //        button.setBackgroundImage(UIImage.colorImage(color: UIColor.whiteColor()), forState: .Normal)
        button.setBackgroundImage(UIImage.colorImage(color: ColorConf.View.Seprator.toColor()), forState: .Disabled)
    }
}
