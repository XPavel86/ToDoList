//
//  DetailViewController.swift
//  ToDoList
//
//  Created by Pavel Dolgopolov on 03.04.2024.
//

import UIKit

class DetailViewController: UIViewController {
    
    @IBOutlet var textView: UITextView!
    
    //var category: DataStoreNew.Category?
    weak var delegate: DetailViewControllerDelegate?
    
    var section: Int!
    var profileIndex: Int!
    var taskIndex: Int!
    var text: String!
    
    let pm = DataStore.Manager()
    var profile: DataStore.Profile!
    
    var previousText: String?
    var isCreate = false
    var cursor: Int!
    
    let arr: [String] = ["dsfsd23","sdff232","sdv3434"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        textView.text = text
        previousText = text
        
        cursor = 0//taskIndex
        
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear (animated)
        delegate?.didUpdate()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        saveText()
        if textView.text.isEmpty && !isCreate  {
            pm.removeTask(profileIndex: profileIndex, categoryIndex: section, removeTaskIndex: taskIndex)
        }
    }
    
    @IBAction func undoEditButton() {
        if !isCreate {
            if let undoManager = textView.undoManager, undoManager.canUndo {
                undoManager.undo()
            } else if textView.text == "" {
                textView.text = previousText
            }
        }
    }
    
    @IBAction func clearTextButton() {
        if !textView.text.isEmpty {
            previousText = textView.text
            textView.text = ""
        }
    }
    
    @IBAction func saveButton() {
        saveText()
    }
    
    @IBAction func toLeftTask() {
        if cursor > 0 {
            cursor -= 1
            updateText()
        }
    }
    
    @IBAction func toRightTask() {
        let taskCount = profile.categories[section].tasks.count - 1
        if cursor < taskCount {
            cursor += 1
            updateText()
        }
    }
    
    func updateText() {
        textView.text = profile.categories[section].tasks[cursor].description
    }
    
    @IBAction func createNewTaskButton() {
        saveText()
        
        textView.text = ""
        previousText = ""
        isCreate = true
    }
    
    func saveText() {
        if !textView.text.isEmpty {
            if previousText != textView.text && previousText != "" {
                pm.changeTaskDescription(profileIndex: profileIndex, categoryIndex: section, taskIndex: taskIndex, newDescription: textView.text)
            } else
            if previousText == "" {
                pm.addTask(profileIndex: profileIndex, categoryIndex: section, newDescription: textView.text)
                taskIndex += 1
            }
            previousText = textView.text
        }
        isCreate = false
    }
}


