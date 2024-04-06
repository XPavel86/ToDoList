//
//  ToDoListViewController.swift
//  ToDoList
//
//  Created by Pavel Dolgopolov on 31.03.2024.
//

import UIKit

class TasksListViewController: UITableViewController {
    
    var profile: DataStoreNew.Profile!
    var profileIndex: Int!
    
    override func viewDidLoad() {
        super.viewDidLoad()
       /// Разрешаем пользователю выделять ячейки в режиме редактирования
        tableView.allowsSelectionDuringEditing = true
        
        // Отключаем отображение иконки перемещения для ячеек
        tableView.setEditing(true, animated: false)
        
        title = profile.name
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

            detailsVC?.text = profile.categories[indexPath.section].tasks[indexPath.row].description
        }
    }
    
    @IBAction func unwind(for segue: UIStoryboardSegue ) {
        
       
        if let indexPath = tableView.indexPathForSelectedRow {
           // let detailsVC = segue.source as? DetailViewController
            
            tableView.reloadRows(at: [indexPath], with: .automatic)
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
    
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        // Добавляем действие для свайпа вправо (например, удаление)
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { (_, _, completionHandler) in
            // Ваш код удаления элемента
            completionHandler(true)
        }
        
        // Устанавливаем изображение для действия (иконку корзины)
        deleteAction.image = UIImage(systemName: "trash")
        
        let swipeConfiguration = UISwipeActionsConfiguration(actions: [deleteAction])
        swipeConfiguration.performsFirstActionWithFullSwipe = false // Для того чтобы действие выполнялось после неполного свайпа
        
        return swipeConfiguration
    }




    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        // Обработка свайпа ячейки влево (например, удаление)
        if editingStyle == .delete {
            // Ваш код удаления элемента
        }
    }

    override func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        // Добавляем действие для свайпа влево (например, смена статуса)
        let changeStatusAction = UIContextualAction(style: .normal, title: "Change Status") { (_, _, completionHandler) in
            print( " Ваш код для смены статуса ")
            completionHandler(true)
        }
        changeStatusAction.backgroundColor = .blue
        
        let swipeConfiguration = UISwipeActionsConfiguration(actions: [changeStatusAction])
        swipeConfiguration.performsFirstActionWithFullSwipe = false // Для того чтобы действие выполнялось после неполного свайпа
        
        return swipeConfiguration
    }

  
    
//    override func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destIndexPath: IndexPath) {
//        // Получаем элемент, который мы собираемся переместить
//        let movedTask = user.categories[sourceIndexPath.section].tasks[sourceIndexPath.row]
//        
//        // Удаляем элемент из исходного индекса
//        user.categories[sourceIndexPath.section].tasks.remove(at: sourceIndexPath.row)
//        
//        // Вставляем элемент в новый индекс
//        user.categories[sourceIndexPath.section].tasks.insert(movedTask, at: destIndexPath.row)
//    
//        tableView.reloadData()
//        
//        print("After mowe_ 1 \(user.categories[0].tasks)")
//        print("\n")
//        print("After mowe_ 2 \(user.categories[1].tasks)")
//    }

    override func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destIndexPath: IndexPath) {
        // Получаем элемент, который мы собираемся переместить
        let movedTask = profile.categories[sourceIndexPath.section].tasks[sourceIndexPath.row]
        
        // Удаляем элемент из исходного индекса
        profile.categories[sourceIndexPath.section].tasks.remove(at: sourceIndexPath.row)
        
        // Вставляем элемент в новый индекс
        profile.categories[destIndexPath.section].tasks.insert(movedTask, at: destIndexPath.row)
        
        // Обновляем только перемещенные строки
        tableView.moveRow(at: sourceIndexPath, to: destIndexPath)
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
        
        var content = cell.defaultContentConfiguration()
        content.textProperties.numberOfLines = 1
        content.secondaryTextProperties.numberOfLines = 1


        content.text = String(indexPath.row + 1) + ". " + task.description
        
        let substrings = task.description.split(separator: "\n")
        
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


