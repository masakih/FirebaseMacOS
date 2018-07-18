//
//  MainWindowController.swift
//  FirebaseMacOS
//
//  Created by Hori,Masaki on 2018/07/13.
//  Copyright © 2018年 Hori,Masaki. All rights reserved.
//

import Cocoa

class MainWindowController: NSWindowController {

    override var windowNibName: NSNib.Name {
        
        return NSNib.Name("MainWindowController")
    }
    
    override func windowDidLoad() {
        
        super.windowDidLoad()
        
        self.contentViewController = MemoViewController()
    }
}
