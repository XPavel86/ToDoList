import Foundation

// MARK: Data store
import Foundation

// MARK: Data store
class DataStoreNew: Decodable {
    static let shared = DataStoreNew()
    var profiles: [Profile] = []

    class Profile: Decodable {
        var name: String
        var categories: [Category] = []

        init(profile: String) {
            self.name = profile
        }
    }

    class Category: Decodable {
        var name: String = ""
        var tasks: [Task] = []
    }

    class Task: Decodable {
        var description: String = ""
        var ready: Bool = false
    }

    private init() {
       
    }
}


// MARK: Manager data store
class ProfileManager {
    private let dataStore = DataStoreNew.shared
    
    static let shared = ProfileManager()
    private init() {}
    
    // Working with profile
    
    func addProfile(name: String) -> Bool {
        let newProfile = DataStoreNew.Profile(profile: name)
        if !dataStore.profiles.contains(where: { $0.name == newProfile.name }) {
            dataStore.profiles.append(newProfile)
            return true
        }
        return false
    }
    
    func removeProfile(at index: Int) -> Bool {
        if !dataStore.profiles.isEmpty  {
            dataStore.profiles.remove(at: index)
            return true
        }
        return false
    }
    
    func renameProfile(newName: String, index: Int) -> Bool {
        let newProfile = DataStoreNew.Profile(profile: newName)
        if !dataStore.profiles.contains(where: { $0.name == newProfile.name }) {
            dataStore.profiles[index].name = newName
            return true
        }
        return false
    }
    
    func getProfiles() -> [DataStoreNew.Profile] {
        return dataStore.profiles
    }
    
    // Working with category
    func addCategory(profileIndex: Int, categoryName: String) -> Bool {
        if !dataStore.profiles.isEmpty
        {
            let newCategory = DataStoreNew.Category()
            newCategory.name = categoryName
            dataStore.profiles[profileIndex].categories.append(newCategory)
            
            return true
        }
        return false
    }
    
    func removeCategory(profileIndex: Int, at index: Int) -> Bool {
        if !dataStore.profiles[profileIndex].categories.isEmpty {
            dataStore.profiles[profileIndex].categories.remove(at: index)
            
            return true
        }
        return false
    }
    
    func renameCategory(profileIndex: Int, index: Int, newName: String) -> Bool {
        if !dataStore.profiles[profileIndex].categories.contains(where: { $0.name == newName }) {
            dataStore.profiles[profileIndex].categories[index].name = newName
            
            return true
        }
        return false
    }
    
    func getCategories(profileIndex: Int) -> [DataStoreNew.Category] {
        return dataStore.profiles[profileIndex].categories
    }

    // Working with tasks
    
    func addTask(profileIndex: Int, categoryIndex: Int, newDescription: String) -> Bool {
        let category = dataStore.profiles[profileIndex].categories[categoryIndex]
        let newTask = DataStoreNew.Task()
        
        newTask.description = newDescription
        
        if !category.tasks.contains(where: { $0.description == newDescription }) {
            dataStore.profiles[profileIndex].categories[categoryIndex].tasks.append(newTask)
            return true
        }
        return false
    }
    
    func removeTask(profileIndex: Int, categoryIndex: Int, removeTaskIndex: Int) -> Bool {
        let category = dataStore.profiles[profileIndex].categories[categoryIndex]
        
        if !category.tasks.isEmpty {
            category.tasks.remove(at: removeTaskIndex)
            
            return true
        }
        return false
    }

    func changeTaskDescription(profileIndex: Int, categoryIndex: Int, taskIndex: Int, newDescription: String) -> Bool {
        let category = dataStore.profiles[profileIndex].categories[categoryIndex]
        
        if !category.tasks.contains(where: { $0.description == newDescription }) {
            dataStore.profiles[profileIndex].categories[categoryIndex].tasks[taskIndex].description = newDescription
            return true
        }
        return false
    }
    
    func getTasks(profileIndex: Int, taskIndex: Int) -> [DataStoreNew.Task] {
        return dataStore.profiles[profileIndex].categories[taskIndex].tasks
    }
    
   
    
}
