//
//  Constants.swift
//  ToDo
//
//  Created by Jordan  on 10/24/18.
//  Copyright © 2018 Jordan Katzen. All rights reserved.
//

import Foundation

struct DateConstants {
    static let oneDayAheadInSeconds: Double = 24 * 60 * 60
    static let sevenDaysAheadInSeconds: Double = 24 * 60 * 60 * 7
    static let todayString: String = "Today"
    static let tomorrowString: String = "Tomorrow"
}

struct NewToDoCells {
    static let titleCell: IndexPath = [0,0]
    static let dueDateCell: IndexPath = [0,1]
    static let notesCell: IndexPath = [2,0]
}

struct DiskStorageConstants {
    static let DocumentsDirectory =
        FileManager.default.urls(for: .documentDirectory,
                                 in: .userDomainMask).first!
    static let ArchiveURL =
        DocumentsDirectory.appendingPathComponent("todos")
            .appendingPathExtension("plist")
}

struct ColorConstants {
    let purpleButtons = "#4563f9"
}

