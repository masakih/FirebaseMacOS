//
//  DatabaseValue.swift
//  FirebaseMacOS
//
//  Created by Hori,Masaki on 2018/07/15.
//  Copyright © 2018年 Hori,Masaki. All rights reserved.
//

import Foundation

protocol DatabaseValue {}

extension String: DatabaseValue {}
extension Int: DatabaseValue {}
extension Float: DatabaseValue {}
extension Double: DatabaseValue {}
extension Bool: DatabaseValue {}

extension Array: DatabaseValue where Element: DatabaseValue {}
extension Dictionary: DatabaseValue where Key == String, Value: DatabaseValue {}


public func isDatabaseValue(_ object: Any) -> Bool {
    
    switch object {
        
    case let array as [Any]: return isDatabaseValue(array)
        
    case let dict as [AnyHashable: Any]: return isDatabaseValue(dict)
        
    case _ as DatabaseValue: return true
        
    default: return false
    }
}

private func isDatabaseValue(_ array: [Any]) -> Bool {
    
    return array.first { !isDatabaseValue($0) } == nil
}

private func isDatabaseValue(_ dict: [AnyHashable: Any]) -> Bool {
    
    guard let dict = dict as? [String: Any] else { return false }
    
    return dict.values.first { !isDatabaseValue($0) } == nil
}
