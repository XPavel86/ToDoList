//
//  model.swift
//  ToDoList
//
//  Created by Pavel Dolgopolov on 08.04.2024.
//

// MARK: Data Model

final class DataStore {
    static let shared = DataStore()
    var profiles: [Profile] = []
    
    class Profile {
        var name: String
        var categories: [Category] = []
        
        init(name: String) {
            self.name = name
        }
    }
    
    class Category {
        var name: String = ""
        var tasks: [Task] = []
    }
    
    class Task {
        var text: String = ""
        var isReady: Bool = false
    }
    
    
    // MARK: Manager Data
    
    final class Manager {
        var dataStore = DataStore.shared
        
        func addProfile(name: String) {
            let newProfile = DataStore.Profile(name: name)
            
            if !dataStore.profiles.contains(where: { $0.name == newProfile.name }) {
                dataStore.profiles.append(newProfile)
            }
        }
        
        func removeProfile(at index: Int) {
            if !dataStore.profiles.isEmpty {
                dataStore.profiles.remove(at: index)
                
            }
        }
        
        func renameProfile(newName: String, index: Int) {
            let newProfile = DataStore.Profile(name: newName)
            if !dataStore.profiles.contains(where: { $0.name == newProfile.name }) {
                dataStore.profiles[index].name = newName
            }
        }
        
        func getProfiles() -> [DataStore.Profile] {
            return DataStore.shared.profiles
        }
        
        func getProfile(at index: Int) -> DataStore.Profile  {
            DataStore.shared.profiles[index]
        }
        
        // Working with category
        
        func addCategory(profileIndex: Int, categoryName: String) {
            if !dataStore.profiles.isEmpty {
                let newCategory = DataStore.Category()
                newCategory.name = categoryName
                dataStore.profiles[profileIndex].categories.append(newCategory)
            }
        }
        
        func removeCategory(profileIndex: Int, at index: Int) {
            if !dataStore.profiles[profileIndex].categories.isEmpty {
                dataStore.profiles[profileIndex].categories.remove(at: index)
            }
        }
        
        func renameCategory(profileIndex: Int, index: Int, newName: String) {
            dataStore.profiles[profileIndex].categories[index].name = newName
        }
        
        func getCategory(profileIndex: Int, categoryIndex: Int) -> DataStore.Category {
            return dataStore.profiles[profileIndex].categories[categoryIndex]
        }
        
        func getCategories(profileIndex: Int) -> [DataStore.Category] {
            return dataStore.profiles[profileIndex].categories
        }
        
        // Working with tasks
        
        func addTask(profileIndex: Int, categoryIndex: Int, newDescription: String, completion: (() -> ())? = nil) {
            let newTask = DataStore.Task()
            
            newTask.text = newDescription
            dataStore.profiles[profileIndex].categories[categoryIndex].tasks.append(newTask)
            
            completion?()
        }

        
        func removeTask(profileIndex: Int, categoryIndex: Int, removeTaskIndex: Int) {
            let category = dataStore.profiles[profileIndex].categories[categoryIndex]
            
            if !category.tasks.isEmpty {
                category.tasks.remove(at: removeTaskIndex)
            }
        }
        
       
        func getTasks(profileIndex: Int, categoryIndex: Int) -> [DataStore.Task] {
            return dataStore.profiles[profileIndex].categories[categoryIndex].tasks
        }
        
        func getTask(profileIndex: Int, categoryIndex: Int, taskIndex: Int) -> DataStore.Task {
             dataStore.profiles[profileIndex].categories[categoryIndex].tasks[taskIndex]
        }
    }
        //MARK: Data Generation
        
        static func genData() -> DataStore {
            let dataStore = DataStore.shared
            
            // Создание профилей
            for profileIndex in 1...10 {
                let profile = Profile(name: "Profile \(profileIndex)")
                
                // Создание категорий
                for categoryIndex in 1...10 {
                    let category = Category()
                    category.name = "Category \(categoryIndex)"
                    
                    // Создание задач
                    for taskIndex in 1...10 {
                        let task = Task()
                        task.text = "Task \(taskIndex) in Category \(categoryIndex) of Profile \(profileIndex)"
                        task.isReady = Bool.random()
                        
                        category.tasks.append(task)
                    }
                    profile.categories.append(category)
                }
                dataStore.profiles.append(profile)
            }
            return dataStore
        }
        private init() {}
    }


//final class DataStore {
//    static let shared = DataStore()
//    var profiles: [Profile] = []
//    
//    class Profile {
//        var name: String
//        var categories: [Category] = []
//        
//        init(name: String) {
//            self.name = name
//        }
//    }
//    
//    class Category {
//        var name: String = ""
//        var tasks: [Task] = []
//    }
//    
//    class Task {
//        var text: String = ""
//        var ready: Bool = false
//    }
//    
//
//    
//    // MARK: Manager Data
//    
//    final class Manager {
//        var dataStore = DataStore.shared
//
//        func addProfile(name: String) {
//            let newProfile = DataStore.Profile(name: name)
//            
//            if !dataStore.profiles.contains(where: { $0.name == newProfile.name }) {
//                dataStore.profiles.append(newProfile)
//            }
//        }
//        
//        func removeProfile(at index: Int) {
//            if !dataStore.profiles.isEmpty {
//                dataStore.profiles.remove(at: index)
//                
//            }
//        }
//        
//        func renameProfile(newName: String, index: Int) {
//            let newProfile = DataStore.Profile(name: newName)
//            if !dataStore.profiles.contains(where: { $0.name == newProfile.name }) {
//                dataStore.profiles[index].name = newName
//            }
//        }
//        
//        func getProfiles() -> [DataStore.Profile] {
//            return DataStore.shared.profiles
//        }
//        
//        func getProfile(at index: Int) -> DataStore.Profile  {
//            DataStore.shared.profiles[index]
//            }
//        
//        func getCountProfiles() -> Int {
//            return DataStore.shared.profiles.count
//        }
//        
//        // Working with category
//        
//        func addCategory(profileIndex: Int, categoryName: String) {
//            if !dataStore.profiles.isEmpty {
//                let newCategory = DataStore.Category()
//                newCategory.name = categoryName
//                dataStore.profiles[profileIndex].categories.append(newCategory)
//            }
//        }
//        
//        func removeCategory(profileIndex: Int, at index: Int) {
//            if !dataStore.profiles[profileIndex].categories.isEmpty {
//                dataStore.profiles[profileIndex].categories.remove(at: index)
//            }
//        }
//        
//        func renameCategory(profileIndex: Int, index: Int, newName: String) {
//                dataStore.profiles[profileIndex].categories[index].name = newName
//        }
//        
//        func getNameCategory(profileIndex: Int, categoryIndex: Int) -> String {
//            return dataStore.profiles[profileIndex].categories[categoryIndex].name
//        }
//        
//        func getCountCategories(profileIndex: Int) -> Int {
//            return dataStore.profiles[profileIndex].categories.count
//        }
//        
//        // Working with tasks
//        
//        func addTask(profileIndex: Int, categoryIndex: Int, newDescription: String)  {
//            let newTask = DataStore.Task()
//            
//            newTask.text = newDescription
//                dataStore.profiles[profileIndex].categories[categoryIndex].tasks.append(newTask)
//        }
//        
//        func removeTask(profileIndex: Int, categoryIndex: Int, removeTaskIndex: Int) {
//            let category = dataStore.profiles[profileIndex].categories[categoryIndex]
//            
//            if !category.tasks.isEmpty {
//                category.tasks.remove(at: removeTaskIndex)
//            }
//        }
//        
//        func changeTaskDescription(profileIndex: Int, categoryIndex: Int, taskIndex: Int, newDescription: String)  {
//                dataStore.profiles[profileIndex].categories[categoryIndex].tasks[taskIndex].text = newDescription
//        }
//        
//        func getTasks(profileIndex: Int, categoryIndex: Int) -> [DataStore.Task] {
//            return dataStore.profiles[profileIndex].categories[categoryIndex].tasks
//        }
//        
//        func getCountTasks(profileIndex: Int, categoryIndex: Int) -> Int {
//             dataStore.profiles[profileIndex].categories[categoryIndex].tasks.count
//        }
//    }
//    
//    //MARK: Data Generation
//    
//    static func genData() -> DataStore {
//        let dataStore = DataStore.shared
//        
//        // Создание профилей
//        for profileIndex in 1...10 {
//            let profile = Profile(name: "Profile \(profileIndex)")
//            
//            // Создание категорий
//            for categoryIndex in 1...10 {
//                let category = Category()
//                category.name = "Category \(categoryIndex)"
//                
//                // Создание задач
//                for taskIndex in 1...10 {
//                    let task = Task()
//                    task.text = "Task \(taskIndex) in Category \(categoryIndex) of Profile \(profileIndex)"
//                    task.ready = Bool.random()
//                    
//                    category.tasks.append(task)
//                }
//                profile.categories.append(category)
//            }
//            dataStore.profiles.append(profile)
//        }
//        return dataStore
//    }
//    private init() {}
//}
