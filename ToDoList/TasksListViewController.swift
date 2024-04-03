//
//  ToDoListViewController.swift
//  ToDoList
//
//  Created by Pavel Dolgopolov on 31.03.2024.
//

import UIKit

class TasksListViewController: UITableViewController {
    
    var tasksList = UserList(user: "", categories: [])

    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = tasksList.user
        
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if let indexPath = tableView.indexPathForSelectedRow {
            let detailsVC = segue.destination as? DetailViewController
            detailsVC?.text = tasksList.categories[indexPath.section].tasks[indexPath.row]
        }
    }
    
    override func viewWillLayoutSubviews() {
       
    }
    
    @IBAction func closePressed() {
        dismiss(animated: true)
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        tasksList.categories.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        tasksList.categories[section].tasks.count
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let cell = tableView.dequeueReusableCell(withIdentifier: "HeaderCell") as? HederTableViewCell
        
        let category = tasksList.categories[section]
        cell?.CategoryLabel.text = category.name

        return cell
       }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(withIdentifier: "TaskCell", for: indexPath)
        
        let task = tasksList.categories[indexPath.section].tasks[indexPath.row]
        
        var content = cell.defaultContentConfiguration()
        content.textProperties.numberOfLines = 1
        content.secondaryTextProperties.numberOfLines = 1
 
        content.text = String(indexPath.row + 1) + ". " + task
        
        let substrings = task.split(separator: "\n")
        
        if substrings.count >= 2 {
            let substring = substrings[1]
            content.secondaryText = String(substring)
        }
       
        //content.secondaryText = track.artist
        //content.image = UIImage(named: "Alberto Ruiz")
        //content.imageProperties.cornerRadius = tableView.rowHeight / 2
        cell.contentConfiguration = content
        
        return cell
    }
    
    
//    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
//          // Проверяем, является ли ячейка первой или последней в секции
//          let isFirstRowInSection = indexPath.row == 0
//          let isLastRowInSection = indexPath.row == tableView.numberOfRows(inSection: indexPath.section) - 1
//          
//          // Устанавливаем скругление для первой и последней ячейки
//          if isFirstRowInSection && isLastRowInSection {
//              cell.layer.cornerRadius = 10 // Пример радиуса скругления
//              cell.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner, .layerMinXMaxYCorner, .layerMaxXMaxYCorner]
//          } else if isFirstRowInSection {
//              cell.layer.cornerRadius = 10 // Пример радиуса скругления
//              cell.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
//          } else if isLastRowInSection {
//              cell.layer.cornerRadius = 10 // Пример радиуса скругления
//              cell.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
//          } else {
//              // Если это не первая и не последняя ячейка, сбросьте скругление
//              cell.layer.cornerRadius = 0
//              cell.layer.maskedCorners = []
//          }
//      }
//    
    
//    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//
//    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}


