//
//  AddTaskView.swift
//  ToDoList
//
//  Created by Elizabeth Yu on 2021/12/30.
//

import SwiftUI

struct AddTaskView: View {
    
    @EnvironmentObject var realmManager: RealmManager
    @State private var title : String = ""
    @Environment(\.dismiss) var dissmiss
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20){
            
            Text("Create New Task")
                .font(.title2)
                .fontWeight(.bold)
                .frame(maxWidth:.infinity , alignment: .leading)
                .foregroundColor(Color.black)
                
            
            
            TextField("Enter your task here",text: $title)
                .padding(.all,20)
                .background(Color.white)
                .cornerRadius(25)
            
            
            Button{
                if title != ""{
                    realmManager.addTask(taskTitle: title)
                }
                dissmiss()
             
            }label: {
                Text("Add Task")
                    .foregroundColor(.white)
                    .padding()
                    .padding(.horizontal)
                    .background(Color(hue: 0.328, saturation: 0.796, brightness: 0.408))
                    .cornerRadius(30)
            }
          
            
            Spacer()

            
        }
        .padding(.top, 40)
        .padding(.horizontal)
        .background(Color(hue: 0.086, saturation: 0.141, brightness: 0.972))
      
    }
}

struct AddTaskView_Previews: PreviewProvider {
    static var previews: some View {
        AddTaskView()
            .environmentObject(RealmManager())
    }
}
