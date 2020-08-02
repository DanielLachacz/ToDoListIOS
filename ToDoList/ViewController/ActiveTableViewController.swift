//
//  ActiveTableViewController.swift
//  ToDoList
//
//  Created by Daniel Łachacz on 24/07/2020.
//  Copyright © 2020 Daniel Łachacz. All rights reserved.
//

import UIKit
import CoreData

class ActiveTableViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    let dataController = DataController()
    var fetchController: NSFetchedResultsController<Task>?
    var datePicker: UIDatePicker?
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
      //  _ = try? self.dataController.fetchTasks()
        let request = Task.fetchRequest() as NSFetchRequest<Task>
        request.sortDescriptors = [NSSortDescriptor(key: "date", ascending: true)]
        request.predicate = NSPredicate(format: "status = %d", false)
       
        let fetchController = NSFetchedResultsController(fetchRequest: request,
                                                         managedObjectContext: self.dataController.context,
                                                         sectionNameKeyPath: nil, cacheName: nil)
        fetchController.delegate = self
        self.fetchController = fetchController
        try? fetchController.performFetch()
        
        self.tableView.reloadData()
    }
    
}

extension ActiveTableViewController: NSFetchedResultsControllerDelegate {
    
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

extension ActiveTableViewController: UITableViewDataSource {
    
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

extension ActiveTableViewController: UITableViewDelegate {
    
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
        
        let done = UIContextualAction(style: .destructive, title: "Done", handler: { (action, view, completion) in completion(true)
            guard let task = self.fetchController?.object(at: indexPath) else { return }
            try? self.dataController.updateStatusCompleted(task: task)
            self.tableView.reloadData()
            print("Done", task.status)
        })
        done.backgroundColor = .green
        
        let configuration = UISwipeActionsConfiguration(actions: [delete, done])
        configuration.performsFirstActionWithFullSwipe = false
        return configuration
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let taskList = try? dataController.fetchActiveTasks()
        let task = taskList?[indexPath.row]
       performSegue(withIdentifier: "showActiveDetail", sender: task)
}
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? ActiveDetailViewController {
            destination.task = sender as? Task

        }
    }
}
