//
//  CategoryTableViewCell.swift
//  ToDoList
//
//  Created by Pavel Dolgopolov on 11.04.2024.
//

import UIKit

class CategoryTableViewCell: UITableViewCell {

    @IBOutlet var textField: UITextField!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
