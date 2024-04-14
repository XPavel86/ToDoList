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
    
    private var searchingNames: [String] = []
    private var searching = false
    
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
            
            if let indexPath = tableView.indexPathForSelectedRow
            {
                detailsVC.delegate = self
                self.delegate = detailsVC
                
                delegate?.sendData(profileIndex, indexPath.section, indexPath.row, false)
            } else {
                detailsVC.delegate = self
                self.delegate = detailsVC
                
                delegate?.sendData(profileIndex, selectedSection, 0, true)
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
        
        if searching {
            return 1
        } else {
            return dm.getCategories(profileIndex: profileIndex).count
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searching {
            return searchingNames.count
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
        if searching {
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
        
        if searching {
            content.text = searchingNames[indexPath.row]
            content.secondaryText = extractSecondString(searchingNames[indexPath.row])
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
    
 //   // MARK: - Private Methods
//    private func didOpenView() {
//        isNewTask = true
//    }

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        var data: [String] = []
        
        if searchText.isEmpty {
            searching = false
        } else {
            for categoryIndex in 0 ..< dm.getCategories(profileIndex: profileIndex).count {
                dm.getCategory(profileIndex: profileIndex, categoryIndex: categoryIndex).tasks.forEach {
                    element in data.append(element.text)
                }
            }
            searchingNames = data.filter { $0.lowercased().contains(searchText.lowercased()) }
            searching = true
        }
        tableView.reloadData()
    }
}

