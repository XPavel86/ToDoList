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

class TasksListViewController: UITableViewController, TasksViewControllerDelegate, СellDelegate, UISearchBarDelegate {
    
    let dm = DataStore.Manager()
    
    weak var delegate: DataDelegate?
    
    var isNewTask: Bool = false
    
    func didOpenView() {
        isNewTask = true
        
        let detailsVC = DetailViewController()
        
        detailsVC.delegate = self
        self.delegate = detailsVC
        
       // delegate?.sendData(profileIndex, selectedSection, 0, true)
        detailsVC.profile = profile
        detailsVC.categoryIndex = selectedSection
        detailsVC.text = ""
        detailsVC.isNewTask = true
        
        performSegue(withIdentifier: "DetailSegue", sender: self)
             
    }
    
    
    func didUpdate() {
        
        tableView.reloadData()
    }
    
    
    @IBOutlet var editButton: UIBarButtonItem!
    
    @IBOutlet var searchBar: UISearchBar!
    
    
    var profile: DataStore.Profile!
    var profileIndex: Int!
    var selectedSection: Int!
    var searchingNames: [String] = []
    var searching = false
    
    
    @IBAction func editPressed() {
        self.isEditing.toggle()
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Разрешаем пользователю выделять ячейки в режиме редактирования
        //tableView.allowsSelectionDuringEditing = true
        
        //Отключаем отображение иконки перемещения для ячеек
        // tableView.setEditing(true, animated: false)
        
        title = profile.name
        searchBar.delegate = self
    }
    
    
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        var data: [String] = []
        
        if searchText.isEmpty {
            searching = false
        } else {
            for indexCategory in 0 ..< profile.categories.count {
                profile.categories[indexCategory].tasks.forEach {
                    element in data.append(element.text)
                }
            }
            searchingNames = data.filter (
                {$0.lowercased().prefix(searchText.count) ==
                    searchText.lowercased ()})
            
            searching = true
        }
        tableView.reloadData()
    }
    
    
    override func viewDidLayoutSubviews() {
        searchBar.frame = CGRect(x: 10, y: 0, width: tableView.frame.width - 20, height: searchBar.frame.height)
        
        searchBar.backgroundImage = UIImage()
        searchBar.backgroundColor = UIColor.clear
    }
    
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        searchBar.frame = CGRect(x: 10, y: 0, width: tableView.frame.width - 20, height: searchBar.frame.height)
        
        searchBar.backgroundImage = UIImage()
        searchBar.backgroundColor = UIColor.clear
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
    }
    
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        print(#function)
        guard let detailsVC = segue.destination as? DetailViewController else {return}
        
        if segue.identifier == "DetailSegue" && !isNewTask {
            if let indexPath = tableView.indexPathForSelectedRow
            {
                detailsVC.delegate = self
                self.delegate = detailsVC
                delegate?.sendData(profileIndex, indexPath.section, indexPath.row, false)

                detailsVC.text = profile.categories[indexPath.section].tasks[indexPath.row].text
                detailsVC.profile = profile
                
            }
        }
        else if segue.identifier == "CategorySegue" {
            let categoryVC = segue.destination as? CategoryViewController
            categoryVC?.indexProfile = profileIndex
            
        }
        
        
        
        //newTask = false
    }
    
    //    override func tableView(_: UITableView, canEditRowAt: IndexPath) -> Bool {
    //        //        Возможность взаимодействие с ячейками
    //        true
    //    }
    //
    //    override func tableView(_: UITableView, canMoveRowAt: IndexPath) -> Bool {
    //        true
    //        //        Определяет можно ли перемещать строки
    //    }
    
    override func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        
        return .none
    }
    
    
    
    override func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destIndexPath: IndexPath) {
        
        let removedTask = profile.categories[sourceIndexPath.section].tasks.remove(at: sourceIndexPath.row)
        
        profile.categories[destIndexPath.section].tasks.insert(removedTask, at: destIndexPath.row)
        
        tableView.reloadData()
        
    }
    
    @IBAction func closePressed() {
        dismiss(animated: true)
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        
        if searching {
            return 1
        } else {
            return dm.getCountCategories(index: profileIndex) //profile.categories.count
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searching {
            return searchingNames.count
        } else {
            return dm.getCountTasks(profileIndex: profileIndex, categoryIndex: section)
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        50
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        40
    }
    
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let cell = tableView.dequeueReusableCell(withIdentifier: "HeaderCell") as? HeaderTableViewCell
        
        cell?.delegate = self
        
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
    
    
    func buttonPressed(inSection section: Int) {
        selectedSection = section
        print("buttonPressed \(selectedSection ?? 0)")
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
            let substrings = searchingNames[indexPath.row].split(separator: "\n")
            
            if substrings.count >= 2 {
                let substring = substrings[1]
                content.secondaryText = String(substring)
            }
        } else
        {
            let task = profile.categories[indexPath.section].tasks[indexPath.row]
            
            cell.backgroundColor = task.ready
            ? UIColor(red: 0.910, green: 0.969, blue: 0.902, alpha: 1.0)
            : .systemBackground
            
            content.text = String(indexPath.row + 1) + ". " + task.text
            
            let substrings = task.text.split(separator: "\n")
            
            if substrings.count >= 2 {
                let substring = substrings[1]
                content.secondaryText = String(substring)
            }
        }
        
        cell.contentConfiguration = content
        
        return cell
    }
    
}


