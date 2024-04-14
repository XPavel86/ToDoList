//
//  ToDoListViewController.swift
//  ToDoList
//
//  Created by Pavel Dolgopolov on 31.03.2024.
//

import UIKit

protocol TasksViewControllerDelegate: AnyObject {
    func didUpdate()
}

final class TasksListViewController: UITableViewController, TasksViewControllerDelegate,  UISearchBarDelegate {
    
    // MARK: - IB Outlets
    @IBOutlet var editButton: UIBarButtonItem!
    @IBOutlet var searchBar: UISearchBar!
    
    // MARK: - Public Properties
    weak var delegate: DataDelegate?
    var profileIndex: Int = 0
    var profile: DataStore.Profile!
    
    // MARK: - Private Properties
    private let dm = DataStore.Manager()
    
    private var isNewTask: Bool = false
    private var selectedSection: Int!
    

    private var isSearching = false
    
    struct SearchResult {
        var text: String
        var indexCategory: Int
        var indexTask: Int
    }
    
    private var searchData: [SearchResult] = []
    
    
    // MARK: - Initializers
    override func viewDidLoad() {
        super.viewDidLoad()
        title = dm.getProfile(at: profileIndex).name
        searchBar.delegate = self
    }
    
    // MARK: - Overrides Methods
    override func viewDidLayoutSubviews() {
        searchBar.frame = CGRect(x: 10, y: 0, width: tableView.frame.width - 20, height: searchBar.frame.height)
        
        searchBar.backgroundImage = UIImage()
        searchBar.backgroundColor = UIColor.clear
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "DetailSegue" || segue.identifier == "DetailSegueAdd" {
            guard let detailsVC = segue.destination as? DetailViewController else { return }
            
            func sendDelegate(_ profileIndex: Int, _ categoryIndex: Int, _ taskIndex: Int, _ isNewTask: Bool) {
                detailsVC.delegate = self
                self.delegate = detailsVC
                
                delegate?.sendData(profileIndex, categoryIndex, taskIndex, isNewTask)
            }
            
            if let indexPath = tableView.indexPathForSelectedRow
            {
                if isSearching {
                    let indexCategory = searchData[indexPath.row].indexCategory
                    let indexTask = searchData[indexPath.row].indexTask
                    
                    sendDelegate(profileIndex, indexCategory, indexTask, false)
                    
                } else {
                    sendDelegate(profileIndex, indexPath.section, indexPath.row, false)
                }
            } else {
                sendDelegate(profileIndex, selectedSection, 0, true)
            }
        }
        else if segue.identifier == "CategorySegue" {
            guard let categoryVC = segue.destination as? CategoryViewController else {return}
            
            categoryVC.profileIndex = profileIndex
            categoryVC.delegate = self
        }
        isNewTask = false
    }
    
    // MARK: - Table view
    override func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .none
    }
    
    override func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destIndexPath: IndexPath) {
        
        let removedTask = profile.categories[sourceIndexPath.section].tasks.remove(at: sourceIndexPath.row)
        
        profile.categories[destIndexPath.section].tasks.insert(removedTask, at: destIndexPath.row)
        
        tableView.reloadData()
        
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        
        if isSearching {
            return 1
        } else {
            return dm.getCategories(profileIndex: profileIndex).count
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isSearching {
            return searchData.count
        } else {
            return dm.getTasks(profileIndex: profileIndex, categoryIndex: section).count
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        60
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        50
    }
    
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let cell = tableView.dequeueReusableCell(withIdentifier: "HeaderCell") as? HeaderTableViewCell
        
        cell?.buttonAction = { [weak self] in
            self?.buttonPressed(inSection: section)
        }
        
        let category =  profile.categories[section]
        if isSearching {
            cell?.isHidden = true
        } else
        {
            cell?.isHidden = false
            cell?.сategoryLabel.text = category.name
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "TaskCell", for: indexPath)
        
        cell.indentationWidth = 0
        cell.indentationLevel = 0
        
        var content = cell.defaultContentConfiguration()
        content.textProperties.numberOfLines = 1
        content.secondaryTextProperties.numberOfLines = 1
        
        if isSearching {
            content.text = searchData[indexPath.row].text
            content.secondaryText = extractSecondString(searchData[indexPath.row].text)
        } else
        {
            let task = profile.categories[indexPath.section].tasks[indexPath.row]
            
            if self.traitCollection.userInterfaceStyle == .dark {
                cell.layer.borderWidth = 1
                cell.layer.borderColor = UIColor.link.cgColor
            } else {
                cell.layer.borderColor = UIColor.gray.cgColor
            }
            
            content.text = String(indexPath.row + 1) + ". " + task.text
            
            if task.ready {
                content.image = UIImage(systemName: "checkmark")
            } else {
                content.image = UIImage()
            }
            content.secondaryText = extractSecondString(task.text)
        }
        
        cell.contentConfiguration = content
        
        func extractSecondString(_ inputText: String) -> String {
            let substrings = inputText.split(separator: "\n")
            
            if substrings.count >= 2 {
                let substring = substrings[1]
                return String(substring)
            }
            return ""
        }
        return cell
    }
    
    // MARK: - IB Actions
    @IBAction func editPressed() {
        self.isEditing.toggle()
    }
    
    @IBAction func closePressed() {
        dismiss(animated: true)
    }
    
    // MARK: - Public Methods
    func didUpdate() {
        tableView.reloadData()
    }
    
    func buttonPressed(inSection section: Int) {
        selectedSection = section
    }
    
    // MARK: - Private Methods
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty {
            isSearching = false
            searchData.removeAll()
        } else {
            for categoryIndex in 0 ..< dm.getCategories(profileIndex: profileIndex).count {
                dm.getCategory(profileIndex: profileIndex, categoryIndex: categoryIndex).tasks.enumerated().forEach { indexTask, element in
                    if element.text.lowercased().contains(searchText.lowercased()) {
                        let result = SearchResult(text: element.text, indexCategory: categoryIndex, indexTask: indexTask)
                        if !searchData.contains(where: { $0.text == result.text }) {
                            searchData.append(result)
                        }
                    }
                }
            }
            isSearching = true
        }
        tableView.reloadData()
    }
}

