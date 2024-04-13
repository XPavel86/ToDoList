//
//  DetailViewController.swift
//  ToDoList
//
//  Created by Pavel Dolgopolov on 03.04.2024.
//

import UIKit

protocol DataDelegate: AnyObject {
    func sendData(_ profileIndex: Int, _ categoryIndex: Int, _ taskIndex: Int, _ isNewTask: Bool)
    
}

class DetailViewController: UIViewController, UITextViewDelegate, DataDelegate {
   
    @IBOutlet var textView: UITextView!

    weak var delegate: TasksViewControllerDelegate?
    
     var categoryIndex: Int!
     var profileIndex: Int!
    private var taskIndex: Int = 0
     var text: String!
    
    private let dm = DataStore.Manager()
    var profile: DataStore.Profile!
    
    private var previousText: String?
    private var isCreate = false
     var isNewTask = false
    private var changeText = false
    
    func sendData(_ profileIndex: Int, _ categoryIndex: Int, _ taskIndex: Int, _ isNewTask: Bool) {
        
        self.profileIndex = profileIndex
        self.categoryIndex = categoryIndex
        self.taskIndex = taskIndex
        self.isNewTask = isNewTask
        print("Detail \(#function) \(taskIndex) \(isNewTask)")
        
        }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("\(#function) \(isNewTask)")
        
        textView.delegate = self
        
        previousText = text
        
       updateText()
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("\(#function) \(isNewTask)")
    }
    
    
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        changeText = true
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
            deleteTask()
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
        guard !isNewTask else { return }
        guard let profIndex = profileIndex else {return}
        let count = dm.getCountTasks(profileIndex: profIndex, categoryIndex: categoryIndex)
        
        var afterTitle = "\(taskIndex + 1 )/\(count)"
        
        if !textTitle.isEmpty {
            afterTitle = textTitle
        }
        title = "\(profile.categories[categoryIndex].name) \(afterTitle)"
        
        if profile.categories[categoryIndex].tasks.isEmpty {
            title = "No tasks"
            textView.text = ""
        } else  {
            textView.text = profile.categories[categoryIndex].tasks[taskIndex].text
        }
    }
    
    
    @IBAction func copyTaskButton() {
        if !textView.text.isEmpty {
            dm.addTask(profileIndex: profileIndex, categoryIndex: categoryIndex, newDescription: textView.text)
            taskIndex = profile.categories[categoryIndex].tasks.count - 1
            
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
         
        if !textView.text.isEmpty && previousText != textView.text && changeText && !isCreate {
                dm.changeTaskDescription(profileIndex: profileIndex, categoryIndex: categoryIndex, taskIndex: taskIndex, newDescription: textView.text)
                print("saveChange")
            }

        if !textView.text.isEmpty && isCreate {
            dm.addTask(profileIndex: profileIndex, categoryIndex: categoryIndex, newDescription: textView.text)
            incIndex()
            print("isCreate")
        }
        isCreate = false
        changeText = false
        
        previousText = textView.text
    }
    
    @IBAction func changeStatusTask() {
        if !profile.categories[categoryIndex].tasks.isEmpty {
            profile.categories[categoryIndex].tasks[taskIndex].ready.toggle()
            changeColor()
        }
    }
    
     func changeColor() {
         guard !isNewTask else { return }
         if !profile.categories[categoryIndex].tasks.isEmpty {
             view.backgroundColor = profile.categories[categoryIndex].tasks[taskIndex].ready
             ? UIColor(red: 0.910, green: 0.969, blue: 0.902, alpha: 1.0)
             : .systemBackground
             
             textView.backgroundColor = view.backgroundColor
         }
    }
    
    func deleteTask() {
        if !textView.text.isEmpty && !profile.categories[categoryIndex].tasks.isEmpty {
            dm.removeTask(profileIndex: profileIndex, categoryIndex: categoryIndex, removeTaskIndex: taskIndex)
            decIndex()
            updateText()
        }
    }
    
    func incIndex() {
        if taskIndex < profile.categories[categoryIndex].tasks.count - 1 {
            taskIndex += 1
        }
    }
    
    func decIndex() {
            if taskIndex > 0 {
                taskIndex -= 1
            }
        }
}



