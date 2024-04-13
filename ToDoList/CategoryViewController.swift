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
   
    @IBOutlet var textField: UITextField!
    @IBOutlet var tableView: UITableView!
    
    var indexCategory: Int = 0
    let dm = DataStore.Manager()
    
    private var categories: [DataStore.Category]!
    
    var indexProfile: Int! {
        didSet {
            categories = DataStore.shared.profiles[indexProfile].categories
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func canceledOrAddPressed(sender: UIButton) {
        guard let text = textField.text else { return }
        
        if sender.tag == 0 {
            dismiss(animated: true)
        } else if !text.isEmpty {
            dm.addCategory(profileIndex: indexProfile, categoryName: text)
            tableView.reloadData()
        }
    }
    
    func didUpdate(_ text: String) {
        dm.renameCategory(profileIndex: indexProfile, index: indexCategory, newName: text)
        tableView.reloadData()
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let indexPath = tableView.indexPathForSelectedRow {
            let editCategoryVC = segue.destination as? EditCategoryViewController
            let name = dm.getNameCategory(profileIndex: indexProfile, categoryIndex: indexPath.row)
            editCategoryVC?.categoryName = name
            editCategoryVC?.delegate = self
            indexCategory = indexPath.row
        }
    }
    

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
         dm.getCountCategories(index: indexProfile)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
        
        let name = dm.getNameCategory(profileIndex: indexProfile, categoryIndex: indexPath.row)

        var content = cell.defaultContentConfiguration()
        content.text = name
        content.image = UIImage(systemName: "folder")
        
        cell.contentConfiguration = content
        
        return cell
    }
}
