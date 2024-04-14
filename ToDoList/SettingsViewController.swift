//
//  SettingsViewController.swift
//  ToDoList
//
//  Created by user on 14.04.2024.
//

import UIKit

//Создаем потокол делегата
protocol SettingsViewControllerDelegate: AnyObject {
    //Добавили свойство делегата
    func switchValueChanged(_ value: Bool)
}

final class SettingsViewController: UIViewController, DataDelegate {
    func sendData(_ profileIndex: Int, _ categoryIndex: Int, _ taskIndex: Int, _ isNewTask: Bool) {
    }
    
    

    weak var delegate: SettingsViewControllerDelegate?
    
    var switchChanged: Bool = false {
        didSet {
            delegate?.switchValueChanged(switchChanged)
        }

    }
    
    @IBOutlet var nameSettings: UILabel!
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

        let taskListVC = segue.destination as? TasksListViewController
        taskListVC?.delegate = self //Устанавливаем taskListVC в качестве делегата
        taskListVC?.switchChanged = switchChanged.self
        
    }
    
    
    @IBAction func switchDidChanged(_ sender: UISwitch) {
        if sender .isOn {
            switchChanged = true
            nameSettings.text = "On"
        } else {
            switchChanged = false
            nameSettings.text = "Off"
        }
    }
}
