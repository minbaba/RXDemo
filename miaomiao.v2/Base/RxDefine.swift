//
//  RxDefine.swift
//  miaomiao.v2
//
//  Created by minbaba on 16/5/5.
//  Copyright © 2016年 MiaoquTech Inc. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

func mqRxBindButton(elements: UIButton...) -> Observable<Int> {
    
    
    return mqRxBindButton(elements)
}

func mqRxBindButton(elements: [UIButton]) -> Observable<Int> {
    
    return Observable<Int>.create({ (observer) -> Disposable in
        
        var disposableList = Array<Disposable>()
        for index in 0..<elements.count {
            disposableList.append(elements[index].rx_tap.map({ index }).bindTo(observer))
        }
        
        return AnonymousDisposable {
            for dis in disposableList {
                dis.dispose()
            }
        }
        
    })
}

func mqRxJust<T>(arr: [T]) -> Observable<[T]> {
    return Observable.just(arr)
}
