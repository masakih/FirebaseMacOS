//
//  MemoViewController.swift
//  FirebaseMacOS
//
//  Created by Hori,Masaki on 2018/07/14.
//  Copyright © 2018年 Hori,Masaki. All rights reserved.
//

import Cocoa
import FirebaseAuth
import FirebaseDatabase

class MemoViewController: NSViewController {
    
    private var userRef: DatabaseReference?
    private var observations: [DatabaseObservation] = []
    
    private var memos: [Memo] = []
    
    @IBOutlet private var memoTable: NSTableView!

    @objc dynamic private var memo: String = ""
    
    @objc dynamic private var canPost: Bool {
        
        return memo != ""
    }
    
    override class func keyPathsForValuesAffectingValue(forKey key: String) -> Set<String> {
        
        if key == #keyPath(canPost) {
            
            return [#keyPath(memo)]
        }
        
        return []
    }
}

extension MemoViewController: NSTableViewDelegate {
    
    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        
        guard let memoView = tableView.makeView(withIdentifier: MemoCellView.identifier, owner: nil) as? MemoCellView else {
            
            fatalError("Can not get MemoCellView.")
        }
        
        memoView.memo = memos[row]
        
        return memoView
    }
}

extension MemoViewController: NSTableViewDataSource {
    
    func numberOfRows(in tableView: NSTableView) -> Int {
        
        return memos.count
    }
}

extension MemoViewController {
    
    @IBAction private func post(_: Any) {
        
        guard canPost else { fatalError("ここに来るとはなさけない。") }
        
        let newMemo = Memo(dataKey: "", memo: memo, date: Date().timeIntervalSince1970)
        
        userRef?.childByAutoId().setEncodableValue(newMemo)
        
        self.memo = ""
    }
    
    @IBAction private func delete(_: Any) {
        
        let selectedIndex = memoTable.selectedRow
        guard case 0..<memos.count = selectedIndex else { return }
        
        userRef?.child(memos[selectedIndex].dataKey).removeValue()
    }
}

extension MemoViewController {
    
    override func viewWillAppear() {
        
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        userRef = Database.database().reference().child("Users").child(uid)
        
        registerObserver()
    }
    
    override func viewWillDisappear() {
        
        observations = []
        
        userRef = nil
        
        // 表示内容を空に
        memos = []
        memoTable.reloadData()
    }
}

extension MemoViewController {
    
    private func registerObserver() {
        
        guard let ref = userRef else { return }
        
        let binder = QueryObserverBinder(query: ref)
        
        binder.addObserver(.childAdded, type: Memo.self) { result in
            
            result
                .ifValue { memo in
                    
                    let index = self.memos.index { aMemo in aMemo.date < memo.date } ?? self.memos.count
                    let insertIndex = max(index, 0)
                    
                    self.memos.insert(memo, at: insertIndex)
                    self.memoTable.insertRows(at: [insertIndex], withAnimation: .slideDown)
                }
                .ifError { error in print(error) }
        }
        
        binder.addObserver(.childChanged, type: Memo.self) { result in
            
            result
                .ifValue { memo in
                    
                    if let index = self.memos.index(of: memo) {
                        
                        self.memos.remove(at: index)
                        self.memoTable.removeRows(at: [index], withAnimation: .slideUp)
                        
                    } else {
                        
                        print("deletion: memo is not found.")
                    }
                }
                .ifError { error in print(error) }
        }
        
        observations = binder.observations
    }
}
