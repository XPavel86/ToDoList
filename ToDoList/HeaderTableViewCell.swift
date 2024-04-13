//
//  HederTableViewCell.swift
//  ToDoList
//
//  Created by Pavel Dolgopolov on 31.03.2024.
//

import UIKit

protocol СellDelegate: AnyObject {
    func didOpenView()
}

class HeaderTableViewCell: UITableViewCell {
    var buttonAction: (() -> ())?

    weak var delegate: СellDelegate?
   
    @IBOutlet var сategoryLabel: UILabel!
    
    @IBOutlet var addButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
      
    }
    
    @IBAction func addTaskPressed() {
        buttonAction?()
        delegate?.didOpenView()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }

}
