# SwiftUITodoList
Implemented a ToDo List using MongoDB Realm with SwiftUI

<p align="center">
    <source src = "https://user-images.githubusercontent.com/66363530/147811335-bf417458-79cf-490f-9230-6c7262d016b4.MP4" type "video/mp4">
</p>


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




