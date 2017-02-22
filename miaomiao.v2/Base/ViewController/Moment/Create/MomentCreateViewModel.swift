//
//  MomentCreateViewModel.swift
//  miaomiao.v2
//
//  Created by minbaba on 16/4/25.
//  Copyright © 2016年 MiaoquTech Inc. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import Kingfisher

class MomentCreateViewModel: BaseViewModel, UITableViewDelegate {

    dynamic var visibleRange = 1
    dynamic var authList = [String]()
    
    var text = "1"
    
    dynamic var imageArray:[UIImage]!
    
    dynamic var assets = [ALAsset]() {
    
        didSet {
            
            var arr = assets.flatMap { assetToImage($0) }
            if assets.count < 6 {
                arr.append(addMoreImage)
            }
            imageArray = arr
        }
        
    }
    
    let addMoreImage = UIImage(named: "动态_icon_添加图片")!
    
    
    let model = MomentModel()
    
    var rx_imageBtnClicked = PublishSubject<NSIndexPath>()
    
    override init () {
        super.init()
        
        title = "发布动态"
        
        imageArray = [addMoreImage]
        
        rx_imageBtnClicked.filter {[weak self] (indexPath) -> Bool in
            self?.imageArray[indexPath.row] == self?.addMoreImage
            
        }.map {[weak self] (indexPath) -> ControlEvent<[ALAsset]> in
            let imagePicker = AJPhotoPickerViewController()
            imagePicker.multipleSelection = true
            imagePicker.assetsFilter = ALAssetsFilter.allPhotos()
            imagePicker.showEmptyGroups = true
            imagePicker.selectionFilter = NSPredicate(block: {[weak self] (obj, bindings) -> Bool in
                if let ass = (obj as? ALAsset) {
                    return self?.assets.filter({ (asset) -> Bool in
                        return (asset.valueForProperty(ALAssetPropertyAssetURL) as! NSURL).URLString == (ass.valueForProperty(ALAssetPropertyAssetURL) as! NSURL).URLString
                    }).count == 0
                }
                return true
                })
            imagePicker.rx_didCancel.subscribeNext({ (vc) in
                vc.dismissViewControllerAnimated(true, completion: nil)
            }).addDisposableTo(self!.disposeBag)
            
            imagePicker.maximumNumberOfSelection = 6 - (self?.assets.count)!
            imagePicker.rx_didSelectedAssets.subscribeNext({[weak imagePicker] (_) in
                
                print(imagePicker!.rx_didSelectedAssets)
                imagePicker?.dismissViewControllerAnimated(true, completion: nil)
            }).addDisposableTo((self?.disposeBag)!)
            self?.rx_present.onNext(imagePicker)
            return imagePicker.rx_didSelectedAssets
        }.concat().subscribeNext {[weak self] (assets) in
            
            
            self?.assets.appendContentsOf(assets)
        }.addDisposableTo(disposeBag)
        
    }
    
    
    func deleteImage(image: UIImage) {
        for index in 0 ..< imageArray.count {
            if imageArray[index] == image {
                self.assets.removeAtIndex(index)
                break
            }
        }
    }
    
    func itemClicked(indexPath: NSIndexPath) {
        
        if indexPath.row == 0 {
            authList = authList.count > 1 ? ["权限"]: ["权限", "全部可见", "仅好友可见"]
            return
        }
        
        visibleRange = indexPath.row
        authList = ["权限"]
    }
    
    func configureCell(inout cell: UITableViewCell, row:Int) {
        cell.textLabel?.text = authList[row]
        cell.textLabel?.textColor = ColorConf.Text.FirstTextColor.toColor()
        cell.textLabel?.font = FontSizeConf.Second.toFont()
        cell.detailTextLabel?.textColor = ColorConf.Text.FirstTextColor.toColor()
        cell.detailTextLabel?.font = FontSizeConf.Second.toFont()
        
        cell.accessoryType = row == visibleRange ? .Checkmark: .None
        
        if row == 0 {
            cell.detailTextLabel?.text = ["全部可见", "仅好友可见"][visibleRange - 1]
        }
    }
    
    
    func createMoment(callback: MomentCreateViewController.momentCallback) {
        
        
        guard self.text.characters.count > 0 else {
            HintAlert.showText("文字内容不能为空")
            return
        }
        
        let images = self.imageArray.filter{ $0 != addMoreImage }
        guard images.count > 0 else {
            HintAlert.showText("请至少添加一张图片")
            return
        }
        
        WaitAlert.instance.show()
        let keys = QiNiuService.instance.getKeys(images.count, type: .Moment)
        
        QiNiuService.instance.upload(images, keys: keys).subscribeCompleted({ [weak self] in
            
            print(keys.joinWithSeparator(","))
           
            let parms:[String: AnyObject] = ["userId": UserServer.currentId, "content": self!.text,
                "images":keys.joinWithSeparator(","), "visibleRange": self!.visibleRange]
            NetworkServer.rx_mqResponseJSON(.AddMoment, parms: parms).subscribe({ (event) in
                dealNetWorkResult(event, stop: { (error) in
                    
                    WaitAlert.instance.hide()
                    }, next: { (result) in
                        if result.0.type == .Dictionary {
                            
                            let moment = MomentModel()
                            moment.setValuesForKeysWithDictionary(parms)
                            moment.setValuesForKeysWithDictionary(UserServer.instance.user.attributeDict)
                            moment.createTime = NSDateFormatter.mqFormatter.stringFromDate(NSDate())
                            moment.dynamicId = result.0.dictionary!["dynamicId"]!.intValue
                            callback(moment)
                        }
                })
            }).addDisposableTo(self!.disposeBag)
            
            
        }).addDisposableTo(disposeBag)
        
        
        
    }
    
    
}
