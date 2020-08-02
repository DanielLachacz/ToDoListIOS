//
//  AddTaskViewController.swift
//  ToDoList
//
//  Created by Daniel Łachacz on 13/07/2020.
//  Copyright © 2020 Daniel Łachacz. All rights reserved.
//

import UIKit

class AddTaskViewController: UIViewController {
    
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var descriptionTextField: UITextField!
    @IBOutlet weak var dateTextField: UITextField!
    
    let dataController = DataController()
    private var datePicker: UIDatePicker?
    lazy var dateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.yyyy"
        return dateFormatter
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dataController.initializeStack()
        setupView()
        setDatePicker()
        
        navigationItem.rightBarButtonItem?.isEnabled = false
        titleTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        titleTextField.text = ""
        descriptionTextField.text = ""
        dateTextField.text = ""
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
    
    private func setupView() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(tappedDone))
    }
    
    @objc private func tappedDone() {
       
            guard let title = titleTextField.text,
            let description = descriptionTextField.text,
            let dateString = dateTextField.text,
            let date = dateFormatter.date(from: dateString)
            else { return }
            
            try? dataController.insertTask(title: title, description: description, date: date)
    }
    
    @objc private func textFieldDidChange(_ sender: UITextField) {  // Activate Done button if the title field is not empty
      if titleTextField.text == "" {
          navigationItem.rightBarButtonItem?.isEnabled = false
      } else {
          navigationItem.rightBarButtonItem?.isEnabled = true
      }
    }
    
}
