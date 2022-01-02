# SwiftUITodoList
Implemented a ToDo List using MongoDB Realm with SwiftUI

https://user-images.githubusercontent.com/66363530/147812725-8000b958-f932-415f-bb53-7c8373841b5a.MP4

## Motivation 
Previsouly used other databases such as User Defaults and Firestore on different project and wated to explore MongoDB Realm as a different alternative. Built this simple app to test this database and further explore SwiftUI. 

## Description 
This app is a simple to-do app where users add different tasks they need to complete. It implements CRUD(Create, Read, Update, and Delete) operations and it saves the tasks on scalable, secure, and offline first database called MongoDB Realm(version 10.10.0).Users can tap on the specific task to indicate whether they have finished their tasks or they can swipe the cell from right to left to completely delete the task from the database. They can also add new tasks by tapping the + button on the lower right part of the app. 

## How to Run 
Connect your device to the program and run it. You can also select a device and run the program. The main folder is called Content View.

## What I Learned 
While building this Application I learned a couple of things.
1. Calling Sheet Presentation views: It is used to present a new view over an existing one, while still allowing users to drag down to dismiss the new view when they are ready.  
```swift

struct ContentView: View {
    @StateObject var realmManager = RealmManager()
    @State private var showAddTaskView = false
    
    
    var body: some View {
        ZStack(alignment: .bottomTrailing){
            TaskView()
                .environmentObject(realmManager)
            
            SmallAddButton()
                .padding()
                .onTapGesture {
                    showAddTaskView.toggle()
                }
            
        }
        .sheet(isPresented: $showAddTaskView){
            AddTaskView()
                .environmentObject(realmManager)
            
        }
        .frame(maxWidth:.infinity, maxHeight: .infinity,alignment: .bottom)
        .background(Color(hue: 0.086, saturation: 0.141, brightness: 0.972))
    }
}

```

2. Dismiss a sheet View using an @Enviroment variable 

```swift
struct SheetView: View {
    @Environment(\.dismiss) var dismiss

    var body: some View {
        Button("Press to dismiss") {
            dismiss()
        }
        .font(.title)
        .padding()
        .background(Color.black)
    }
}

```

3. Data Persistence Using MonogDB and implementing CRUD: Allows for users to create, run, update, and delete data from database 
```swift
import Foundation
import RealmSwift

class RealmManager : ObservableObject{
    
    private(set) var localRealm: Realm?
    @Published private(set) var tasks: [Task] = []
    
    init(){
        openRealm()
        getTask()
    }
    
    func openRealm(){
        do{
            let config = Realm.Configuration(schemaVersion: 1)
            Realm.Configuration.defaultConfiguration = config
            
            localRealm = try Realm()
        }catch{
            print("Error Opening Realm")
        }
    }
    
    func addTask(taskTitle: String){
        if let localRealm = localRealm {
            do{
                try localRealm.write{
                    let newTask = Task(value: ["title":taskTitle, "completed":false])
                    localRealm.add(newTask)
                    getTask()
                    print("Added new task to Realm \(newTask)")
                }
            }catch{
                print("Error Adding task \(taskTitle) from Realm: \(error)")
            }
        }
    }
    
    func getTask(){
        if let localRealm = localRealm{
            let allTasks = localRealm.objects(Task.self).sorted(byKeyPath: "completed")
            tasks = []
            allTasks.forEach{task in
                tasks.append(task)
                
            }
            
        }
    }
    
    func updateTask(id:ObjectId, completed: Bool){
        if let localRealm = localRealm {
            do{
               let taskToUpdate =  localRealm.objects(Task.self).filter(NSPredicate(format: "id == %@",id))
                guard !taskToUpdate.isEmpty else{return}
                
                try localRealm.write{
                    taskToUpdate[0].completed = completed
                    getTask()
                    print("Updated taks Compled with id \(id). Completed status \(completed)")
                }
                
            }catch{
                print("Error updating task \(id) from Realm: \(error)")
            }
        }
    }
    
    func deleteTask(id:ObjectId){
        if let localRealm = localRealm {
            do{
                let taskToDelete =  localRealm.objects(Task.self).filter(NSPredicate(format: "id == %@",id))
                guard !taskToDelete.isEmpty else{return}
                
                try localRealm.write{
                    localRealm.delete(taskToDelete)
                    getTask()
                    print("Deleted Task with id \(id)")
                }
            }catch{
                print("Error Deleting task \(id) from Realm: \(error)")
                
            }
        }
    }
}

```
4. Using private(set) variables: only allows you to set and make changes to this variable within the class it is called in 

```swift
import Foundation
import RealmSwift

class RealmManager : ObservableObject{
    
    private(set) var localRealm: Realm?
    
 ....

```

5. @Persisted keyword and Schema: Schemas are models that each object should follow. Each variable will have to be implemented with the @Persisted Property wrapper so that it can identofy as keys to the Realm. 


```swift
import Foundation
import RealmSwift

class Task: Object, ObjectKeyIdentifiable{
    @Persisted(primaryKey: true) var id: ObjectId
    @Persisted var title = ""
    @Persisted var completed = false
}

```




6. implementing tap Genstures
```swift
Text("Hello, World!")
    .onTapGesture(count: 2) {
        print("Double tapped!")
    }
```

7. implenting swipe Gestures
```swift
     List{
        ForEach(realmManager.tasks, id:\.id){ task in
            if !task.isInvalidated{
                TaskRow(completed: task.completed, task: task.title)
                    .onTapGesture {
                        realmManager.updateTask(id: task.id, completed: !task.completed)
                    }
                    .swipeActions(edge: .trailing){
                        Button(role:.destructive){
                            realmManager.deleteTask(id: task.id)
                        }label:{
                            Label("Delete", systemImage: "trash")
                        }

                    }
            }


        }
        .listRowSeparator(.hidden)
                
      }
```
