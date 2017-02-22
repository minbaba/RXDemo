//
//  ContactsViewController.swift
//  miaomiao.v2
//
//  Created by minbaba on 16/5/5.
//  Copyright © 2016年 MiaoquTech Inc. All rights reserved.
//

import UIKit

class ContactsViewController: ViewController, UITableViewDataSource, UITableViewDelegate {
    
    var viewModel: ContactsViewModel!
    
    
    
    let contentTb: UITableView = UITableView(frame: CGRectZero)
    
    
    convenience init(viewModel: ContactsViewModel) {
        self.init()
        self.viewModel = viewModel
    }
    
    override func setUpUI() {
        
        self.view.addSubview(contentTb)
        contentTb.snp_updateConstraints { (make) in
            make.top.left.bottom.right.equalTo(0)
        }
        
        self.automaticallyAdjustsScrollViewInsets = false
        contentTb.delegate = self
        contentTb.dataSource = self
        contentTb.rowHeight = 56
        contentTb.sectionHeaderHeight = 15
        contentTb.registerNib(UINib(nibName: "MessageContactsCell", bundle: nil), forCellReuseIdentifier: "item")
        
        
    }
    
    override func bindViewModel() {
        
        viewModel.rx_observeWeakly([String: [User]].self, "friendDict").subscribeNext {[weak self] (list) in
            self?.contentTb.reloadData()
            }.addDisposableTo(disposeBag)
        contentTb.rx_itemSelected.bindNext(viewModel.itemSelecetd).addDisposableTo(disposeBag)
    }
}

extension ContactsViewController {

    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return viewModel.friendDict.count
    }
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.rowCount(section)
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("item") as! MessageContactsCell
        let item = viewModel.item(indexPath)
        
        cell.avator?.kf_setImageWithURL(item.headPortrait.mqimageUrl(.Normal), placeholderImage: placeHolderImage)
        cell.nameLabel.text = item.remarkNickname
        
        return cell
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let label = UILabel()
        label.backgroundColor = ColorConf.View.MarketBack.toColor()
        label.frame = CGRectMake(0, 0, screenWidth, 15)
        label.font = FontSizeConf.Second.toFont()
        label.textColor = ColorConf.Text.FirstTextColor.toColor()
        label.text = "   " + viewModel.header(section)
        
        return label
    }
    
    override func getData() {
        UserServer.instance.reloadFriendList()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        contentTb.reloadData()
    }
}
