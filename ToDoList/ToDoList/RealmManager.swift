//
//  RealmManager.swift
//  ToDoList
//
//  Created by Elizabeth Yu on 2021/12/30.
//

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
