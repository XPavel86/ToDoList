//
//  CategoryViewController.swift
//  ToDoList
//
//  Created by Pavel Dolgopolov on 11.04.2024.
//

import UIKit

protocol CategoryViewControllerDelegate: AnyObject {
    func didUpdate(_ text: String)
}

final class CategoryViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, CategoryViewControllerDelegate {
    
    weak var delegate: TasksViewControllerDelegate?
   
    @IBOutlet var textField: UITextField!
    @IBOutlet var tableView: UITableView!
    
    var profileIndex: Int!
    var indexCategory: Int = 0
    
    private var previousText: String?
    private let dm = DataStore.Manager()

    @IBAction func canceledOrAddPressed(sender: UIButton) {
        endEditing()
        guard let text = textField.text else { return }
        
        if sender.tag == 0 {
            dismiss(animated: true)
        } else if !text.isEmpty && previousText != textField.text {
            dm.addCategory(profileIndex: profileIndex, categoryName: text)
            tableView.reloadData()
            
            let dataCount = dm.getCategories(profileIndex: profileIndex).count
            let indexPath = IndexPath(row: dataCount - 1, section: 0)
            
            tableView.scrollToRow(at: indexPath, at: .bottom, animated: true)
            
            previousText = textField.text
        }
    }
    
    // MARK: - Overrides Methods
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear (animated)

        delegate?.didUpdate()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        textField.becomeFirstResponder()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            self.textField.selectAll(nil)
        }
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let indexPath = tableView.indexPathForSelectedRow {
            let editCategoryVC = segue.destination as? EditCategoryViewController
            let name = dm.getCategory(profileIndex: profileIndex, categoryIndex: indexPath.row).name
            
            editCategoryVC?.categoryName = name
            editCategoryVC?.delegate = self
            indexCategory = indexPath.row
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        dm.getCategories(profileIndex: profileIndex).count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
        
        let name = dm.getCategory(profileIndex: profileIndex, categoryIndex: indexPath.row).name

        var content = cell.defaultContentConfiguration()
        content.text = name
        content.image = UIImage(systemName: "folder")
        
        cell.contentConfiguration = content
        
        return cell
    }
    
    func didUpdate(_ text: String) {
        dm.renameCategory(profileIndex: profileIndex, index: indexCategory, newName: text)
        tableView.reloadData()
    }
}

