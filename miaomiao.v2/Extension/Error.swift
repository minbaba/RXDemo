//
//  Error.swift
//  miaomiao.v2
//
//  Created by minbaba on 16/4/28.
//  Copyright © 2016年 MiaoquTech Inc. All rights reserved.
//

import Foundation
import RxCocoa

#if !RX_NO_MODULE
    
    @noreturn func rxFatalError(lastMessage: String) {
        // The temptation to comment this line is great, but please don't, it's for your own good. The choice is yours.
        fatalError(lastMessage)
    }
    
#endif

// MARK: Abstract methods

@noreturn func rxAbstractMethodWithMessage(message: String) {
    rxFatalError(message)
}

@noreturn func rxAbstractMethod() {
    rxFatalError("Abstract method")
}

// MARK: casts or fatal error

// workaround for Swift compiler bug, cheers compiler team :)
func castOptionalOrFatalError<T>(value: AnyObject?) -> T? {
    if value == nil {
        return nil
    }
    let v: T = castOrFatalError(value)
    return v
}

func castOrThrow<T>(resultType: T.Type, _ object: AnyObject) throws -> T {
    guard let returnValue = object as? T else {
        throw RxCocoaError.CastingError(object: object, targetType: resultType)
    }
    
    return returnValue
}

func castOptionalOrThrow<T>(resultType: T.Type, _ object: AnyObject) throws -> T? {
    if NSNull().isEqual(object) {
        return nil
    }
    
    guard let returnValue = object as? T else {
        throw RxCocoaError.CastingError(object: object, targetType: resultType)
    }
    
    return returnValue
}

func castOrFatalError<T>(value: AnyObject!, message: String) -> T {
    let maybeResult: T? = value as? T
    guard let result = maybeResult else {
        rxFatalError(message)
    }
    
    return result
}

func castOrFatalError<T>(value: Any!) -> T {
    let maybeResult: T? = value as? T
    guard let result = maybeResult else {
        rxFatalError("Failure converting from \(value) to \(T.self)")
    }
    
    return result
}
