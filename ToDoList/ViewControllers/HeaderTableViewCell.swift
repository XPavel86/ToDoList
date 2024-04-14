//
//  HederTableViewCell.swift
//  ToDoList
//
//  Created by Pavel Dolgopolov on 31.03.2024.
//

import UIKit

class HeaderTableViewCell: UITableViewCell {
    
    var buttonAction: (() -> ())?

    @IBOutlet var сategoryLabel: UILabel!
 
    @IBAction func addTaskPressed() {
        buttonAction?()
    }
}
