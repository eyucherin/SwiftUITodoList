//
//  TaskView.swift
//  ToDoList
//
//  Created by Elizabeth Yu on 2021/12/30.
//

import SwiftUI

struct TaskView: View {
    
    @EnvironmentObject var realmManager: RealmManager
    
    var body: some View {
        VStack( spacing: 10){
            Text("My Tasks")
                .font(.system(size: 30))
                .fontWeight(.bold)
                .padding( )
                .frame(maxWidth:.infinity, alignment: .leading)
                .foregroundColor(Color.black)
           
    
            
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
            .onAppear{
                UITableView.appearance().backgroundColor = UIColor.clear
                UITableViewCell.appearance().backgroundColor = UIColor.clear
            }
            
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color(hue: 0.086, saturation: 0.141, brightness: 0.972))
        
        
    }
}

struct TaskView_Previews: PreviewProvider {
    static var previews: some View {
        TaskView()
            .environmentObject(RealmManager())
    }
}
