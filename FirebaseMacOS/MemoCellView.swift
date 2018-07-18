//
//  MemoCellView.swift
//  FirebaseMacOS
//
//  Created by Hori,Masaki on 2018/07/14.
//  Copyright © 2018年 Hori,Masaki. All rights reserved.
//

import Cocoa

class MemoCellView: NSTableCellView {

    @IBOutlet private var memoField: NSTextField!
    
    var memo: Memo? {
        
        didSet {
            
            textField?.objectValue = memo.map { Date(timeIntervalSince1970: $0.date) }
            
            memoField.stringValue = memo?.memo ?? ""
        }
    }
    
    static var identifier: NSUserInterfaceItemIdentifier {
        
        return NSUserInterfaceItemIdentifier("memo")
    }
    
    override var backgroundStyle: NSView.BackgroundStyle {
        
        didSet {
            
            switch backgroundStyle {
                
            case .dark:
                memoField.textColor = .white
                
            case .light, .raised, .lowered:
                memoField.textColor = .controlTextColor
            }
        }
    }
}
