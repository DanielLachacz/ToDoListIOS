//
//  AllTableViewViewController.swift
//  ToDoList
//
//  Created by Daniel Łachacz on 28/07/2020.
//  Copyright © 2020 Daniel Łachacz. All rights reserved.
//

import UIKit
import CoreData

class AllTableViewViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    let dataController = DataController()
       var fetchController: NSFetchedResultsController<Task>?
       lazy var dateFormatter: DateFormatter = {
              let dateFormatter = DateFormatter()
              dateFormatter.dateFormat = "dd.MM.yyyy"
              return dateFormatter
          }()
    

    override func viewDidLoad() {
        super.viewDidLoad()

        self.tableView.tableFooterView = UIView()
        self.tableView.dataSource = self
        self.tableView.delegate = self
                             
        dataController.initializeStack()
    
        }
    
    override func viewWillAppear(_ animated: Bool) {
    setList()
    }
        
        private func setList() {
            let request = Task.fetchRequest() as NSFetchRequest<Task>
                   request.sortDescriptors = [NSSortDescriptor(key: "date", ascending: true)]
                  
                   let fetchController = NSFetchedResultsController(fetchRequest: request,
                                                                    managedObjectContext: self.dataController.context,
                                                                    sectionNameKeyPath: nil, cacheName: nil)
                   fetchController.delegate = self
                   self.fetchController = fetchController
                   try? fetchController.performFetch()
            
            self.tableView.reloadData()
        }

}

extension AllTableViewViewController: NSFetchedResultsControllerDelegate {
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>,
                    didChange anyObject: Any, at indexPath: IndexPath?,
                    for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch type {
        case .insert: self.tableView.insertRows(at: [newIndexPath!], with: .automatic)
        case .delete: self.tableView.deleteRows(at: [indexPath!], with: .automatic)
        case .update: self.tableView.reloadRows(at: [indexPath!], with: .automatic)
        case .move: self.tableView.reloadData()
        @unknown default:
            print("Controller Error")
        }
    }
}

extension AllTableViewViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.fetchController?.fetchedObjects?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCell(withIdentifier: MainCell.identifier, for: indexPath) as! MainCell
        guard let task = self.fetchController?.object(at: indexPath) else { return cell }
        
        cell.selectionStyle = .none
        cell.dateLabel?.text = dateFormatter.string(from: task.date!)
        cell.titleLabel?.text = task.title!
        cell.descriptionLabel?.text = task.text!
        
        return cell
    }
}

extension AllTableViewViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }

func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let delete = UIContextualAction(style: .destructive, title: "Delete", handler: { (action, view, completion) in completion(true)
            guard let task = self.fetchController?.object(at: indexPath) else { return }
            try? self.dataController.delete(task: task)
            print("Delete")
        })
        delete.backgroundColor = .red
        
        let configuration = UISwipeActionsConfiguration(actions: [delete])
        configuration.performsFirstActionWithFullSwipe = false
        return configuration
    }
}


