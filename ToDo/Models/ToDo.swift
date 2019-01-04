//
//  ToDo.swift
//  ToDo
//
//  Created by Jordan  on 10/24/18.
//  Copyright © 2018 Jordan Katzen. All rights reserved.
//

import Foundation

struct ToDo: Codable, Equatable {
    var title: String
    var isComplete: Bool
    var dueDate: Date
    var remindDate: Date?
    var notes: String?
    var priority: Priority?
    
    /**
     Load the ToDos saved to disk.
     */
    static func loadToDos() -> [ToDo]? {
        guard let codedTodos = try? Data(contentsOf: DiskStorageConstants.ArchiveURL)
            else { return nil }
        let propertyListDecoder = PropertyListDecoder()
        return try? propertyListDecoder.decode(Array<ToDo>.self, from: codedTodos)
    }
    
    /**
     Save our todos to disk
     */
    static func saveToDos(_ todos: [ToDo]) {
        let propertyListEncoder = PropertyListEncoder()
        let codedTodos = try? propertyListEncoder.encode(todos)
        try? codedTodos?.write(to: DiskStorageConstants.ArchiveURL, options: .noFileProtection)
    }
    
    // Formatter for when date is further than 7 days out or has already passed.
    static let regularDueDateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "EE, MMM d"
        return formatter
    }()
    
    // Formatter for a due date within the next week.
    static let weekDueDateFormatter: DateFormatter = {
       let formatter = DateFormatter()
        formatter.dateFormat = "EEEE"
        return formatter
    }()
    
    // Formatter for a due date due today.
    static let dayOfFormatter: DateFormatter = {
       let formatter = DateFormatter()
        formatter.dateFormat = "h:mm a"
        return formatter
    }()
    
    // Formatter for date picker.
    static let datePickerFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "EE, MMM d, h:mm a"
        return formatter
    }()
    
    static let dayMonthFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM d"
        return formatter
    }()
    
    static func setDueDateLabel(dueDate: Date) -> String {
        let today = Date()
        let calendar = Calendar.current
        
        var formatter: DateFormatter
        
        // Check if the date is today or tomorrow.
        if calendar.isDateInToday(dueDate) {
            return dayOfFormatter.string(from: dueDate)
        } else if calendar.isDateInTomorrow(dueDate) {
            return DateConstants.tomorrowString
        }
        
        // If not overdue, today, or tomorrow, check if it's in the next seven days to display the day,
        // otherwise display the formatted date.
        if dueDate < today.addingTimeInterval(DateConstants.sevenDaysAheadInSeconds) && dueDate > Date(){
            formatter = ToDo.weekDueDateFormatter
        } else {
            formatter = ToDo.regularDueDateFormatter
        }
        return formatter.string(from: dueDate)
    }
}
