//
//  MomentDetailViewController.swift
//  miaomiao.v2
//
//  Created by minbaba on 16/4/26.
//  Copyright © 2016年 MiaoquTech Inc. All rights reserved.
//

import UIKit
import RxSwift

class MomentDetailViewController: ViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var inputBar: MomentInputBar!
    @IBOutlet weak var inputBottom: NSLayoutConstraint!
    @IBOutlet weak var contentTB: RefreshTableView!
    
    let tbHeader = MomentDetailHeader(frame: CGRectMake(0, 0 , screenWidth, 0))
    var replaiedId: Int?
    
    var viewModel = MomentDetailViewModel()
   
    override func setUpUI() {
        self.automaticallyAdjustsScrollViewInsets = false
        
        inputBar.textInput.placeHolder = "说点什么吧~"
        
        contentTB.registerNib(UINib(nibName: "MomentDetailPrasersCell", bundle: nil), forCellReuseIdentifier: "prasers")
        contentTB.registerNib(UINib(nibName: "MomentDetailCommentCell", bundle: nil), forCellReuseIdentifier: "comment")
        contentTB.rowHeight = UITableViewAutomaticDimension
        contentTB.estimatedRowHeight = 40
        contentTB.delegate = self
        contentTB.dataSource = self
        
        contentTB.rx_refresh.bindNext(viewModel.refreshCommets).addDisposableTo(disposeBag)
        contentTB.rx_loadMore.bindNext(viewModel.loadMoreComments).addDisposableTo(disposeBag)
        viewModel.rx_observeWeakly(Bool.self, "hasMoreComments").map { $0 ?? false }.bindNext(contentTB.setHasMore).addDisposableTo(disposeBag)
        viewModel.rx_requestComplete.map { _ in return }.bindNext(contentTB.endRefresh).addDisposableTo(disposeBag)
    }
   
    override func bindViewModel() {
        KeyBoardService.instance.keyboardChange().subscribeNext {[weak self] (change) in
            UIView.animateWithDuration(change.0, animations: {
                self?.inputBottom.constant = change.1
            })
            self?.view.layoutIfNeeded()
        }.addDisposableTo(disposeBag)
        
        contentTB.rx_delegate.observe(#selector(UIScrollViewDelegate.scrollViewWillBeginDragging(_:))).subscribeNext {[weak self] (_) in
            self?.view.endEditing(true)
        }.addDisposableTo(disposeBag)
        contentTB.rx_itemSelected.subscribeNext {[weak self] (indexPath) in
            
            if self?.viewModel.sectionCount >= 2 && indexPath.section == 0 {
                return
            }
            if self?.viewModel.sectionCount == 1 && self?.viewModel.commentList.count == 0 {
                return
            }
            
            self?.replaiedId = self?.viewModel.commentList[indexPath.row].userId
            self?.inputBar.textInput.becomeFirstResponder()
            self?.inputBar.textInput.placeHolder = "回复" + (self?.viewModel.commentList[indexPath.row].nickname ?? "")
            self?.viewModel.nickName = self?.viewModel.commentList[indexPath.row].nickname ?? ""
            self?.contentTB.deselectRowAtIndexPath(indexPath, animated: true)
        }.addDisposableTo(disposeBag)
        
        tbHeader.commentButton.rx_tap.subscribeNext { [weak self] (_) in
            self?.inputBar.textInput.becomeFirstResponder()
        }.addDisposableTo(disposeBag)
        
        viewModel.rx_observeWeakly( MomentCellLayout.self, "layout").subscribeNext {[weak self] (layout) in
            
            if let _ = layout {
                self?.tbHeader.layout = self?.viewModel.layout
                self?.contentTB.tableHeaderView = self!.tbHeader
                self?.contentTB.reloadData()
            }
        }.addDisposableTo(disposeBag)
        viewModel.rx_observeWeakly( [MomentComment].self, "commentList").subscribeNext {[weak self] _ in
            self?.contentTB.reloadData()
            }.addDisposableTo(disposeBag)
        viewModel.rx_observeWeakly( [MomentPraiser].self, "praiserList").subscribeNext {[weak self] _ in
            self?.contentTB.reloadData()
            }.addDisposableTo(disposeBag)
        
        inputBar.commitButton.rx_tap.subscribeNext {[weak self] (_) in
            
            self?.viewModel.addComment(self!.inputBar.textInput.text, replaiedId: self?.replaiedId)
            self?.replaiedId = nil
            self?.inputBar.textInput.text = ""
            self?.inputBar.textInput.placeHolder = "说点什么吧~"
            self?.inputBar.textInput.resignFirstResponder()
        }.addDisposableTo(disposeBag)
        
        tbHeader.avator.rx_tap.subscribeNext({[weak self] (_) in
            self?.viewModel.showUserInfo(self!.viewModel.layout.moment.userId)
            }).addDisposableTo(disposeBag)
        tbHeader.commentButton.rx_tap.subscribeNext {[weak self] (_) in
            self?.replaiedId = nil
            self?.inputBar.textInput.placeHolder = "说点什么吧~"
            self?.inputBar.textInput.becomeFirstResponder()
        }.addDisposableTo(disposeBag)
        tbHeader.likeButton.rx_tap.subscribeNext {[weak self] (_) in
            self?.viewModel.praiseButtonClicked()
        }.addDisposableTo(disposeBag)
        tbHeader.oprationButton.rx_tap.bindNext(viewModel.momentOpration).addDisposableTo(disposeBag)
    }
    
    
    
    
    
    
}

// MARKT: - 配置
extension MomentDetailViewController {
    
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return viewModel.sectionCount
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.rowCount(section)
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let header = MomentDetailSectionHeader(frame: CGRectMake(0, 0 , screenWidth, 30))
        var parse = false
        
        if section == 0 {
            if viewModel.praiserList.count > 0 {
                parse = true
            }
        }
        header.setImage(UIImage(named: "动态_icon_nor_" + (parse ? "赞": "评论")), forState: .Normal)
        header.setTitle(parse ? "他们觉得很赞": "评论", forState: .Normal)
        
        return header
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        if indexPath.section == 0 {
            if viewModel.praiserList.count > 0 {
                let cell = tableView.dequeueReusableCellWithIdentifier("prasers") as! MomentDetailPrasersCell
                if cell.praiserList == nil {
                    cell.avatorClicked.subscribeNext({[weak self] (userId) in
                        self?.viewModel.showUserInfo(userId)
                    }).addDisposableTo(disposeBag)
                }
                cell.praiserList = viewModel.praiserList.map { $0 }
                cell.selectionStyle = .None
                return cell
            }
        }
        
        let cell = tableView.dequeueReusableCellWithIdentifier("comment") as! MomentDetailCommentCell
        if cell.model == nil {
            cell.avator.rx_tap.map { [weak cell] in cell?.model?.userId ?? 0 }.bindNext(viewModel.showUserInfo).addDisposableTo(disposeBag)
        }
        let comment = viewModel.commentList[indexPath.row]
        cell.model = comment
        
        
        return cell
    }
    
}

