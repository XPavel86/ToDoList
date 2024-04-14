//
//  ViewController.swift
//  ToDoList
//
//  Created by Pavel Dolgopolov on 30.03.2024.
//

import UIKit

final class StartViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    @IBOutlet var usersPickerView: UIPickerView!
    
    private let profiles = DataStore.shared.profiles
    private let dm = DataStore.Manager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        usersPickerView?.delegate = self
        usersPickerView?.dataSource = self
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
    
    func numberOfComponents (in pickerView: UIPickerView) -> Int {
        1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        dm.getProfiles().count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        dm.getProfile(at: row).name
    }
}

