//
//  ActiveCell.swift
//  ToDoList
//
//  Created by Daniel Łachacz on 25/07/2020.
//  Copyright © 2020 Daniel Łachacz. All rights reserved.
//

import UIKit

class MainCell: UITableViewCell {
    
    static let identifier = "MainCell"
    
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
}
