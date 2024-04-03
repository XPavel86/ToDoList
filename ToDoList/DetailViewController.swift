//
//  DetailViewController.swift
//  ToDoList
//
//  Created by Pavel Dolgopolov on 03.04.2024.
//

import UIKit

class DetailViewController: UIViewController {

    @IBOutlet var textView: UITextView!
   
    var text = ""
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
        saveTask()
    }
    
    @IBAction func createNewTaskButton() {
        print("stub - create a new task")
    }
    
    private func saveTask() {
        print("stub - save  task")
    }
}


