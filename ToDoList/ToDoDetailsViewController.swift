//
//  ToDoDetailsViewController.swift
//  ToDoList
//
//  Created by Darren Asamov on 10/03/2022.
//

import UIKit

class ToDoDetailsViewController: UIViewController {

    @IBOutlet weak var taskTitleLabel: UILabel!
    @IBOutlet weak var taskCompletionDate: UILabel!
    @IBOutlet weak var taskDetailsTextView: UITextView!
    @IBOutlet weak var taskCompletionButton: UIButton!
    
    var toDoItem: ToDoItem!
    var toDoIndex: Int!
    
    var delegate: ToDoListDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        taskTitleLabel.text = toDoItem.name
        taskDetailsTextView.text = toDoItem.details
        
        if toDoItem.isComplete {
            disableButton()
        }
        
        setCompletionDate()

    }
    
    func disableButton () {
        
        taskCompletionButton.backgroundColor = .gray
        taskCompletionButton.isEnabled = false
    }
    
    func setCompletionDate() {
        
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM dd, yyyy hh:mm"
        let taskDate = formatter.string(from: toDoItem.completionDate)
        taskCompletionDate.text = taskDate
    }

    @IBAction func taskDidComplete(_ sender: UIButton) {
        
        toDoItem.isComplete = true
        delegate?.update(task: toDoItem, index: toDoIndex)
        disableButton()
    }
}
