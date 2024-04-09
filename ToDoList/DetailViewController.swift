//
//  DetailViewController.swift
//  ToDoList
//
//  Created by Pavel Dolgopolov on 03.04.2024.
//

import UIKit

class DetailViewController: UIViewController, UITextViewDelegate {
    
    @IBOutlet var textView: UITextView!
    
    weak var delegate: DetailViewControllerDelegate?
    
    var section: Int!
    var profileIndex: Int!
    var taskIndex: Int!
    var text: String!
    
    let pm = DataStore.Manager()
    var profile: DataStore.Profile!
    
    var previousText: String?
    var isCreate = false
    var changeText = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        textView.delegate = self
        
        previousText = text
        updateText()
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        changeText = true
           // Проверяем, является ли длина нового текста больше максимально допустимой длины (например, 100 символов)
           let newText = (textView.text as NSString).replacingCharacters(in: range, with: text)
           return newText.count <= 1000 // Максимально допустимая длина
       }
    
    override func viewWillLayoutSubviews() {
        super.viewDidLoad()
        
        changeColor()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear (animated)
        
        saveText()
        delegate?.didUpdate()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        
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
            deleteText()
        }
    }
    
    @IBAction func saveButton() {
        saveText()
    }
    
    @IBAction func toLeftTask() {
       saveText()
       decIndex()
       updateText()
       isCreate = false
    }
    
    @IBAction func toRightTask() {
        saveText()
        incIndex()
        updateText()
        isCreate = false
    }
    
    func updateText(_ textTitle: String = "") {
        let count = profile.categories[section].tasks.count
        
        var afterTitle = "\(taskIndex + 1 )/\(count)"
        
        if !textTitle.isEmpty {
            afterTitle = textTitle
        }
        title = "\(profile.categories[section].name) \(afterTitle)"
        
        if profile.categories[section].tasks.isEmpty {
            title = "No tasks"
            textView.text = ""
        } else  {
            textView.text = profile.categories[section].tasks[taskIndex].description
        }
    }
    
    
    @IBAction func copyTaskButton() {
        if !textView.text.isEmpty {
            pm.addTask(profileIndex: profileIndex, categoryIndex: section, newDescription: textView.text)
            taskIndex = profile.categories[section].tasks.count - 1
            
            updateText()
        }
    }
    
    @IBAction func createNewTaskButton() {
        saveText()
        
        updateText("New")
        textView.text = ""
        isCreate = true
    }
    
    func saveText() {
        if !textView.text.isEmpty {
            if  previousText != textView.text && changeText && !isCreate {
                pm.changeTaskDescription(profileIndex: profileIndex, categoryIndex: section, taskIndex: taskIndex, newDescription: textView.text)
                print("saveChange")
            }
            
            if isCreate {
                pm.addTask(profileIndex: profileIndex, categoryIndex: section, newDescription: textView.text)
                incIndex()
                print("isCreate")
            }
            previousText = textView.text
        }
        isCreate = false
        changeText = false
    }
    
    @IBAction func changeStatusTask() {
        profile.categories[section].tasks[taskIndex].ready.toggle()
        changeColor()
    }
    
     func changeColor() {
        view.backgroundColor = profile.categories[section].tasks[taskIndex].ready
            ? UIColor(red: 0.910, green: 0.969, blue: 0.902, alpha: 1.0)
            : .systemBackground
         
         textView.backgroundColor = view.backgroundColor
    }
    
    func deleteText() {
        if !textView.text.isEmpty && taskIndex >= 0 {
            pm.removeTask(profileIndex: profileIndex, categoryIndex: section, removeTaskIndex: taskIndex)
            decIndex()
            updateText()
        }
    }
    
    func incIndex() {
        if taskIndex < profile.categories[section].tasks.count - 1 {
            taskIndex += 1
        }
    }
    
    func decIndex() {
            if taskIndex > 0 {
                taskIndex -= 1
            }
        }
}



