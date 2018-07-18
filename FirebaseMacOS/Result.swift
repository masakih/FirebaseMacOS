//
//  Result.swift
//  FirebaseMacOS
//
//  Created by Hori,Masaki on 2018/07/15.
//  Copyright © 2018年 Hori,Masaki. All rights reserved.
//


enum Result<Value> {
    
    case value(Value)
    
    case error(Error)
}

extension Result {
    
    init(_ f: () throws -> Value) {
        
        do {
            
            self = .value(try f())
            
        } catch {
            
            self = .error(error)
        }
    }
}

extension Result {
    
    @discardableResult
    func ifValue(_ f: (Value) -> Void) -> Result {
        
        if case let .value(value) = self {
            
            f(value)
        }
        
        return self
    }
    
    @discardableResult
    func ifError(_ f: (Error) -> Void) -> Result {
        
        if case let .error(error) = self {
            
            f(error)
        }
        
        return self
    }
}
