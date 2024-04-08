//
//  ViewController.swift
//  ToDoList
//
//  Created by Pavel Dolgopolov on 30.03.2024.
//

import UIKit

class StartViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    @IBOutlet var userTextField: UITextField!
    @IBOutlet var usersPickerView: UIPickerView!
    
    @IBAction func change() {
        
        let manager = DataStore.Manager()
        manager.changeTaskDescription(profileIndex: 0, categoryIndex: 0, taskIndex: 0, newDescription: "6656478987898789")

    }
    
    let profiles = DataStore.shared.profiles
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(profiles[0].categories)
        
    }
    
    override func viewWillLayoutSubviews() {
        
        usersPickerView?.delegate = self
        usersPickerView?.dataSource = self
        
        if profiles.isEmpty {
            usersPickerView.isHidden = true
            userTextField.isHidden = false
        } else {
            userTextField.isHidden = true
            usersPickerView.isHidden = false
        }
    }
    
    func numberOfComponents (in pickerView: UIPickerView) -> Int {
        1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        profiles.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        profiles[row].name
    }
    
    override func  prepare(for segue: UIStoryboardSegue, sender: Any?) {

        guard let destinationVC = segue.destination as? UINavigationController else { return }
        guard let tasksVC = destinationVC.topViewController as? TasksListViewController  else { return }
        
        if let selectedRow = usersPickerView?.selectedRow(inComponent: 0) {
            tasksVC.profile = profiles[selectedRow]
            tasksVC.profileIndex = selectedRow
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        performSegue(withIdentifier: "segueTasks", sender: self)

    }

}

