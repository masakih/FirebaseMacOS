//
//  QueryObserverBinder.swift
//  FirebaseMacOS
//
//  Created by Hori,Masaki on 2018/07/16.
//  Copyright © 2018年 Hori,Masaki. All rights reserved.
//

import Foundation
import FirebaseDatabase

private class DatabaseObservation {
    
    private let query: DatabaseQuery
    private let handle: DatabaseHandle
    
    fileprivate init(query: DatabaseQuery, handle: DatabaseHandle) {
        
        self.query = query
        self.handle = handle
    }
    
    deinit {
        
        query.removeObserver(withHandle: handle)
    }
}

class QueryObserverBinder {
    
    private let query: DatabaseQuery
    
    private var observations: [DatabaseObservation] = []
    
    init(query: DatabaseQuery) {
        
        self.query = query
    }
}

extension QueryObserverBinder {
    
    func addObserver<D: DatabaseDecodable>(_ type: DataEventType, type decodable: D.Type, with handler: @escaping (Result<D>) -> Void) {
        
        let h = query.observe(type, type: decodable, with: handler)
        
        observations.append(DatabaseObservation(query: query, handle: h))
    }
    
    func addArrayObserver<D: DatabaseDecodable>(_ type: DataEventType, type decodable: D.Type, with handler: @escaping (Result<[D]>) -> Void) {
        
        let h = query.observeArray(type, type: decodable, with: handler)
        
        observations.append(DatabaseObservation(query: query, handle: h))
    }
}
