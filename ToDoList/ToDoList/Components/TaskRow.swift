//
//  TaskRow.swift
//  ToDoList
//
//  Created by Elizabeth Yu on 2021/12/30.
//

import SwiftUI

struct TaskRow: View {
    var completed: Bool
    var task: String
    
    var body: some View {
        HStack(spacing: 20){
            Image(systemName: completed ? "checkmark.circle" : "circle")
            Text(task)
        }
    }
}

struct TaskRow_Previews: PreviewProvider {
    static var previews: some View {
        TaskRow(completed: true, task: "Laundry")
    }
}
