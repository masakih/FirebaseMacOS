//
//  Memo.swift
//  FirebaseMacOS
//
//  Created by Hori,Masaki on 2018/07/14.
//  Copyright © 2018年 Hori,Masaki. All rights reserved.
//

import Foundation
import FirebaseDatabase

struct Memo {
    
    // realtime database の key
    let dataKey: String
    
    let memo: String
    
    let date: TimeInterval
}

extension Memo: Equatable {
    
    static func == (lhs: Memo, rhs: Memo) -> Bool {
        
        return lhs.dataKey == rhs.dataKey
    }
}

enum MemoCodingError: Error {
    
    case notMemo
    
    case hasNotMemo
    
    case hasNotDate
}

extension Memo: DatabaseCodable {
    
    func encode() throws -> Any {
        
        return ["memo": self.memo, "date": self.date]
    }
    
    init(from snapshot: DataSnapshot) throws {
        
        guard let dict = snapshot.value as? [String: Any] else { throw MemoCodingError.notMemo }
        guard let memo = dict["memo"] as? String else { throw MemoCodingError.hasNotMemo }
        guard let date = dict["date"] as? TimeInterval else { throw MemoCodingError.hasNotDate }
        
        self.dataKey = snapshot.key
        self.memo = memo
        self.date = date
    }
}
