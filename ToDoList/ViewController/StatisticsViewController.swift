//
//  StatisticsViewController.swift
//  ToDoList
//
//  Created by Daniel Łachacz on 29/07/2020.
//  Copyright © 2020 Daniel Łachacz. All rights reserved.
//

import UIKit
import CoreData

class StatisticsViewController: UIViewController {
    
    @IBOutlet weak var activeLabel: UILabel!
    @IBOutlet weak var completedLabel: UILabel!
    let dataController = DataController()
    var fetchController: NSFetchedResultsController<Task>?
    
    override func viewDidLoad() {
        super.viewDidLoad()

       dataController.initializeStack()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        setPercents()
    }
    
    private func setPercents() {
        let all = try? self.dataController.fetchTasks()
        
        if all == nil || (all?.count == 0) {
             activeLabel.text = "0%"
        } else {
            let activeList = try? self.dataController.fetchActiveTasks()
            let activePercent = 100.0 * Float(activeList!.count ?? 0) / Float(all!.count ?? 0)
            let completedList = try? self.dataController.fetchCompletedTasks()
            let completedPercent = 100.0 * Float(completedList!.count ?? 0) / Float(all!.count ?? 0)
            activeLabel.text = "\(String(format:"%.2f", activePercent))%"
            completedLabel.text = "\(String(format:"%.2f", completedPercent))%"
        }

    }

}
