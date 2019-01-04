//
//  Priorities.swift
//  ToDo
//
//  Created by Jordan  on 11/21/18.
//  Copyright © 2018 Jordan Katzen. All rights reserved.
//

import UIKit

enum Priority: String, Codable {
    case Unset, Low, Medium, High
}

func getPriorityColor(priority: Priority) -> UIColor? {
    switch priority {
    case .Low:
        return .yellow
    case .Medium:
        return .orange
    case .High:
        return .red
    default:
        return nil
    }
}
