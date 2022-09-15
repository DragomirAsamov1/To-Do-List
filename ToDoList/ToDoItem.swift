//
//  ToDoItemModel.swift
//  ToDoList
//
//  Created by Darren Asamov on 10/03/2022.
//

import Foundation

struct ToDoItem {
    
    var name: String
    var details: String
    var completionDate: Date
    var startDate: Date
    var isComplete: Bool
    
    init(name: String, details: String, completionDate: Date, startDate: Date, isComplete: Bool) {
        self.name = name
        self.details = details
        self.completionDate = completionDate
        self.startDate = Date()
        self.isComplete = false
    }
}
