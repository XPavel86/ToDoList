//
//  EditCategoryViewController.swift
//  ToDoList
//
//  Created by Pavel Dolgopolov on 11.04.2024.
//

import UIKit

class EditCategoryViewController: UIViewController {

    @IBOutlet var textField: UITextField!
    
    weak var delegate: CategoryViewControllerDelegate?
    
    var isSave: Bool = false
    var categoryName: String?

    @IBAction func closePressed(sender: UIButton) {
        isSave = sender.tag == 0
        ? false
        : true
        
        endEditing()
        dismiss(animated: true)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        textField.becomeFirstResponder()
        textField.text = categoryName
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear (animated)
        
        if let text = textField.text, !text.isEmpty, isSave, categoryName != text {
            delegate?.didUpdate(text)
        }
    }
}
