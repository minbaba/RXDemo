//
//  MomentDetailViewModel.swift
//  miaomiao.v2
//
//  Created by minbaba on 16/5/26.
//  Copyright © 2016年 MiaoquTech Inc. All rights reserved.
//

import RealmSwift
import RxSwift

class MomentDetailViewModel: BaseViewModel {

    //传值block
    var complete: ((MomentModel?) -> Void)?
    
    
    
    dynamic var layout:MomentCellLayout! {
        didSet {
            self.refreshCommets()
            self.getPraise(1)
//            praiserList.appendContentsOf(layout.moment.praiseList)
        }
    }
    dynamic var commentList = [MomentComment]()
    dynamic var praiserList = [MomentPraiser]()
    
    var height = 0.0
    
    var commentPageNo = 1
    dynamic var hasMoreComments = false
    
    // 回复评论的评论所需
    var nickName = ""
    
    private let contentWidth = screenWidth - 76
    
    
    let rx_layoutComment = PublishSubject<Void>()
    
    var sectionCount: Int {
        
        var count = 0
        if praiserList.count > 0 {
            count += 1
        }
        if commentList.count > 0 {
            count += 1
        }
        return count
    }
    
    func rowCount(section: Int) -> Int {
        
        if section == 0 {
            if praiserList.count > 0 {
                return 1
            }
        }
        return commentList.count
    }
    
    
    override init() {
        super.init()
        title = "动态详情"
    }

}

extension MomentDetailViewModel {
    
    
    func getPraise(page: Int) {
        
        NetworkServer.rx_mqResponseJSON(.MomentPraiseList, parms: ["dynamicId": layout!.moment.dynamicId, "pageNo": page]).subscribeNext {[weak self] (result) in
            
            if let map = result.0.dictionary!["rows"]?.arrayObject as? [[String: AnyObject]] {
                
                self?.praiserList = map.map({ (dict) -> MomentPraiser in
                    let parser = MomentPraiser()
                    parser.setValuesForKeysWithDictionary(dict)
                    return parser
                })
            }
            }.addDisposableTo(disposeBag)
        
    }
    
    
    /**
     点赞按钮事件
     */
    func praiseButtonClicked() {
        
        let moment = self.layout.moment
        let parms: [String: AnyObject] = ["dynamicId": moment.dynamicId, "userId": UserServer.instance.user.userId, "dynamicUserId": moment.userId]
        var url = UrlString.AddMomentPraiser
        
        if moment.praised {
            url = .DeleteMomentPraise
        }
        
        addPraise(url, parms: parms, complete: {[weak self] (_) in
            self?.praiserList.removeAll()
            if url == .AddMomentPraiser {
                moment.praised = true
                moment.praiseCount += 1
            } else {
                moment.praised = false
                moment.praiseCount -= 1
            }
            
            self?.complete?(moment)
            self?.layout = MomentCellLayout(moment: moment)
        })
    }
    
    /**
     动态操作
     */
    func momentOpration() {
        let alert = MomentOprationAlert(moment: layout.moment)
        alert.complete = {[weak self] _ in
            self?.complete?(nil)
            alert.hide(true, completed: nil)
            self?.rx_pop.onNext(nil)
        }
        alert.show(true, completed: nil)
    }
    
    /**
     动态操作
     
     - parameter url:      操作的uri
     - parameter parms:    参数列表
     - parameter complete: 操作完成的回调
     */
    func addPraise(url: UrlString, parms: [String: AnyObject], complete: completeHander? = nil) {
        NetworkServer.rx_mqResponseJSON(url, parms: parms).subscribeNext { (element) in
            complete?()
            }.addDisposableTo(disposeBag)
    }
    
    /**
     添加一条评论
     
     - parameter content:    评论的内容
     - parameter replaiedId: 被回复者的id
     */
    func addComment(content:String, replaiedId: Int? = nil) {
        guard content.characters.count > 0 else {
            HintAlert.showText("评论内容不能为空")
            return
        }
        
        var parms: [String: AnyObject] = ["userId": UserServer.instance.user.userId, "content": content, "dynamicId": layout.moment.dynamicId, "dynamicUserId": layout.moment.userId]
        if let id = replaiedId {
            parms["replaiedId"] = id
        }
        
        NetworkServer.rx_mqResponseJSON(.AddMomentComment, parms: parms).subscribeNext {[weak self] (result) in
            
            if let id = result.0["commentId"].int {
                let moment = self!.layout.moment.copy() as! MomentModel
                let comment = MomentComment(value: parms)
                comment.setValuesForKeysWithDictionary(UserServer.instance.user.attributeDict)
                comment.createTime = NSDateFormatter.mqFormatter.stringFromDate(NSDate())
                comment.commentId = id
                if let id = replaiedId {
                    let user = self?.commentList.filter({ $0.userId == id }).first
                    comment.replaiedUserNickname = user?.remarkNickname ?? ""
                }
                
                self?.commentList.append(comment)
                self?.layout.moment = moment
                self?.rx_requestComplete.onNext(.AddMomentComment)
            }
        }.addDisposableTo(disposeBag)
    }
    
    /**
     刷新评论列表
     
     - parameter complete: 刷新完成的回调
     */
    func refreshCommets() {
        commentPageNo = 1
        getCommentList(commentPageNo, lastId: 0)
    }
    /**
     加载更多评论
     
     - parameter complete: 加载完成的回调
     */
    func loadMoreComments() {
        commentPageNo += 1
        getCommentList(commentPageNo, lastId: self.commentList.last?.commentId ?? 0)
    }
    
    /**
     请求一页评论
     
     - parameter page:     页码
     - parameter lastId:   当前最后一条评论的id
     - parameter complete: 请求完成的回调
     */
    func getCommentList(page: Int, lastId: Int) {
        
        NetworkServer.rx_mqResponseJSON(.MomentCommentList, parms: ["dynamicId": layout.moment.dynamicId, "dynamicUserId": layout.moment.userId, "userId": UserServer.instance.user.userId, "pageNo": page, "lastId": lastId])
            .subscribe({[weak self] (event) in
                dealNetWorkResult(event, stop: { (error) in
                        self?.rx_requestComplete.onNext(.MomentCommentList)
                    }, next: { (result) in
                        if let rows = result.0["rows"].arrayObject {
                            if page == 1 { self?.commentList.removeAll() }
                            self?.commentList.appendContentsOf(rows.map { MomentComment(value: $0)})
                        }
                        
                        if let hasMore = result.0["hasMore"].bool {
                            self?.hasMoreComments = hasMore
                        }
                })
            }).addDisposableTo(disposeBag)
    }
    
    
    func getMomentDetail() {
//        NetworkServer.
    }

}
