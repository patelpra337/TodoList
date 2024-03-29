//
//  ToDoController.swift
//  TodoList
//
//  Created by patelpra on 6/10/19.
//  Copyright © 2019 Pravin Patel. All rights reserved.
//

import Foundation

enum PushMethod: String {
    case post = "POST"
    case put = "PUT"
}

class TodoController {
    
    private let baseURL = URL(string: "https://put-and-post.firebaseio.com/")!
    
    // MARK: Properties
    private(set) var todos: [Todo] = []
    
    func createTodo(with title: String) -> Todo {
        let todo = Todo(title: title)
        return todo
    }
    
    func push(todo: Todo, using method: PushMethod, completion: @escaping (Error?) -> Void) {
        var url = self.baseURL
        
        if method == .put {
            url.appendPathComponent(todo.identifier)
        }
        
        url.appendPathExtension("json")
        
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        
        // encode data into JSON
        do {
            let encoder = JSONEncoder()
            request.httpBody = try encoder.encode(todo)
        } catch {
            NSLog("\(error)")
            completion(error)
            return
        }
        
        // send JSON to Firebase
        URLSession.shared.dataTask(with: request) { (_, _, error) in
            if let error = error {
                NSLog("\(error)")
                completion(error)
                return
            }
            completion(nil)
        }.resume() // Important to include
    
    }
    
    func fetchTodos(completion: @escaping (Error?) -> Void) {
        let url = baseURL.appendingPathExtension("json")
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "GET"
        
        // fetch data from Firebase
        
        URLSession.shared.dataTask(with: url) { (data, _, error) in
            if let error = error {
                completion(error)
                return
            }
            
            guard let data = data else {
                completion(NSError())
                return
            }            
            
            do {
                let jsonDecoder = JSONDecoder()
                let decodedDictionary = try jsonDecoder.decode([String : Todo].self, from: data)
                let todos = Array(decodedDictionary.values)
                self.todos = todos
            } catch {
                NSLog("Error decoding received data: \(error)")
                completion(error)
                return
            }
        }.resume()
    }
}
