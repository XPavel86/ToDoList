//
//  NewTaskViewController.swift
//  ToDoList
//
//  Created by Pavel Dolgopolov on 13.04.2024.
//

import UIKit

class NewTaskViewController: UIViewController, DataDelegate {

    weak var delegate: TasksViewControllerDelegate?
    
    let dm = DataStore.Manager()
    
    private var categoryIndex: Int!
    private var profileIndex: Int!
    private var taskIndex: Int!
    private var isNewTask: Bool = false
    
    func sendData(_ profileIndex: Int, _ categoryIndex: Int, _ taskIndex: Int, _ isNewTask: Bool) {
        func sendData(_ profileIndex: Int, _ categoryIndex: Int, _ taskIndex: Int, _ isNewTask: Bool) {
            self.profileIndex = profileIndex
            self.categoryIndex = categoryIndex
            self.taskIndex = taskIndex
            self.isNewTask = isNewTask
            }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
