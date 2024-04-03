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
    
    //@IBOutlet var profilText: UITextField!
    
    let users = UserList.getUserList()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillLayoutSubviews() {
        
        usersPickerView?.delegate = self
        usersPickerView?.dataSource = self
        
        if users.isEmpty {
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
        users.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        users[row].user
    }
    
    override func  prepare(for segue: UIStoryboardSegue, sender: Any?) {

        guard let destinationVC = segue.destination as? UINavigationController else { return }
        guard let tasksVC = destinationVC.topViewController as? TasksListViewController  else { return }
        
        if let selectedRow = usersPickerView?.selectedRow(inComponent: 0) {
            tasksVC.tasksList = users[selectedRow]
        }      
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        performSegue(withIdentifier: "segueTasks", sender: self)

    }

}

