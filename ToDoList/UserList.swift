struct UserList {
    
    var name: String
    var categories: [Category]
    
    struct Category {
        var name: String
        var tasks: [String]
    }
    
    static func getUserList() -> [UserList] {
        
        var userLists: [UserList] = []
        let dataStore = DataStore.shared
        
        for name in dataStore.names {
            var userCategories: [Category] = []
           
            for  categoryName in dataStore.categories{
                var userTasks: [String] = []
                
                    for task in dataStore.tasks {
                        userTasks.append(task)
                    }
                
                let category = Category(name: categoryName, tasks: userTasks)
                userCategories.append(category)
            }
            
            let userList = UserList(name: name, categories: userCategories)
            userLists.append(userList)
        }
        
        return userLists
    }
    
}

