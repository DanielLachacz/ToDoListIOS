//
//  ActiveDetailViewController.swift
//  ToDoList
//
//  Created by Daniel Łachacz on 31/07/2020.
//  Copyright © 2020 Daniel Łachacz. All rights reserved.
//

import UIKit
import CoreData

class ActiveDetailViewController: UIViewController {
    
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var descriptionTextField: UITextField!
    @IBOutlet weak var dateTextField: UITextField!
    @IBOutlet weak var editButton: UIButton!
    
    var task: Task?
    var dataController = DataController()
    var fetchController: NSFetchedResultsController<Task>?
    var datePicker: UIDatePicker?
       lazy var dateFormatter: DateFormatter = {
              let dateFormatter = DateFormatter()
              dateFormatter.dateFormat = "dd.MM.yyyy"
              return dateFormatter
          }()

    override func viewDidLoad() {
        super.viewDidLoad()

        dataController.initializeStack()
        setDatePicker()
        
        titleTextField.text = task?.title
        descriptionTextField.text = task?.text
        dateTextField.text = dateFormatter.string(from: (task?.date)!)
    
    }
    
    private func checkTextFields() {
        if titleTextField.text == "" || descriptionTextField.text == "" || dateTextField.text == "" {
            self.editButton.isEnabled = false
        } else {
            self.editButton.isEnabled = true
        }
    }
    
    @IBAction func tappedEdit(_ sender: Any) {
        if titleTextField.text == "" || descriptionTextField.text == "" || dateTextField.text == "" {
            self.editButton.isEnabled = false
        } else {
            self.editButton.isEnabled = true
            editTask()
        }
    }
    
    
    private func editTask() {
    
        task?.title = titleTextField.text
        task?.text = descriptionTextField.text
        let dateString = dateTextField.text
        task?.date = dateFormatter.date(from: dateString!)
        
        do {
        try dataController.updateTask(task: task!)
            self.presentingViewController?.dismiss(animated: true, completion: nil)
        } catch {
            fatalError("Failure to edit Task \(error) ActiveDetailActivity")
        }
       
    }
    
    func setDatePicker() {
        datePicker = UIDatePicker()
        datePicker?.datePickerMode = .date
        datePicker?.addTarget(self, action: #selector(dateChanged(datePicker:)), for: .valueChanged)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(viewTapped(gestureRecognizer:)))
        
        view.addGestureRecognizer(tapGesture)
        
         dateTextField.inputView = datePicker
    }
    
    @objc func viewTapped(gestureRecognizer: UITapGestureRecognizer) {
        view.endEditing(true)
    }
    
    @objc func dateChanged(datePicker: UIDatePicker) {
        dateTextField.text = dateFormatter.string(from: datePicker.date)
        view.endEditing(true)
    }
    

}
