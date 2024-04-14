//
//  SettingsViewController.swift
//  ToDoList
//
//  Created by Pavel Dolgopolov on 14.04.2024.
//

import UIKit

class SettingsViewController: UIViewController {
    
    @IBOutlet var switchLineNumbers: UISwitch!
    
    weak var delegate: TasksViewControllerDelegate?
    
    override func viewDidDisappear(_ animated: Bool) {
        
        delegate?.islineNumbering = switchLineNumbers.isOn
        delegate?.didUpdate()
    }
}
