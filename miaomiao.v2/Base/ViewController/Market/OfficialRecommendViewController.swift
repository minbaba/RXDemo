//
//  OfficialRecommendViewController.swift
//  miaomiao.v2
//
//  Created by minbaba on 16/7/28.
//  Copyright © 2016年 MiaoquTech Inc. All rights reserved.
//

import UIKit

class OfficialRecommendViewController: ViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    let layout = UICollectionViewFlowLayout()
    var contentCollection: RefreshCollectionView!
    
    let viewModel = OfficialRecommendViewModel()
    let picker = AuthorityGenderPicker(frame: CGRectMake(0, 0, screenWidth - 24, 150))
    
    var flag:Int?
    override func setUpUI() {
        
        self.automaticallyAdjustsScrollViewInsets = false
        
        contentCollection = RefreshCollectionView(frame: CGRectZero, collectionViewLayout: layout)
        contentCollection.backgroundColor = ColorConf.View.MarketBack.toColor()
        contentCollection.delegate = self
        contentCollection.dataSource = self
        self.view.addSubview(contentCollection)
        contentCollection.snp_makeConstraints { (make) in
            make.top.left.bottom.right.equalTo(0)
        }
        
        contentCollection.registerNib(UINib(nibName: "MarketAuthorityNominateItem", bundle: nil), forCellWithReuseIdentifier: "nominate")
        contentCollection.registerNib(UINib(nibName: "MarketAuthorityHeader", bundle: nil), forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "header")
        
        layout.itemSize = CGSizeMake(MarketAuthorityNominateItem.itemWidth, MarketAuthorityNominateItem.itemWidth)
        layout.sectionInset = UIEdgeInsetsMake(0, 6, 6, 6)
        layout.minimumLineSpacing = 6
        layout.minimumInteritemSpacing = 0
        
        
    }
    
    override func bindViewModel() {
        
        contentCollection.rx_itemSelected.bindNext(itemSelected).addDisposableTo(disposeBag)

        viewModel.rx_observeWeakly([User].self, "recommendList")
            .map { _ in return }.bindNext(contentCollection.endRefresh).addDisposableTo(disposeBag)
        contentCollection.rx_refresh.bindNext(viewModel.refresh).addDisposableTo(disposeBag)
        contentCollection.rx_loadMore.bindNext(viewModel.loadMore).addDisposableTo(disposeBag)
        viewModel.rx_observeWeakly(Bool.self, "hasMore").map { $0 ?? false }.bindNext(contentCollection.setHasMore).addDisposableTo(disposeBag)
        
        picker.addObserver(self, forKeyPath: "gender", options: NSKeyValueObservingOptions.New, context: nil)
//        picker.rx_observe(Int.self, "gender").map{ $0 ?? 2 }.skip(1).distinctUntilChanged().subscribeNext {[weak self] (gender) in
//            
//            NSUserDefaults.standardUserDefaults().setValue(gender, forKey: "genderKey")
//            self?.flag = self?.viewModel.getGender()
//            if self?.flag == 2{
//                self?.picker.maleSwitch.on = true
//                self?.picker.feMaleSwitch.on = true
//            }else if self?.flag == 1{
//                self?.picker.maleSwitch.on = true
//                self?.picker.feMaleSwitch.on = false
//            }else if self?.flag == 0{
//                self?.picker.maleSwitch.on = false
//                self?.picker.feMaleSwitch.on = true
//            }
//            self?.viewModel.gender = gender
//            self?.viewModel.refresh()
//            }.addDisposableTo(disposeBag)
    }
    
    override func getData() {
        contentCollection.beginRefresh()
    }
    
    func itemSelected(index: NSIndexPath) {
        viewModel.showUserInfo(viewModel.recommendList[index.row].userId)
    }
    
    override func observeValueForKeyPath(keyPath: String?, ofObject object: AnyObject?, change: [String : AnyObject]?, context: UnsafeMutablePointer<Void>) {
        
        picker.maleState = picker.maleSwitch.on
        picker.femaleState = picker.feMaleSwitch.on
        NSUserDefaults.standardUserDefaults().setValue(change?[NSKeyValueChangeNewKey], forKey: "genderKey")
        viewModel.gender = viewModel.getGender()
        viewModel.refresh()
    }
    
    deinit{
        picker.removeObserver(self, forKeyPath: "gender")
    }
    
}

extension OfficialRecommendViewController {
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return viewModel.recommendList.count
        
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("nominate", forIndexPath: indexPath) as! MarketAuthorityNominateItem
        cell.avator.kf_setImageWithURL(viewModel.recommendList[indexPath.row].headPortrait.mqimageUrl(.Small), placeholderImage: placeHolderImage)
        
        return cell
        
    }
    
}
