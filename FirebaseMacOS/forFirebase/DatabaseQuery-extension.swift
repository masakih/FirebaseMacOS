//
//  DatabaseQuery-extension.swift
//  FirebaseMacOS
//
//  Created by Hori,Masaki on 2018/07/16.
//  Copyright © 2018年 Hori,Masaki. All rights reserved.
//

import Foundation
import FirebaseDatabase

extension DatabaseQuery {
    
    func observe<D: DatabaseDecodable>(_ type: DataEventType, type decodable: D.Type, with handler: @escaping (Result<D>) -> Void) -> DatabaseHandle {
        
        return observe(type) { snapshot in
            
            handler(Result({ try decodable.init(from: snapshot) }))
        }
    }
    
    func observeArray<D: DatabaseDecodable>(_ type: DataEventType, type decodable: D.Type, with handler: @escaping (Result<[D]>) -> Void) -> DatabaseHandle {
        
        return observe(type) { snapshot in
            
            let value = Result {
                
                try snapshot
                    .children
                    .compactMap { $0 as? DataSnapshot }
                    .compactMap { try decodable.init(from: $0) }
            }
            
            handler(value)
        }
    }
}

extension DatabaseReference {
    
    func setEncodableValue<E: DatabaseEncodable>(_ value: E, with handler: @escaping ((Error?, DatabaseReference) -> Void) = { _,_ in }) {
        
        do {
            
            setValue(try value.encode(), withCompletionBlock: handler)
            
        } catch {
            
            handler(error, self)
        }
    }
}

