//
//  ViewController.swift
//  ToDoList
//
//  Created by Darren Asamov on 10/03/2022.
//

import UIKit

protocol ToDoListDelegate {
    
    func update(task: ToDoItem, index: Int)
    
}

class ToDoListViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    var toDoItems = [ToDoItem]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.tableFooterView = UIView()
        title = "To Do List"
        
        NotificationCenter.default.addObserver(self, selector: #selector(addNewTask(_ :)), name: NSNotification.Name.init("com.todolistapp.addtask"), object: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        tableView.setEditing(false, animated: false)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "TaskDetailsSegue" {
            guard let destinationVC = segue.destination as? ToDoDetailsViewController else { return }
            
            guard let toDoTuple = sender as? (ToDoItem, Int) else { return }
            
            destinationVC.toDoItem = toDoTuple.0
            destinationVC.toDoIndex = toDoTuple.1
            destinationVC.delegate = self  
        }
    }

    @IBAction func editTapped(_ sender: UIBarButtonItem) {
        editTapped()
    }
    
    @objc func editTapped() {
        tableView.setEditing(!tableView.isEditing, animated: true)
        
        if tableView.isEditing {
            navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(editTapped(_:)))
        } else {
            navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: #selector(editTapped(_:)))
        }
    }
    
    @IBAction func addTapped(_ sender: UIBarButtonItem) {
        
        performSegue(withIdentifier: "AddTaskSegue", sender: nil)
        
    }
    
    @objc func addNewTask(_ notification: NSNotification) {
        var toDoItem: ToDoItem!
        
        if let task = notification.object as? ToDoItem {
            toDoItem = task
        } else {
            return
        }
        
        toDoItems.append(toDoItem)
        toDoItems.sort(by: {$0.completionDate > $1.completionDate})
        tableView.reloadData()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.init("com.todolistapp.addtask"), object: nil)
    }
}

extension ToDoListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let selectedItem = toDoItems[indexPath.row]
        
        let toDoTuple = (selectedItem, indexPath.row)
        
        performSegue(withIdentifier: "TaskDetailsSegue", sender: toDoTuple)
    }
}

extension ToDoListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return toDoItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let toDoItem = toDoItems[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! ToDoItemCell
        
        cell.titleLabel.text = toDoItem.name
        cell.detailLabel.text = toDoItem.isComplete ? "Complete" : "Incomplete"
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        .delete
    }
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            toDoItems.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }
}

extension ToDoListViewController: ToDoListDelegate {
    func update(task: ToDoItem, index: Int){
        
        toDoItems[index] = task
        tableView.reloadData()
    }
    
}
