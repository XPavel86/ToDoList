//
//  ToDoListViewController.swift
//  ToDoList
//
//  Created by Pavel Dolgopolov on 31.03.2024.
//

import UIKit

protocol DetailViewControllerDelegate: AnyObject {
    func didUpdate()
}

class TasksListViewController: UITableViewController, DetailViewControllerDelegate {
    
    func didUpdate() {
        tableView.reloadData()
    }
    
    
    @IBOutlet var editButton: UIBarButtonItem!
    
    var profile: DataStore.Profile!
    
    var profileIndex: Int!
    @IBAction func editPressed() {
        self.isEditing.toggle()
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Разрешаем пользователю выделять ячейки в режиме редактирования
        //tableView.allowsSelectionDuringEditing = true

        // Отключаем отображение иконки перемещения для ячеек
        //tableView.setEditing(true, animated: false)
        
        title = profile.name
        
        let longPress = UILongPressGestureRecognizer(target: self, action: #selector(longPressGestureRecognized(_:)))
        self.tableView.addGestureRecognizer(longPress)


    }
    
    @IBAction func longPressGestureRecognized(_ sender: UILongPressGestureRecognizer) {
        guard let longPress = sender as? UILongPressGestureRecognizer else { return }
        let state = longPress.state
        
        let location = longPress.location(in: self.tableView)
        let indexPath = self.tableView.indexPathForRow(at: location)
        
        // Продолжение следует...
    }

    
    override func viewWillLayoutSubviews() {
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
    }
    
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if let indexPath = tableView.indexPathForSelectedRow {
            let detailsVC = segue.destination as? DetailViewController
            
            detailsVC?.profileIndex = profileIndex
            detailsVC?.section = indexPath.section
            detailsVC?.taskIndex = indexPath.row
            detailsVC?.profile = profile
            
            detailsVC?.text = profile.categories[indexPath.section].tasks[indexPath.row].description
            detailsVC?.delegate = self
        }
    }
    
    override func tableView(_: UITableView, canEditRowAt: IndexPath) -> Bool {
        //        Возможность взаимодействие с ячейками
        true
    }
    
    override func tableView(_: UITableView, canMoveRowAt: IndexPath) -> Bool {
        true
        //        Определяет можно ли перемещать строки
    }
    
    override func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        // Отключаем отображение иконки перемещения
        return .none
    }
    
    
    
    override func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destIndexPath: IndexPath) {
        // Получаем элемент, который мы собираемся переместить
        let movedTask = profile.categories[sourceIndexPath.section].tasks[sourceIndexPath.row]
        
        // Удаляем элемент из исходной секции
        let removedTask = profile.categories[sourceIndexPath.section].tasks.remove(at: sourceIndexPath.row)
        
        // Вставляем элемент в новую секцию
        profile.categories[destIndexPath.section].tasks.insert(removedTask, at: destIndexPath.row)
        
        // Обновляем только перемещенные строки
        tableView.moveRow(at: sourceIndexPath, to: destIndexPath)
        
        // Перезагружаем только те секции, где произошли изменения
        //tableView.reloadSections(IndexSet(arrayLiteral: sourceIndexPath.section, destIndexPath.section), with: .automatic)
    }


    
    @IBAction func closePressed() {
        dismiss(animated: true)
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        profile.categories.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        profile.categories[section].tasks.count
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let cell = tableView.dequeueReusableCell(withIdentifier: "HeaderCell") as? HederTableViewCell
        
        let category =  profile.categories[section]
        cell?.CategoryLabel.text = category.name
        
        return cell
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "TaskCell", for: indexPath)
        
        cell.indentationWidth = 0
        cell.indentationLevel = 0
        
        let task =  profile.categories[indexPath.section].tasks[indexPath.row]
        
            cell.backgroundColor = task.ready 
            ? UIColor(red: 0.910, green: 0.969, blue: 0.902, alpha: 1.0)
            : .systemBackground
        
        
        var content = cell.defaultContentConfiguration()
        content.textProperties.numberOfLines = 1
        content.secondaryTextProperties.numberOfLines = 1
        
        
        content.text = String(indexPath.row + 1) + ". " + task.description
        
        let substrings = task.description.split(separator: "\n")
        
        if substrings.count >= 2 {
            let substring = substrings[1]
            content.secondaryText = String(substring)
        }

        cell.contentConfiguration = content
        
        return cell
    }
   
}


