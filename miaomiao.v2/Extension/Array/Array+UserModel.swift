//
//  Array+UserModel.swift
//  miaomiao.v2
//
//  Created by minbaba on 16/4/24.
//  Copyright © 2016年 MiaoquTech Inc. All rights reserved.
//

import Foundation
import RealmSwift

extension Array where Element: UserProtocol {
    
    /**
     是否包含指定userId的元素
     
     - parameter userId: 查找的id
     
     - returns: 包含的元素个数
     */
    func contains(userId:Int) -> Int {
        
        return self.filter { (element) -> Bool in
            return element.userId == userId
            }.count
    }
    
    /**
     删除指定userId的元素
     
     - parameter userId: 要删除的id
     
     - returns:
     */
    mutating func delete(userId:Int) {
        
        self = self.filter({ (element) -> Bool in
            element.userId != userId
        })
    }
    
    /// 未找到
    static var notFound:Array.Index {return -1}
    /**
     根据传入的用户id查找索引
     
     - parameter userId: 查找的id
     
     - returns: 索引，如果不存在，返回notFound
     */
    func indexOf(userId:Int) -> Array.Index {
        
        for index in 0..<self.count {
            if self[index].userId == userId {
                return index
            }
        }
        
        return Array.notFound
    }
}

//extension List where Element: UserProtocol {
//    
//    /**
//     是否包含指定userId的元素
//     
//     - parameter userId: 查找的id
//     
//     - returns: 包含的元素个数
//     */
//    func contains(userId:Int) -> Int {
//        
//        return self.filter { (element) -> Bool in
//            return element.userId == userId
//            }.count
//    }
//    
//    /**
//     删除指定userId的元素
//     
//     - parameter userId: 要删除的id
//     
//     - returns:
//     */
//    mutating func delete(userId:Int) {
//        
//        self = self.filter({ (element) -> Bool in
//            element.userId != userId
//        })
//    }
//    
//    /// 未找到
//    static var notFound:Array.Index {return -1}
//    /**
//     根据传入的用户id查找索引
//     
//     - parameter userId: 查找的id
//     
//     - returns: 索引，如果不存在，返回notFound
//     */
//    func indexOf(userId:Int) -> Array.Index {
//        
//        for index in 0..<self.count {
//            if self[index].userId == userId {
//                return index
//            }
//        }
//        
//        return Array.notFound
//    }
//}
