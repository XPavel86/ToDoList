//
//  DataStore.swift
//  ToDoList
//
//  Created by Pavel Dolgopolov on 31.03.2024.
//

import Foundation

struct DataStore {
    
    static let shared = DataStore()
    
var names = [
        "Alice",
        "Bob",
        "Charlie",
        "David",
        "Emma",
        "Frank",
        "Grace",
        "Henry",
        "Isabella",
        "Jack"
    ]
    
    var tasks = [
        "Buy groceries Buy groceries Buy groceries Buy groceries Buy groceries Buy groceries Finish homework Finish homework \nFinish homework Finish homeworkFinish homework Finish homeworkFinish homework Finish homework",
        "Finish homework",
        "Call mom",
        "Go to the gym",
        "Read a book",
        "Pay bills",
        "Clean the house",
        "Walk the dog",
        "Cook dinner",
        "Plan vacation"
    ]
    
    var categories = [
        "Работа",
        "Учеба",
        "Спорт",
        "Здоровье",
        "Путешествия",
        "Личное",
        "Финансы",
        "Хобби",
        "Семья",
        "Другое",
        "Дата"
        
    ]
    
    private init() {}
}
