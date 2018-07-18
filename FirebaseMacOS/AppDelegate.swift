//
//  AppDelegate.swift
//  FirebaseMacOS
//
//  Created by Hori,Masaki on 2018/07/12.
//  Copyright © 2018年 Hori,Masaki. All rights reserved.
//

import Cocoa
import FirebaseCore
import FirebaseAuth

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {
    
    private let mainWindow = MainWindowController()
    
    private let loginPanel = LogInPanelController()
    
    func applicationWillFinishLaunching(_ notification: Notification) {
        
        FirebaseApp.configure()
    }
    
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        
        Auth.auth().addStateDidChangeListener { auth, user in
            
            if user == nil {
                
                self.mainWindow.window?.orderOut(nil)
                self.loginPanel.showWindow(nil)
                
            } else {
                
                self.loginPanel.window?.orderOut(nil)
                self.mainWindow.showWindow(nil)
            }
        }
    }
}

extension AppDelegate {
    
    @IBAction private func signOut(_: Any) {
        
        try? Auth.auth().signOut()
    }
}
