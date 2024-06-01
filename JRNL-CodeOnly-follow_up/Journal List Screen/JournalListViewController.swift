//
//  ViewController.swift
//  JRNL-CodeOnly-follow_up
//
//  Created by Jungjin Park on 2024-05-18.
//

import UIKit

class JournalListViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, AddJournalControllerDelegate {
    
    lazy var tableView: UITableView = {
        let tableView = UITableView()
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(JournalListTableViewCell.self, forCellReuseIdentifier: "journalCell")
        
        view.backgroundColor = .white
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        let global = view.safeAreaLayoutGuide
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: global.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: global.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: global.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: global.bottomAnchor)
        ])
        
        navigationItem.title = "Journal"
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addJournal))
    }
    
    // MARK: UITableViewDataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        SharedData.shared.numberOfJournalEntries()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "journalCell", for: indexPath) as! JournalListTableViewCell
        
        let journalEntry = SharedData.shared.getJournalEntry(index: indexPath.row)
        cell.configureCell(journalEntry: journalEntry)
        
        return cell
    }

    // MARK: - UITableViewDelegate
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let journalEntry = SharedData.shared.getJournalEntry(index: indexPath.row)
        let journalDetailTableViewController = JournalDetailTableViewController(journalEntry: journalEntry)
        show(journalDetailTableViewController, sender: self)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            SharedData.shared.removeJournalEntry(index: indexPath.row)
            tableView.reloadData()
        }
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        90
    }
    
    // MARK: Methods
    @objc func addJournal() {
        let addJournalViewController = AddJournalViewController()
        let navController = UINavigationController(rootViewController: addJournalViewController)
        
        addJournalViewController.delegate = self
        present(navController, animated: true)
    }
    
    func saveJournalEntry(_ journalEntry: JournalEntry) {
        SharedData.shared.addJournalEntry(newJournalEntry: journalEntry)
        tableView.reloadData()
    }
}

