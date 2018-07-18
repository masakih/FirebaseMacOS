//
//  DatabaseCodable.swift
//  FirebaseMacOS
//
//  Created by Hori,Masaki on 2018/07/15.
//  Copyright © 2018年 Hori,Masaki. All rights reserved.
//

import Foundation
import FirebaseDatabase

protocol DatabaseDecodable {
    
    init(from: DataSnapshot) throws
}

protocol DatabaseEncodable {
    
    func encode() throws -> Any
}

typealias DatabaseCodable = DatabaseEncodable & DatabaseDecodable
