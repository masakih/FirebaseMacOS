//
//  LogInPanelController.swift
//  FirebaseMacOS
//
//  Created by Hori,Masaki on 2018/07/13.
//  Copyright © 2018年 Hori,Masaki. All rights reserved.
//

import Cocoa
import FirebaseAuth

class LogInPanelController: NSWindowController {
    
    @objc dynamic private var mail: String = ""
    @objc dynamic private var password: String = ""
    
    @objc dynamic private var canLogIn: Bool {
        
//       return isValidMail() && isValidPassword()
        return mail != "" && password != ""
    }
    
    override class func keyPathsForValuesAffectingValue(forKey key: String) -> Set<String> {
        
        switch key {
            
        case #keyPath(canLogIn):
            return [#keyPath(mail), #keyPath(password)]
            
        default:
            return []
        }
    }
    
    override var windowNibName: NSNib.Name {
        
        return NSNib.Name("LogInPanelController")
    }
}

extension LogInPanelController {
    
    @IBAction private func createUser(_: Any) {
        
        guard canLogIn else { fatalError("ここに来るとはなさけない。") }
        
        Auth.auth().createUser(withEmail: mail, password: password) { result, error in
            
            if let error = error as NSError?, let code = AuthErrorCode(rawValue: error.code)  {
                
                switch code {
                    
                case .invalidEmail:
                    print("Mail address is invalid.")
                    
                case .emailAlreadyInUse:
                    print("Mail address is already use.")
                    
                case .operationNotAllowed:
                    print("Operation not allowed")
                    
                case .weakPassword:
                    print("Password is weak.")
                    
                default:
                    print("なんかへん。", error)
                }
                
                return
            }
            
            guard result?.user != nil else {
                
                print("Can not create user.")
                return
            }
            
            print("Success create user.")
        }
    }
}

extension LogInPanelController {
    
    @IBAction private func logIn(_: Any) {
        
        guard canLogIn else { fatalError("ここに来るとはなさけない。") }
        
        Auth.auth().signIn(withEmail: mail, password: password) { result, error in
            
            if let error = error as NSError?, let code = AuthErrorCode(rawValue: error.code) {
                
                switch code {
                    
                case .invalidEmail:
                    print("Mail address is invalid.")
                    
                case .wrongPassword:
                    print("Mail or Password is wrong.")
                    
                case .userNotFound:
                    print("Not registered user.")
                    
                case .userDisabled:
                    print("User account is BAN.")
                    
                default:
                    if let email = result?.user.email {
                        
                        print("log in", email)
                    }
                }
            }
        }
    }
}
