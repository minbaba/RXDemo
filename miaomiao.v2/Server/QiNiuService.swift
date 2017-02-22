//
//  QiNiuService.swift
//  miaomiao.v2
//
//  Created by minbaba on 16/5/23.
//  Copyright © 2016年 MiaoquTech Inc. All rights reserved.
//

import QiNiuSdk
import RxSwift
import Kingfisher

class QiNiuService {

    static let instance = QiNiuService()
    
    let manager = QNUploadManager()
    
    let disposeBag = DisposeBag()
    
    var resourcePrefix: String! {
        return AppInfoService.info(for: "bucket_url")
    }
    
    
    
    func getKeys(count:Int, type:ImageType = .Moment) -> [String] {
       
        var keys = Array<String>()
        for _ in 0..<count {
            let key = type.rawValue + String(format: "%013ld%06d.jpg", arguments: [Int64(NSDate().timeIntervalSince1970 * 1000), arc4random() % 1000000])
            keys.append(key)
        }
        return keys
    }
    
    
    func upload(images: [UIImage], keys: [String]) -> Observable<Float> {
        
        
        return Observable<Float>.create({[weak self] (observer) -> Disposable in
            
            // 获取 token
            let rx_token = NetworkServer.rx_mqResponseJSON(.ResourceToken).doOnError({ (error) in
                observer.onError(error)
            }).map { $0.0["token"].string }
            let rx_pressImage = self!.zipImages(images, keys: keys)
            Observable.zip(rx_token, rx_pressImage, resultSelector: { ($0, $1) }).subscribeNext({ (element) in
                
                if let token = element.0 {
                    var count = 0
                    for index in 0..<images.count {
                        
                        let image = element.1[index]
                        let key = keys[index]
                        
                        // 上传
                        self?.manager.putData(UIImageJPEGRepresentation(image, 1), key: key, token: token, complete: { (info, key, result) in
                            
                            KingfisherManager.sharedManager.cache.storeImage(image, forKey: key.mq_imgOriginUrl)
                            count += 1
                            if images.count == count {
                                observer.onCompleted()
                            }
                            
                            },
                            option: nil)
                    }
                    if images.count == 0 { observer.onCompleted() }
                }

            }).addDisposableTo(self!.disposeBag)
            
            return AnonymousDisposable {
                
            }
        })
    }
    
    
    func zipImages(images: [UIImage], keys:[String]) -> Observable<[UIImage]> {
        return Observable<[UIImage]>.create { (observer) -> Disposable in
            
            var arr = [UIImage]()
            for index in 0..<images.count {
                
                let key = keys[index]
                
                let type = ImageType(rawValue: key.substringToIndex(key.startIndex.advancedBy(3)))
                
                let image = images[index]
                let function = [ImageType.Moment: image.dynamicImage, .Info: image.headImage, .Market: image.marketImage][type!]
                arr.append(function!())
            }
            observer.onNext(arr)
            observer.onCompleted()
            
            return AnonymousDisposable {
            }
        }
    }

    enum ImageType:String {
        case Moment = "100"
        case Info = "200"
        case Market = "300"
    }
}



