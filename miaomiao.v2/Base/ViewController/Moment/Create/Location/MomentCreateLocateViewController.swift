//
//  MomentCreateLocateViewController.swift
//  miaomiao.v2
//
//  Created by 郑敏 on 16/4/27.
//  Copyright © 2016年 MiaoquTech Inc. All rights reserved.
//

import UIKit
import RxSwift
import SnapKit

class MomentCreateLocateViewController: ViewController, BMKLocationServiceDelegate, BMKPoiSearchDelegate, BMKGeoCodeSearchDelegate, UITextFieldDelegate {
    
    var mapView:BMKMapView?
    let poiSerach = BMKPoiSearch()
    let geoSearch = BMKGeoCodeSearch()
    let locationService = BMKLocationService()
    
    let rx_updateLocation = PublishSubject<CLLocation>()
    
    dynamic var currentSelectedRow = -1
    var poiDataArray:[BMKPoiInfo]? = []
    
    /// 右侧导航栏按钮
    let rightItem = UIBarButtonItem(title: "确定", style: .Plain, target: nil, action: nil)
    
    /// 搜索框
    @IBOutlet weak var searchTextField: UITextField!
    
   
    override func setUpUI() {
        self.title = "选择位置"
        
        MapService.defaultService.rx_Start.distinctUntilChanged().subscribeNext {[weak self] ret in
            
            if ret {
                self!.setUpMapView()
            }
            
        }.addDisposableTo(disposeBag)
        
    }
    
    
    override func bindViewModel() {
        
        rx_updateLocation.subscribeNext {[weak self] location in
            
            let option = BMKReverseGeoCodeOption()
            option.reverseGeoPoint = location.coordinate
            self?.geoSearch.reverseGeoCode(option)
            
        }.addDisposableTo(disposeBag)
        
//        searchTextField.rx
        
    }
    
    func setUpMapView() {
        mapView = BMKMapView()
        self.view.insertSubview(mapView!, atIndex: 0)
        mapView?.snp_makeConstraints(closure: { (make) in
            make.top.left.bottom.right.equalTo(0)
        })
        
        mapView?.userTrackingMode = BMKUserTrackingModeFollow
        mapView?.showsUserLocation = true
        mapView?.zoomLevel = 18
        
        locationService.startUserLocationService()
        locationService.delegate = self
        
        self.geoSearch.delegate = self
    }
    

    
}


extension MomentCreateLocateViewController {
    
    func didUpdateBMKUserLocation(userLocation: BMKUserLocation!) {
        
        rx_updateLocation.onNext(userLocation.location)
        rx_updateLocation.onCompleted()
        
        mapView?.updateLocationData(userLocation)
    }
    
    func onGetReverseGeoCodeResult(searcher: BMKGeoCodeSearch!, result: BMKReverseGeoCodeResult!, errorCode error: BMKSearchErrorCode) {
        
        searchTextField.text = result.address
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        
        textField.resignFirstResponder()
        poiDataArray?.removeAll()
        
        let option = BMKNearbySearchOption()
        option.pageCapacity = 20
        option.location = locationService.userLocation.location.coordinate
        option.radius = 1
        option.keyword = textField.text
        
        poiSerach.poiSearchNearBy(option)
        
        return true
    }
    
    func onGetPoiResult(searcher: BMKPoiSearch!, result poiResult: BMKPoiResult!, errorCode: BMKSearchErrorCode) {
        currentSelectedRow = poiDataArray == nil ? currentSelectedRow: -1
        poiDataArray?.appendContentsOf(poiResult.poiInfoList as! [BMKPoiInfo])
        
    }
    
}