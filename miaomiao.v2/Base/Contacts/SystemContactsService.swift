//
//  SystemContactsService.swift
//  miaomiao.v2
//
//  Created by minbaba on 16/5/9.
//  Copyright © 2016年 MiaoquTech Inc. All rights reserved.
//

import AddressBook
import RxSwift
import RxCocoa
import RealmSwift

class SystemContactsService {

    static let instance = SystemContactsService()
    private (set) var authrity = ReplaySubject<Bool>.create(bufferSize: 1)
    
    
    private init () {
        refreshAuthority()
    }
    
    func refreshAuthority() {
        let author = ABAddressBookGetAuthorizationStatus()
        if author == .Denied || author == .NotDetermined {
            
            var addressBook: ABAddressBookRef
            if let x = ABAddressBookCreateWithOptions(nil, nil) {
                addressBook = x.takeRetainedValue()
            } else {
                self.authrity.onNext(false)
                return

            }
            
            ABAddressBookRequestAccessWithCompletion(addressBook, { (granted, error) in
                
                self.authrity.onNext(granted)
                
            })
        } else {
            self.authrity.onNext(true)
        }
    }
    
    func addContacts() {
        
        
    }
    
    func getContacts(complete:(Void) -> Void) {
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) {
            
            let realm = try! Realm()
            let add = ABAddressBookCreateWithOptions(nil, nil)
            guard let _ = add else {
//                HintAlert.showText("")
                return
            }
            
            let addressBook = add.takeRetainedValue()
            let sysContacts = ABAddressBookCopyArrayOfAllPeople(addressBook).takeRetainedValue() as NSArray
            var allContacts:Array = [ContactsModel]()
            for contact in sysContacts {
                // 名
                let firstName = ABRecordCopyValue(contact, kABPersonFirstNameProperty)?.takeRetainedValue() as! String? ?? ""
                // 中间名
                let middleName = ABRecordCopyValue(contact, kABPersonMiddleNameProperty)?.takeRetainedValue() as! String? ?? ""
                // 姓
                let lastName = ABRecordCopyValue(contact, kABPersonLastNameProperty)?.takeRetainedValue() as! String? ?? ""
                
                var fullName = lastName + middleName + firstName
                
                let phones = ABRecordCopyValue(contact, kABPersonPhoneProperty).takeRetainedValue()
                for index in 0..<ABMultiValueGetCount(phones) {
                    
                    var phoneNumber =  ABMultiValueCopyValueAtIndex(phones, index).takeRetainedValue() as! String
                    phoneNumber = phoneNumber.stringByReplacingOccurrencesOfString("-", withString: "")
                    phoneNumber = phoneNumber.stringByReplacingOccurrencesOfString(" ", withString: "")
                    phoneNumber = phoneNumber.stringByReplacingOccurrencesOfString("+", withString: "")
                    
                    if (phoneNumber.characters.count == 13) && phoneNumber.hasPrefix("86") {
                        phoneNumber = phoneNumber.substringFromIndex(phoneNumber.startIndex.advancedBy(2))
                    }
                    
                    // 如果没有姓名 用电话号代替
                    fullName = fullName.characters.count == 0 ? phoneNumber: fullName
                    
                    let contact = ContactsModel()
                    contact.name = fullName
                    contact.phone = phoneNumber
                    allContacts.append(contact)
                }
            }
            
            let contactsArr = allContacts.sort { (first, second) -> Bool in
                let name_1 = NSMutableString(string: first.name)
                let name_2 = NSMutableString(string: second.name)
                
                CFStringTransform(name_1 as CFMutableString, nil, kCFStringTransformMandarinLatin, false)
                CFStringTransform(name_1 as CFMutableString, nil, kCFStringTransformStripDiacritics, false)
                CFStringTransform(name_2 as CFMutableString, nil, kCFStringTransformMandarinLatin, false)
                CFStringTransform(name_2 as CFMutableString, nil, kCFStringTransformStripDiacritics, false)
                name_1.stringByReplacingOccurrencesOfString(" ", withString: "")
                name_2.stringByReplacingOccurrencesOfString(" ", withString: "")
                
                return name_1.compare(name_2 as String) == .OrderedAscending
            }
            try! realm.write {
                realm.add(contactsArr, update: true)
            }
            complete()
        }
    }
    
}
