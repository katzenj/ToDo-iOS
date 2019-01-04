//
//  NewToDoViewController.swift
//  ToDo
//
//  Created by Jordan  on 10/24/18.
//  Copyright © 2018 Jordan Katzen. All rights reserved.
//

import UIKit

class ToDoViewController: UITableViewController {

    var todo: ToDo?
    var pickerIsHidden = true
    
    @IBOutlet var titleTextField: UITextField!
    @IBOutlet var isCompleteButton: UIButton!
    @IBOutlet var dueTimeLabel: UILabel!
    @IBOutlet var dueDateLabel: UILabel!
    @IBOutlet var dueDatePickerView: UIDatePicker!
    @IBOutlet var notesTextView: UITextView!
    @IBOutlet var saveButton: UIBarButtonItem!
    @IBOutlet weak var prioritySegmentedControl: UISegmentedControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let todo = todo {
            navigationItem.title = "To Do"
            titleTextField.text = todo.title
            isCompleteButton.isSelected = todo.isComplete
            dueDatePickerView.date = todo.dueDate
            notesTextView.text = todo.notes
            
            let textColor = hexStringToUIColor(hex: "#4563f9")
            dueTimeLabel.textColor = textColor
            dueDateLabel.textColor = textColor
        } else {
            dueDatePickerView.date = Date().addingTimeInterval(DateConstants.oneDayAheadInSeconds)
        }
        
        updateSaveButtonState()
        updateDueDateLabels(date: dueDatePickerView.date)
    }
    
    /**
     Returns the proper height of cells. The Due Date cell should be expanded if we're using the picker;
     the notes cell should be expanded to allow for long notes; every other cell should be of regular height.
     */
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let normalHeight = CGFloat(60)
        let expandedHeight = CGFloat(200)
        
        switch(indexPath) {
        case NewToDoCells.dueDateCell: // Due Date Cell
            return pickerIsHidden ? normalHeight : expandedHeight
        case NewToDoCells.notesCell: // Notes Cell
            return expandedHeight
        default:
            return normalHeight
        }
    }
    
    /**
     Determines if the DueDateCell has been tapped, in which case, the row needs to expand to show the date picker.
     */
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        switch(indexPath) {
        case NewToDoCells.dueDateCell:
            pickerIsHidden = !pickerIsHidden
            
            tableView.beginUpdates()
            tableView.endUpdates()
            
        default:
            break
        }
    }
    
    func updateDueDateLabels(date: Date) {
        let today = Date()
        let calendar = Calendar.current
        let components = Set<Calendar.Component>([Calendar.Component.day, Calendar.Component.month])
        
        var dateLabelString: String
        
        // Check if the date is today or tomorrow.
        if calendar.isDateInToday(date) {
            dateLabelString = DateConstants.todayString
        } else if calendar.isDateInTomorrow(date) {
            dateLabelString = DateConstants.tomorrowString
        } else {
            // If not overdue, today, or tomorrow, check if it's in the next seven days to display the day,
            // otherwise display the formatted date.
            let inNextWeek = date < today.addingTimeInterval(DateConstants.sevenDaysAheadInSeconds) && date > Date()
            
            dateLabelString = inNextWeek ? ToDo.weekDueDateFormatter.string(from: date) : ToDo.dayMonthFormatter.string(from: date)
        }
        
        dueDateLabel.text = dateLabelString
        dueTimeLabel.text = ToDo.dayOfFormatter.string(from: date)
    }
    
    func updateSaveButtonState() {
        let text = titleTextField.text ?? ""
        saveButton.isEnabled = !text.isEmpty
    }
    
    @IBAction func datePickerChanged(_ sender: UIDatePicker) {
        updateDueDateLabels(date: dueDatePickerView.date)
    }
    
    @IBAction func textEditingChanged(_ sender: Any) {
        updateSaveButtonState()
    }
    
    @IBAction func returnTapped(_ sender: Any) {
        titleTextField.resignFirstResponder()
    }
    
    @IBAction func isCompleteButtonTapped(_ sender: Any) {
        isCompleteButton.isSelected = !isCompleteButton.isSelected
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        
        guard segue.identifier == "saveUnwind" else { return }
        
        let title = titleTextField.text!
        let isComplete = isCompleteButton.isSelected
        let dueDate = dueDatePickerView.date
        let notes = notesTextView.text
        var priority: Priority
        switch prioritySegmentedControl.selectedSegmentIndex {
        case 1:
            priority = .Low
            break
        case 2:
            priority = .Medium
            break
        case 3:
            priority = .High
            break
        default:
            priority = .Unset
        }
        
        todo = ToDo(title: title, isComplete: isComplete, dueDate: dueDate, remindDate: dueDate, notes: notes, priority: priority)
    }
}
