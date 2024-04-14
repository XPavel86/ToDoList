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
    @IBOutlet var addButton: UIButton!

//    override func setSelected(_ selected: Bool, animated: Bool) {
//        super.setSelected(selected, animated: animated)
//    }
    
    @IBAction func addTaskPressed() {
        buttonAction?()
    }
}
