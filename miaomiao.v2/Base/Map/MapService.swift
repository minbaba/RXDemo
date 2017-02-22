//
//  MapService.swift
//  miaomiao.v2
//
//  Created by minbaba on 16/4/27.
//  Copyright © 2016年 MiaoquTech Inc. All rights reserved.
//

import UIKit
import RxSwift

class MapService {
    
    static var instance = MapService()
    

    let x_pi = 3.14159265358979324 //* 3000.0 / 180.0
    
    
    func toBd09(lat: Double, lon: Double) -> (Double, Double) {
        
        let z = sqrt( lat * lat + lon * lon ) + 0.00002 * sin(lat * x_pi)
        let theta = atan2(lat, lon) + 0.000003 * cos(lon * x_pi)
        return (z * sin(theta) + 0.006, z * cos(theta) + 0.0065)
    }
    
    func toGcj02(lat: Double, lon: Double) -> (Double, Double) {
        
        let x = lon - 0.0065
        let y = lat - 0.006
        let z = sqrt(x * x + y * y) - 0.00002 * sin(y * x_pi)
        let theta = atan2(y, x) - 0.000003 * cos(x * x_pi)
        
        return (z * sin(theta), z * cos(theta))
    }
    
    
}
