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
    var section: Int!
    var profileIndex: Int!
    var taskIndex: Int!
    var text: String!
    var previousText: String?
   
    override func viewDidLoad() {
        super.viewDidLoad()
        textView.text = text
    }
    
    @IBAction func undoEditButton() {
        if let undoManager = textView.undoManager, undoManager.canUndo {
            undoManager.undo()
        } else if textView.text == "" {
            textView.text = previousText
        }
    }
    
    @IBAction func clearTextButton() {
        
        if !textView.text.isEmpty {
            previousText = textView.text
            textView.text = ""
        }
    }
    
    @IBAction func saveButton() {
        ProfileManager.shared.changeTaskDescription(profileIndex: profileIndex, categoryIndex: section, taskIndex: taskIndex, newDescription: textView.text)
    }
    
    @IBAction func createNewTaskButton() {
        ProfileManager.shared.addTask(profileIndex: profileIndex, categoryIndex: section, newDescription: textView.text)
    }
    
}


