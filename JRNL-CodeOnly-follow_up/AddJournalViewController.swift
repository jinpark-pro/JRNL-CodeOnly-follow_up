//
//  AddJournalViewController.swift
//  JRNL-CodeOnly-follow_up
//
//  Created by Jungjin Park on 2024-05-18.
//

import UIKit

class AddJournalViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "New Entry"
        view.backgroundColor = .white
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(save))
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancel))
    }
    
    @objc func save() {
        
    }
    
    @objc func cancel() {
        dismiss(animated: true)
    }
}
