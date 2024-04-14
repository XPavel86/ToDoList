//
//  extention+UIViewController.swift
//  ToDoList
//
//  Created by Pavel Dolgopolov on 14.04.2024.
//

import UIKit

extension UIViewController {
    
    open override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        endEditing()
        super.touchesBegan(touches, with: event)
    }
    
     func endEditing() {
        self.view.endEditing(true)
    }
}
