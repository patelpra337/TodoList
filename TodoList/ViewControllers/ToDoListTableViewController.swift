//
//  ToDoListTableViewController.swift
//  TodoList
//
//  Created by patelpra on 6/10/19.
//  Copyright © 2019 Pravin Patel. All rights reserved.
//

import UIKit

class TodoListTableViewController: UITableViewController {
    
    // MARK: - Properties
    
    private let todoController = TodoController()
    let pushMethod: PushMethod = .put
    
    @IBOutlet weak var textField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchTodos()
    }
    
    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todoController.todos.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TodoCell", for: indexPath)
        
        // Get appropriate todo from datasource and configure cell
        let todo = self.todoController.todos[indexPath.row]
        
        cell.textLabel?.text = todo.title
        
        return cell
    }
    
//    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
//        let todo = todoController.todos[indexPath.row]
//        // configure swipe action
//    }
    
    @IBAction func saveButtonTapped(_ sender: UIButton) {
        // get todo text from textfield
        guard let title = self.textField.text else {
            return
        }
        
        // create todo
        let todo = todoController.createTodo(with: title)
        
        // Send todo to Firebase
        todoController.push(todo: todo, using: self.pushMethod) { (error) in
        if let error = error {
            NSLog("\(error)")
        }
            self.fetchTodos()
    }
}
    
    func fetchTodos() {
        // fetch todos from Firebase and display them
        self.todoController.fetchTodos { (error) in
            if let error = error {
                NSLog("\(error)")
            } else {
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
        }
    }
}
