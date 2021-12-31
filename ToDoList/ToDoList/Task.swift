//
//  TAsk.swift
//  ToDoList
//
//  Created by Elizabeth Yu on 2021/12/30.
//

import Foundation
import RealmSwift

class Task: Object, ObjectKeyIdentifiable{
    @Persisted(primaryKey: true) var id: ObjectId
    @Persisted var title = ""
    @Persisted var completed = false
}
