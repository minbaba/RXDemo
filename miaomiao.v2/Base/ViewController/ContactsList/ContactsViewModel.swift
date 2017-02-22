//
//  ContactsViewModel.swift
//  miaomiao.v2
//
//  Created by minbaba on 16/5/9.
//  Copyright © 2016年 MiaoquTech Inc. All rights reserved.
//


import RxSwift
import RealmSwift

class ContactsViewModel: BaseViewModel {



    
    let chars = "ABCDEFGHIJKLMNOPQRSTUVWXYZ#".characters

    var headers = [String]()
    dynamic var friendDict = [String: [User]]() {
    
        didSet {
            
            headers = friendDict.keys.sort({[weak self] (first, second) -> Bool in
                
                return self?.chars.indexOf(first.characters.first!) < self?.chars.indexOf(second.characters.first!)
            })
            
        }
        
    }
    
    
    
    override init() {
        super.init()
        
       
    }
    
    
    func setLists(list: [User]) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), {
            var arr = [(String, User)]()
            for user in list {
                let name = NSMutableString(string: user.remarkNickname)
                CFStringTransform(name as CFMutableString, nil, kCFStringTransformMandarinLatin, false)
                CFStringTransform(name as CFMutableString, nil, kCFStringTransformStripDiacritics, false)
                arr.append(((name as String).uppercaseString, user))
            }
            
            var result = [String: [User]]()
            for char in self.chars {
                
                let subArr = arr.filter({ (element) -> Bool in
                    for ch in element.0.characters {
                        if self.chars.contains(ch) {
                            return ch == char
                        }
                    }
                    return char == "#"
                }).sort({ (first, second) -> Bool in
                    first.0 > second.0
                }).map { $0.1 }
                
                if subArr.count > 0 {
                    result[String.init(char)] = subArr
                }
            }
            
            dispatch_async(dispatch_get_main_queue(), {
                self.friendDict = result
            })
        })
    }
    
    func rowCount(section: Int) -> Int {
        return list(section)?.count ?? 0
    }
    
    func list(section: Int) -> [User]? {
        return friendDict[header(section)]
    }
    
    func header(section: Int) -> String {
        return headers[section]
    }
    
    func item(indexPath: NSIndexPath) -> User {
        return list(indexPath.section)![indexPath.row]
    }
    
    func itemSelecetd(indexPath: NSIndexPath) {
        
        showUserInfo(item(indexPath).userId)
    }
    
}

