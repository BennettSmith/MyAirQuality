
import SwiftUI

import Amplify
import AmplifyPlugins

struct ContentView: View {
    var body: some View {
        Text("Hello, world!")
            .padding()
            .onAppear {
                self.performOnAppear()
            }
    }
    
    func performOnAppear() {
        deleteItem()
    }
    
    func createItems() {
        let item1 = Todo(name: "Build iOS Application",
                         description: "Build an iOS application using Amplify")
        
        Amplify.DataStore.save(item1) { result in
            switch(result) {
            case .success(let savedItem):
                print("Saved item: \(savedItem.name)")
            case .failure(let error):
                print("Could not save item to datastore: \(error)")
            }
        }
        
        let item2 = Todo(name: "Finish quarterly taxes",
                         priority: .high,
                         description: "Taxes are due for the quarter next week")
        
        Amplify.DataStore.save(item2) { result in
            switch(result) {
            case .success(let savedItem):
                print("Saved item: \(savedItem.name)")
            case .failure(let error):
                print("Could not save item to datastore: \(error)")
            }
        }
    }
    
    func queryItems() {
        Amplify.DataStore.query(Todo.self,
                                where: Todo.keys.priority.eq(Priority.high)) { result in
            switch(result) {
            case .success(let todos):
                for todo in todos {
                    print("==== Todo ====")
                    print("Name: \(todo.name)")
                    if let description = todo.description {
                        print("Description: \(description)")
                    }
                    if let priority = todo.priority {
                        print("Priority: \(priority)")
                    }
                }
            case .failure(let error):
                print("Could not query DataStore: \(error)")
            }
        }
    }
    
    func updateItem() {
        Amplify.DataStore.query(Todo.self,
                                where: Todo.keys.name.eq("Finish quarterly taxes")) { result in
            switch(result) {
            case .success(let todos):
                guard todos.count == 1, var updatedTodo = todos.first else {
                    print("Did not find exactly one todo, bailing")
                    return
                }
                updatedTodo.name = "File quarterly taxes"
                Amplify.DataStore.save(updatedTodo) { result in
                    switch(result) {
                    case .success(let savedTodo):
                        print("Updated item: \(savedTodo.name)")
                    case .failure(let error):
                        print("Could not update data in Datastore: \(error)")
                    }
                }
            case .failure(let error):
                print("Could not query DataStore: \(error)")
            }
        }
    }
    
    func deleteItem() {
        Amplify.DataStore.query(Todo.self,
                                where: Todo.keys.name.eq("File quarterly taxes")) { result in
            switch(result) {
            case .success(let todos):
                guard todos.count == 1, let toDeleteTodo = todos.first else {
                    print("Did not find exactly one todo, bailing")
                    return
                }
                Amplify.DataStore.delete(toDeleteTodo) { result in
                    switch(result) {
                    case .success:
                        print("Deleted item: \(toDeleteTodo.name)")
                    case .failure(let error):
                        print("Could not update data in Datastore: \(error)")
                    }
                }
            case .failure(let error):
                print("Could not query DataStore: \(error)")
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
