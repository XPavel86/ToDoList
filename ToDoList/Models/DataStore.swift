//
//  model.swift
//  ToDoList
//
//  Created by Pavel Dolgopolov on 08.04.2024.
//

/* // MARK: Model Data

class DataStore {
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
        var description: String = ""
        var ready: Bool = false
    }
    
    // MARK: Manager Data
    
    final class Manager {
        var dataStore = DataStore.shared
        
        func addProfile(name: String) {
            let newProfile = DataStore.Profile(name: name)
            
            if !dataStore.profiles.contains(where: { $0.name == newProfile.name }) {
                dataStore.profiles.append(newProfile)
            }
            
            func removeProfile(at index: Int) {
                if !dataStore.profiles.isEmpty  {
                    dataStore.profiles.remove(at: index)
                }
                
                func renameProfile(newName: String, index: Int) {
                    let newProfile = DataStore.Profile(name: newName)
                    if !dataStore.profiles.contains(where: { $0.name == newProfile.name }) {
                        dataStore.profiles[index].name = newName
                    }
                }
                
                func getProfiles() -> [DataStore.Profile] {
                    // return dataStore.profiles.map { $0 } // Возвращаем копию массива профилей
                    return DataStore.shared.profiles
                }
                
                // Working with category
                func addCategory(profileIndex: Int, categoryName: String) {
                    if !dataStore.profiles.isEmpty
                    {
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
                    if !dataStore.profiles[profileIndex].categories.contains(where: { $0.name == newName }) {
                        dataStore.profiles[profileIndex].categories[index].name = newName
                    }
                }
                
                func getCategories(profileIndex: Int) -> [DataStore.Category] {
                    return dataStore.profiles[profileIndex].categories
                }
                
                // Working with tasks
                
                func addTask(profileIndex: Int, categoryIndex: Int, newDescription: String)  {
                    let category = dataStore.profiles[profileIndex].categories[categoryIndex]
                    let newTask = DataStore.Task()
                    
                    newTask.description = newDescription
                    
                    if !category.tasks.contains(where: { $0.description == newDescription }) {
                        dataStore.profiles[profileIndex].categories[categoryIndex].tasks.append(newTask)
                    }
                }
                
                func removeTask(profileIndex: Int, categoryIndex: Int, removeTaskIndex: Int) {
                    let category = dataStore.profiles[profileIndex].categories[categoryIndex]
                    
                    if !category.tasks.isEmpty {
                        category.tasks.remove(at: removeTaskIndex)
                    }
                }
                
                func changeTaskDescription(profileIndex: Int, categoryIndex: Int, taskIndex: Int, newDescription: String)  {
                    let category = dataStore.profiles[profileIndex].categories[categoryIndex]
                    
                    if !category.tasks.contains(where: { $0.description == newDescription }) {
                        dataStore.profiles[profileIndex].categories[categoryIndex].tasks[taskIndex].description = newDescription
                    }
                }
                
                func getTasks(profileIndex: Int, categoryIndex: Int) -> [DataStore.Task] {
                    return dataStore.profiles[profileIndex].categories[categoryIndex].tasks
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
                            task.description = "Task \(taskIndex) in Category \(categoryIndex) of Profile \(profileIndex)"
                            task.ready = Bool.random()
                            
                            category.tasks.append(task)
                        }
                        
                        profile.categories.append(category)
                    }
                    
                    dataStore.profiles.append(profile)
                }
                
                return dataStore
            }
 
        }
    }
    private init() {}
} */

class DataStore {
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
        var description: String = ""
        var ready: Bool = false
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
            if !dataStore.profiles[profileIndex].categories.contains(where: { $0.name == newName }) {
                dataStore.profiles[profileIndex].categories[index].name = newName
            }
        }
        
        func getCategories(profileIndex: Int) -> [DataStore.Category] {
            return dataStore.profiles[profileIndex].categories
        }
        
        // Working with tasks
        
        func addTask(profileIndex: Int, categoryIndex: Int, newDescription: String)  {
            let category = dataStore.profiles[profileIndex].categories[categoryIndex]
            let newTask = DataStore.Task()
            
            newTask.description = newDescription
            
            if !category.tasks.contains(where: { $0.description == newDescription }) {
                dataStore.profiles[profileIndex].categories[categoryIndex].tasks.append(newTask)
            }
        }
        
        func removeTask(profileIndex: Int, categoryIndex: Int, removeTaskIndex: Int) {
            let category = dataStore.profiles[profileIndex].categories[categoryIndex]
            
            if !category.tasks.isEmpty {
                category.tasks.remove(at: removeTaskIndex)
            }
        }
        
        func changeTaskDescription(profileIndex: Int, categoryIndex: Int, taskIndex: Int, newDescription: String)  {
            let category = dataStore.profiles[profileIndex].categories[categoryIndex]
            
            if !category.tasks.contains(where: { $0.description == newDescription }) {
                dataStore.profiles[profileIndex].categories[categoryIndex].tasks[taskIndex].description = newDescription
            }
        }
        
        func getTasks(profileIndex: Int, categoryIndex: Int) -> [DataStore.Task] {
            return dataStore.profiles[profileIndex].categories[categoryIndex].tasks
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
                    task.description = "Task \(taskIndex) in Category \(categoryIndex) of Profile \(profileIndex)"
                    task.ready = Bool.random()
                    
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

