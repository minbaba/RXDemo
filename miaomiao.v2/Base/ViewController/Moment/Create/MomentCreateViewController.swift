//
//  MomentCreateViewController.swift
//  miaomiao.v2
//
//  Created by minbaba on 16/4/25.
//  Copyright © 2016年 MiaoquTech Inc. All rights reserved.
//

import UIKit
import AssetsLibrary
import QiNiuSdk

class MomentCreateViewController: ViewController, UITableViewDataSource ,UICollectionViewDelegate {
    
    let imageWidth = (screenWidth - 30 - 24) / 4.0
    
    let viewModel = MomentCreateViewModel()

    typealias momentCallback = (MomentModel) -> Void
    var callback: momentCallback!
    
    @IBOutlet var header: UIView!
    @IBOutlet weak var headerTextView: BaseTextView!
    @IBOutlet weak var imageCollection: UICollectionView!
    @IBOutlet weak var listTb: UITableView!
    
    convenience init (callback: momentCallback) {
        self.init()
        self.callback = callback
    }
    
    override func setUpUI() {
        
        self.title = "发布动态"
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "发布", style: .Plain, target: nil, action: nil)
        
        listTb.tableHeaderView = header
        listTb.dataSource = self
        
        headerTextView.placeHolder = "说点什么吧~"
    }
    
    
    override func bindViewModel() {
        
        bindTableView()
        bindCollectionView()
        
        
        self.navigationItem.rightBarButtonItem?.mq_tap.subscribeNext({[weak self] (_) in
            self?.viewModel.text = self!.headerTextView.text
            self?.viewModel.createMoment { moment in
                self?.callback(moment)
                self?.navigationController?.popViewControllerAnimated(true)
            }
            }).addDisposableTo(disposeBag)

    }
    
    
    func bindTableView() {
        viewModel.rx_observeWeakly([String].self, "authList").subscribeNext({[weak self] list in
            self?.listTb.reloadData()
            }).addDisposableTo(disposeBag)
        
        
        listTb.rx_itemSelected.subscribeNext {[weak self] (index) in
            self?.viewModel.itemClicked(index)
            self?.listTb.deselectRowAtIndexPath(index, animated: true)
        }.addDisposableTo(disposeBag)
        
    }
    
    
    func bindCollectionView() {
        
        
        imageCollection.registerClass(UICollectionViewCell.self, forCellWithReuseIdentifier: "item")
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSizeMake(imageWidth, imageWidth)
        imageCollection.setCollectionViewLayout(layout, animated: false)
        
        let rx_imageArr = viewModel.rx_observeWeakly([UIImage].self, "imageArray").map { $0 ?? [] }
        rx_imageArr.subscribeNext {[weak self] list in
            self?.header.frame = CGRectMake(0, 0, screenWidth, 120.5 + (self!.imageWidth + 10 ) * CGFloat((list.count - 1) / 4 + 1) - 10)
            self?.listTb.tableHeaderView = self?.header
            }.addDisposableTo(disposeBag)
        
        
        imageCollection.layer.masksToBounds = false
        rx_imageArr.bindTo(imageCollection.rx_itemsWithCellIdentifier("item", cellType: UICollectionViewCell.self)) {[weak self] (row, element, cell) in
            
            print(element)
            
            var imageView:UIImageView!
            var deleteButton:UIButton!
            
            if let _ = cell.contentView.viewWithTag(imageViewTagBegin) {
                imageView = cell.contentView.viewWithTag(imageViewTagBegin) as! UIImageView
                deleteButton = cell.contentView.viewWithTag(buttonTagBegin) as! UIButton
            }
            
            if imageView == nil {
                imageView = UIImageView(frame: CGRectMake(0, 0, self!.imageWidth, self!.imageWidth))
                imageView?.tag = imageViewTagBegin
                imageView?.contentMode = .ScaleAspectFill
                imageView.layer.masksToBounds = true
                cell.contentView .addSubview(imageView)
                
                deleteButton = UIButton(type: .Custom)
                deleteButton.tag = buttonTagBegin
                deleteButton.frame = CGRectMake(self!.imageWidth - 40, -10, 50, 50)
                deleteButton.contentHorizontalAlignment = .Right
                deleteButton.contentVerticalAlignment = .Top
                deleteButton.setImage(UIImage(named: "动态_icon_删除图片"), forState: .Normal)
                cell.contentView.addSubview(deleteButton)
                
                deleteButton.rx_tap.map { [weak imageView] in imageView!.image! }.bindNext(self!.viewModel.deleteImage).addDisposableTo(self!.disposeBag)
            }
          
            imageView.image = element
              print(imageView.image)
            deleteButton.hidden = (element == self!.viewModel.addMoreImage)
            
            }.addDisposableTo(disposeBag)
        
        imageCollection.rx_itemSelected.bindTo(viewModel.rx_imageBtnClicked).addDisposableTo(disposeBag)
        
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.authList.count
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        var cell = tableView .dequeueReusableCellWithIdentifier("cell")
        if cell == nil {
            cell = UITableViewCell(style: .Value1, reuseIdentifier: "cell")
        }
        
        viewModel.configureCell(&cell!, row: indexPath.row)
        
        return cell!
    }
}
