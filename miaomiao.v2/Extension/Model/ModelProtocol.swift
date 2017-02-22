//
//  ModelProtocol.swift
//  miaomiao.v2
//
//  Created by minbaba on 16/4/11.
//  Copyright © 2016年 MiaoquTech Inc. All rights reserved.
//

import Foundation
import RealmSwift

public typealias MQTimeInterval  = Int64
//
class ModelProtocol: Object, NSCopying {
     
        
    func copyWithZone(zone: NSZone) -> AnyObject {
        let item = self.dynamicType.init()
        item.setValuesForKeysWithDictionary(self.attributeDict)
        
        return item
    }
        
    override func setValue(value: AnyObject?, forUndefinedKey key: String) {
        
    }
    
    override func setValue(value: AnyObject?, forKey key: String) {
        guard let _ = value else {
            return
        }
        
        super.setValue(value, forKey: key)
    }
    
    convenience init(dict: [String: AnyObject]) {
        self.init()
        
        self.setValuesForKeysWithDictionary(dict)
    }
   
}



extension NSObject {
    
    var attributeDict: [String: AnyObject]! {
        
        var dict = [String: AnyObject]()
        
        let mirror = Mirror(reflecting: self)
        for case let (label?, _) in mirror.children {
            
            dict[label] = self.valueForKey(label)
        }
        
        return dict
    }
    
}


//// MARK: - 操作符重载
//infix operator <== {
//    associativity none
//    precedence 130
//}
//
//
//// MARK: 基础类型
//func <==(inout key:String, value:JSON) {
//    
//    if let v = value.rawString() {
//        key = v
//    }
//    
//}
//
//
//func <==(inout key:Int, value:JSON) {
//   
//    if let v = value.rawValue.integerValue {
//        key = v
//    }
//    
//}
//
//
//func <==(inout key:Double, value:JSON) {
//    
//    if let v = value.rawValue.doubleValue {
//        key = v
//    }
//}
//
//
//
//func <==(inout key:Bool, value:JSON) {
//    
//    if let v = value.rawValue.boolValue {
//        key = v
//    }
//}
//
//
//func <==<U:ModelProtocol>(inout key:U, value:JSON) {
//    
//    key = U(dict: value)
//}
//
//func <==(inout key:MQTimeInterval, value:JSON) {
//    
//    if let v = value.rawValue.longLongValue {
//        key = v
//    }
//    
//}
//
//// MARK: 各类数组
//func <==<U:ModelProtocol>(inout key:[U], value:JSON) {
//    
//    if value.type == .Array {
//        
//        for dict in value.array! {
//            key.append(U(dict: dict))
//        }
//    }
//}
//
//func <==(inout key:[String], value:JSON) {
//    
//    if value.type == .Array {
//        
//        for item in value.array! {
//            
//            if let str = item.rawString() {
//                key.append(str)
//            }
//        }
//    }
//}
//
//func <==(inout key:[Double], value:JSON) {
//    
//    if value.type == .Array {
//        
//        for item in value.array! {
//            
//            if let num = item.rawValue.doubleValue {
//                key.append(num)
//            }
//        }
//    }
//}
//
//func <==(inout key:[Int], value:JSON) {
//    
//    if value.type == .Array {
//        
//        for item in value.array! {
//            
//            if let num = item.rawValue.integerValue {
//                key.append(num)
//            }
//        }
//    }
//}
//
//func <==(inout key:[Bool], value:JSON) {
//    
//    if value.type == .Array {
//        
//        for item in value.array! {
//            
//            if let bool = item.rawValue.boolValue {
//                key.append(bool)
//            }
//        }
//    }
//}

