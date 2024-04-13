//
//  CategoryViewController2.swift
//  ToDoList
//
//  Created by Pavel Dolgopolov on 13.04.2024.
//

import UIKit

class CategoryViewController2: UIViewController {

    var profileIndex: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        title = String(profileIndex)
    }
    
}
