//
//  photoPicker+rxDelegate.swift
//  miaomiao.v2
//
//  Created by minbaba on 16/4/27.
//  Copyright © 2016年 MiaoquTech Inc. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa


func assetToImage(asset: ALAsset) -> UIImage? {
    let representation =  asset.defaultRepresentation()
    let int = Int(Int64(representation.size()))
    let imageBuffer = UnsafeMutablePointer<UInt8>.alloc(Int(representation.size()))
    let bufferSize = representation.getBytes(imageBuffer, fromOffset: Int64(0),
                                             length: int, error: nil)
    let data =  NSData(bytesNoCopy:imageBuffer ,length:bufferSize, freeWhenDone:true)
    return UIImage(data: data)
    
    
    }

extension AJPhotoPickerViewController {

    /**
     Factory method that enables subclasses to implement their own `rx_delegate`.
     
     - returns: Instance of delegate proxy that wraps `delegate`.
     */
    func rx_createDelegateProxy() -> RxPhotoPickerDelegateProxy {
        return RxPhotoPickerDelegateProxy(parentObject: self)
    }
    
    /**
     Reactive wrapper for `delegate`.
     
     For more information take a look at `DelegateProxyType` protocol documentation.
     */
    public var rx_delegate: DelegateProxy {
        return proxyForObject(RxPhotoPickerDelegateProxy.self, self)
    }
    
    
        /// 选择一组照片
    var rx_didSelectedAssets: ControlEvent<[ALAsset]> {
        
        let source = rx_delegate.observe(#selector(AJPhotoPickerProtocol.photoPicker(_:didSelectAssets:)))
            .map { a in
                return a[1] as! [ALAsset]
        }
        return ControlEvent(events: source)
        }
    
        /// 选择一张照片
    var rx_didSelectAsset: ControlEvent<ALAsset> {
        
        let source = rx_delegate.observe(#selector(AJPhotoPickerProtocol.photoPicker(_:didSelectAsset:)))
            .map { a in
                return a[1] as! ALAsset
        }
        
        return ControlEvent(events: source)
    }
    
        /// 取消选择某张照片
    var rx_didDeselectAsset: ControlEvent<ALAsset> {
        
        let source = rx_delegate.observe(#selector(AJPhotoPickerProtocol.photoPicker(_:didDeselectAsset:)))
            .map { a in
                return a[1] as! ALAsset
        }
        
        return ControlEvent(events: source)
    }
    
        /// 点击相机按钮
    var rx_tapCameraAction: ControlEvent<AJPhotoPickerViewController> {
        
        let source = rx_delegate.observe(#selector(AJPhotoPickerProtocol.photoPickerTapCameraAction(_:)))
            .map { a in
                return a[0] as! AJPhotoPickerViewController
        }
        
        return ControlEvent(events: source)
    }
    
        /// 点击取消按钮
    var rx_didCancel: ControlEvent<AJPhotoPickerViewController> {
        
        let source = rx_delegate.observe(#selector(AJPhotoPickerProtocol.photoPickerDidCancel(_:)))
            .map { a in
                return a[0] as! AJPhotoPickerViewController
        }
        
        return ControlEvent(events: source)
    }
    
        /// 选择相册
    var rx_didSelectionFilter: ControlEvent<AJPhotoPickerViewController> {
        
        let source = rx_delegate.observe(#selector(AJPhotoPickerProtocol.photoPickerDidSelectionFilter(_:)))
            .map { a in
                return a[0] as! AJPhotoPickerViewController
        }
        
        return ControlEvent(events: source)
    }
}


class RxPhotoPickerDelegateProxy: DelegateProxy, AJPhotoPickerProtocol, DelegateProxyType {
    
    
    /**
     Typed parent object.
     */
    weak private(set) var picker: AJPhotoPickerViewController?
    
    // MARK: delegate proxy
    
    /**
     For more information take a look at `DelegateProxyType`.
     */
    override class func createProxyForObject(object: AnyObject) -> AnyObject {
        let picker = (object as! AJPhotoPickerViewController)
        
        return castOrFatalError(picker.rx_createDelegateProxy())
    }
    
    /**
     For more information take a look at `DelegateProxyType`.
     */
    class func setCurrentDelegate(delegate: AnyObject?, toObject object: AnyObject) {
        let picker:AJPhotoPickerViewController = castOrFatalError(object)
        picker.delegate = castOptionalOrFatalError(delegate)
    }
    
    /**
     For more information take a look at `DelegateProxyType`.
     */
    class func currentDelegateFor(object: AnyObject) -> AnyObject? {
        let picker:AJPhotoPickerViewController = castOrFatalError(object)
        return picker
    }
}
