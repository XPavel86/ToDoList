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
    @IBOutlet var checkImageView: UIImageView!
    
    weak var delegate: TasksViewControllerDelegate?
    
    private var categoryIndex: Int!
    private var profileIndex: Int!
    private var taskIndex: Int = 0
    private var isNewTask: Bool = false
    
    let dm = DataStore.Manager()
    
    private var previousText: String = ""
    private var isCreate = false
    private var isDelete = false
    private var changeText = false

    
    func sendData(_ profileIndex: Int, _ categoryIndex: Int, _ taskIndex: Int, _ isNewTask: Bool) {
        self.profileIndex = profileIndex
        self.categoryIndex = categoryIndex
        self.taskIndex = taskIndex
        self.isNewTask = isNewTask

        }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        checkImageView.isHidden = true
        
        textView.delegate = self
        
        if !isNewTask {
            previousText = dm.getTask(profileIndex: profileIndex, categoryIndex: categoryIndex, taskIndex: taskIndex).text
        }
        
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
        isDelete = false
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
            textView.text = ""
            isDelete = true
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
        guard !isNewTask else {
            textView.text = "Новая заметка/задача"
            textView.becomeFirstResponder()
            self.textView.selectAll(nil)
            return
        }
        
        guard let profIndex = profileIndex else {return}
        let count = dm.getTasks(profileIndex: profIndex, categoryIndex: categoryIndex).count
        
        var afterTitle = "\(taskIndex + 1 )/\(count)"
        
        if !textTitle.isEmpty {
            afterTitle = textTitle
        }
        title = "\(dm.getCategory(profileIndex: profileIndex, categoryIndex: categoryIndex).name) \(afterTitle)"
        
        if dm.getTasks(profileIndex: profileIndex, categoryIndex: categoryIndex).isEmpty {
            title = "No tasks"
            textView.text = ""
        } else  {
            textView.text = dm.getTask(profileIndex: profileIndex, categoryIndex: categoryIndex, taskIndex: taskIndex).text
        }
    }
    
    
    @IBAction func cloneTaskButton() {
        guard !isNewTask else { return }
        if !textView.text.isEmpty {
            let cloneText = "Clone \(textView.text ?? "")"
            dm.addTask(profileIndex: profileIndex, categoryIndex: categoryIndex, newDescription: cloneText) {
                self.isNewTask = false
            }
            //incIndex()
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
         
        let isEmpty = textView.text.isEmpty
        
        if !isEmpty && previousText != textView.text && changeText && !isCreate && !isNewTask {
            dm.getTask(profileIndex: profileIndex, categoryIndex: categoryIndex, taskIndex: taskIndex).text = textView.text
            print("saveChange")
            }

        if !isEmpty && (isCreate || isNewTask) {
            dm.addTask(profileIndex: profileIndex, categoryIndex: categoryIndex, newDescription: textView.text) {
                self.isNewTask = false
            }
            incIndex()
            print("isCreate")
        }
        
        if isDelete && !isNewTask {
            deleteTask()
        }
        
        isCreate = false
        changeText = false
        isDelete = false
        
        previousText = textView.text
    }
    
    @IBAction func changeStatusTask() {
        guard !isNewTask else { return }
        if !dm.getTasks(profileIndex: profileIndex, categoryIndex: categoryIndex).isEmpty {
            dm.getTask(profileIndex: profileIndex, categoryIndex: categoryIndex, taskIndex: taskIndex).ready.toggle()
            changeColor()
        }
    }
    
    func changeColor() {
        guard !isNewTask else { return }
        if !dm.getTasks(profileIndex: profileIndex, categoryIndex: categoryIndex).isEmpty {
            checkImageView.isHidden = !dm.getTask(profileIndex: profileIndex, categoryIndex: categoryIndex, taskIndex: taskIndex).ready
        }
    }
    
    func deleteTask() {
        
        if  !isCreate && textView.text.isEmpty && !dm.getTasks(profileIndex: profileIndex, categoryIndex: categoryIndex).isEmpty {
            print(#function)
            dm.removeTask(profileIndex: profileIndex, categoryIndex: categoryIndex, removeTaskIndex: taskIndex)
            decIndex()
            updateText()
        }
    }
    
    func incIndex() {
        if taskIndex < dm.getTasks(profileIndex: profileIndex, categoryIndex: categoryIndex).count - 1 {
            taskIndex += 1
        }
    }
    
    func decIndex() {
            if taskIndex > 0 {
                taskIndex -= 1
            }
        }
    

}



