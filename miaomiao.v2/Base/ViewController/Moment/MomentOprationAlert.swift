//
//  MomentOprationAlert.swift
//  miaomiao.v2
//
//  Created by minbaba on 16/7/25.
//  Copyright © 2016年 MiaoquTech Inc. All rights reserved.
//

import UIKit
import RxSwift

class MomentOprationAlert: AlertManager {

    var complete: completeHander?
    let opButton = UIButton(frame: CGRectMake(0, 0, screenWidth - 24, 50))

    convenience init(moment: MomentModel) {
        self.init()
        
        displayView = opButton
        opButton.backgroundColor = UIColor.whiteColor()
        opButton.titleLabel?.font = FontSizeConf.Second.toFont()
        opButton.setTitleColor(ColorConf.Text.FirstTextColor.toColor(), forState: .Normal)
        let selves = moment.userId == UserServer.instance.user.userId
        opButton.setTitle(selves ? "删除": "举报", forState: .Normal)
        opButton.rx_tap.subscribeNext {[weak self] (_) in
            if selves {
                self?.deleteMoment(moment)
            } else {
                self?.reportMoment(moment)
            }
        }.addDisposableTo(disposeBag)
    }
    
    func reportMoment(moment: MomentModel) {
        
        let aView = UITableView(frame: CGRectMake(0, 0, screenWidth - 24, 243), style: .Plain)
        aView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "item")
        aView.rowHeight = 50
        aView.scrollEnabled = false
        Observable.just(["骚扰辱骂","淫秽色情","垃圾广告","血腥暴力","欺诈行为","违法行为"]).bindTo(aView.rx_itemsWithCellIdentifier("item", cellType: UITableViewCell.self)) { (_, element, cell) in
            cell.textLabel?.firstLabel()
            cell.textLabel?.text = element
            }.addDisposableTo(disposeBag)
        
        aView.rx_itemSelected.map { $0.row }.subscribeNext {[weak self] (index) in
            
            NetworkServer.rx_mqResponseJSON(.Report, parms: ["userId":UserServer.instance.user.userId, "informedId": moment.userId ?? 0, "dynamicId": moment.dynamicId ?? 0, "content":"","type": index + 1]).subscribeNext { (result) in
                HintAlert.showText("举报成功，妙喵会尽快处理!")
                self?.complete?()
                }.addDisposableTo(self!.disposeBag)
            
            }.addDisposableTo(disposeBag)
        displayView = aView
    }
    
    func deleteMoment(moment: MomentModel) {
        let label = Factory.firstLabel
        label.textAlignment = .Center
        label.text = "删除后不能恢复"
        label.frame = CGRectMake(0, 0, 240, 80)
        let back = ChooseAlertBackGround(view: label, title: "提示", buttons: ["确定"])
        displayView = back
        back.buttonsClicked?.subscribeNext {[weak self] (_) in
            
            let parms: [String: AnyObject] = ["userId": UserServer.instance.user.userId, "dynamicId": moment.dynamicId]
            NetworkServer.rx_mqResponseJSON(.DeleteDynamic, parms: parms).subscribeNext { (result) in
                self?.complete?()
                }.addDisposableTo(self!.disposeBag)
        }.addDisposableTo(disposeBag)
    }
    
}
