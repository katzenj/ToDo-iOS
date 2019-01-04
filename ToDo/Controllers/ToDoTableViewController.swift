//
//  ToDoTableViewController.swift
//  ToDo
//
//  Created by Jordan  on 10/24/18.
//  Copyright © 2018 Jordan Katzen. All rights reserved.
//

import UIKit

class ToDoTableViewController: UITableViewController, ToDoCellDelegate {
    
    var todos = [ToDo]()
    private var addButton = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.leftBarButtonItem = editButtonItem
        navigationItem.leftBarButtonItem?.tintColor = hexStringToUIColor(hex: "#5652F9")
        
        tableView.tableFooterView = UIView(frame: .zero)
        tableView.rowHeight = CGFloat(60)
        
        if let savedTodos = ToDo.loadToDos() {
            todos = savedTodos
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        createAddButton()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        if self.addButton.superview != nil {
            DispatchQueue.main.async {
                self.addButton.removeFromSuperview()
                
            }
        }
    }

    /**
     Returns the number of rows to load.
     */
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todos.count
    }

    /**
     Does the setup for each ToDo, setting the labels, colors, etc.
     */
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoCellIdentifier")
            as? ToDoTableViewCell else {
            fatalError("Could not dequeue a cell")
        }
        cell.delegate = self
        let todo = todos[indexPath.row]
        cell.titleLabel?.text = todo.title
        cell.isCompleteButton.isSelected = todo.isComplete
        cell.dueDateLabel?.text = ToDo.setDueDateLabel(dueDate: todo.dueDate)
        
        if todo.dueDate < Date() && !todo.isComplete {
            cell.dueDateLabel?.textColor = .red
        } else if todo.isComplete {
            cell.titleLabel.textColor = .gray
            cell.dueDateLabel.textColor = .gray
        } else {
            cell.dueDateLabel?.textColor = hexStringToUIColor(hex: "#5652F9")
        }
        
        
        return cell
    }
    
    /**
     Enables the ability to delete ToDos with the edit button.
     */
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    /**
     Implements re-ordering for the todo list.
    */
    override func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        let todo = self.todos[sourceIndexPath.row]
        todos.remove(at: sourceIndexPath.row)
        todos.insert(todo, at: destinationIndexPath.row)
    }
    
    /**
     Enables the ability to reorder the todos list.
     */
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    /**
     Returns the possible swipe actions for a ToDo.
     */
    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let delete = UITableViewRowAction(style: .destructive, title: "Delete") { (action, indexPath)  in
            self.todos.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            ToDo.saveToDos(self.todos)
        }

        return [delete]
    }
    
    /**
     Marks a ToDo as complete and reloads the row to display the new styling.
     */
    func isCompleteButtonTapped(sender: ToDoTableViewCell) {
        if let indexPath = tableView.indexPath(for: sender) {
            var todo = todos[indexPath.row]
            todo.isComplete = !todo.isComplete
            todos[indexPath.row] = todo
            
            tableView.reloadRows(at: [indexPath], with: .automatic)
            ToDo.saveToDos(todos)
        }
    }
    
    /**
     When a user either cancels or saves their existing/new todo, this will rewind to the home screen
     and save the new/existing ToDo.
     */
    @IBAction func unwindToToDoList(segue: UIStoryboardSegue) {
        guard segue.identifier == "saveUnwind" || segue.identifier == "cancelUnwind" else { return }
        let sourceViewController = segue.source as! ToDoViewController
        
        if let todo = sourceViewController.todo {
            if let selectedIndexPath = tableView.indexPathForSelectedRow {
                todos[selectedIndexPath.row] = todo
                tableView.reloadRows(at: [selectedIndexPath], with: .none)
            } else {
                // Desired behavior is to have each todo be inserted at the top.
                let newIndexPath = IndexPath(row: 0, section: 0)
                todos.insert(todo, at: 0)
                tableView.insertRows(at: [newIndexPath], with: .automatic)
            }
        }
        ToDo.saveToDos(todos)
    }
    
    func createAddButton() {
        addButton = UIButton(type: .custom)
        addButton.translatesAutoresizingMaskIntoConstraints = false
        addButton.setImage(UIImage(named:"Add Button"), for: .normal)
        addButton.addTarget(self, action: #selector(addButtonClicked), for: UIControl.Event.touchUpInside)
        
        // Edit the UI of the main todos view to anchor the add button to the bottom right corner.
        DispatchQueue.main.async {
            if let keyWindow = UIApplication.shared.keyWindow {
                keyWindow.addSubview(self.addButton)
                NSLayoutConstraint.activate([
                    keyWindow.trailingAnchor.constraint(equalTo: self.addButton.trailingAnchor, constant: 30),
                    keyWindow.bottomAnchor.constraint(equalTo: self.addButton.bottomAnchor, constant: 30),
                    self.addButton.widthAnchor.constraint(equalToConstant: 88),
                    self.addButton.heightAnchor.constraint(equalToConstant: 88)])
            }
            
            self.addButton.layer.cornerRadius = 37.5
            self.addButton.layer.shadowColor = UIColor.black.cgColor
            self.addButton.layer.shadowOffset = CGSize(width: 0.0, height: 5.0)
            self.addButton.layer.masksToBounds = false
            self.addButton.layer.shadowRadius = 2.0
            self.addButton.layer.shadowOpacity = 0.1
        }
    }
    
    @IBAction func addButtonClicked(_ sender: UIButton) {
        self.performSegue(withIdentifier: "presentNewTodo", sender: self)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetails" {
            let todoViewController = segue.destination as! ToDoViewController
            let indexPath = tableView.indexPathForSelectedRow!
            let selectedTodo = todos[indexPath.row]
            todoViewController.todo = selectedTodo
        }
    }
    
}
