//
//  AddTaskViewController.swift
//  ToDoList
//
//  Created by Darren Asamov on 10/03/2022.
//

import UIKit

class AddTaskViewController: UIViewController {

    @IBOutlet weak var taskNameTextField: UITextField!
    @IBOutlet weak var taskDetailsTextView: UITextView!
    @IBOutlet weak var taskCompletionDatePicker: UIDatePicker!
    @IBOutlet weak var scrollView: UIScrollView!
    
    var date: String?
    let toolBarDone = UIToolbar()
    
    var activeTextField: UITextField?
    var activeTextView: UITextView?
    
    lazy var touchView: UIView = {
        let _touchView = UIView()
        let touchViewTapped = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        _touchView.backgroundColor = UIColor(red: 1, green: 1, blue: 1, alpha: 0)
        _touchView.addGestureRecognizer(touchViewTapped)
        _touchView.isUserInteractionEnabled = true
        _touchView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height)
        
        return _touchView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        taskDetailsTextView.layer.borderWidth = 1
        taskDetailsTextView.layer.borderColor = UIColor.lightGray.cgColor
        taskDetailsTextView.layer.cornerRadius = 3
        toolbar()
        
        taskNameTextField.delegate = self
        taskDetailsTextView.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        registerForKeyboardNotification()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        deregisterFromKeyboardNotification()
    }
    
    @IBAction func cancelButtonDidTouch(_ sender: UIBarButtonItem) {
        dismiss(animated: true)
    }
    
    @IBAction func addTaskDidTouch(_ sender: UIButton) {
        let completionDate = taskCompletionDatePicker.date

        if taskNameTextField.text!.isEmpty {
            reportError(title: "Invalid Task Name!", message: "Task name is required!")
        } else if taskDetailsTextView.text.isEmpty {
            reportError(title: "Invalid Task Details!", message: "Task details is required!")
        } else if completionDate < Date() {
            reportError(title: "Invalid date!", message: "You have to choose date in the future!")
        } else {
            let toDoItem = ToDoItem(name: taskNameTextField.text!, details: taskDetailsTextView.text, completionDate: completionDate, startDate: Date(), isComplete: true)
            
            NotificationCenter.default.post(name: NSNotification.Name.init("com.todolistapp.addtask"), object: toDoItem)
            
            dismiss(animated: true)
        }
    }
    
    func reportError(title: String, message: String) {
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let ok = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
        
        alert.addAction(ok)
        present(alert, animated: true)
    }
    
    func registerForKeyboardNotification() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWasShown(notification:)), name: UIWindow.keyboardDidShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWasHidden(notification:)), name: UIWindow.keyboardWillHideNotification, object: nil)
    }
    
    func deregisterFromKeyboardNotification() {
        NotificationCenter.default.removeObserver(self, name: UIWindow.keyboardDidShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIWindow.keyboardWillHideNotification, object: nil)
    }
    
    @objc func keyboardWasShown(notification: NSNotification) {
        view.addSubview(touchView)
        
        let info = notification.userInfo! as NSDictionary
        let keyboardSize = (info[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue.size
        let contentInsets = UIEdgeInsets(top: 0, left: 0, bottom: keyboardSize!.height + toolBarDone.frame.size.height + 10, right: 0)
        scrollView.contentInset = contentInsets
        scrollView.scrollIndicatorInsets = contentInsets
        
        var aRect = UIScreen.main.bounds
        aRect.size.height -= keyboardSize!.height
        
        if activeTextField != nil {
            if !aRect.contains(activeTextField!.frame.origin) {
                scrollView.scrollRectToVisible(activeTextField!.frame, animated: true)
            }
        } else if activeTextView != nil {
            let textViewPoint = CGPoint(x: activeTextView!.frame.origin.x, y: activeTextView!.frame.size.height + activeTextView!.frame.size.height )
            if !aRect.contains(textViewPoint) {
                scrollView.scrollRectToVisible(activeTextView!.frame, animated: true)
            }
        }
        
    }
    
    @objc func keyboardWasHidden(notification: NSNotification) {
        touchView.removeFromSuperview()
        
        let contentInsets = UIEdgeInsets.zero
        scrollView.contentInset = contentInsets
        scrollView.scrollIndicatorInsets = contentInsets
        
        view.endEditing(true)
    }
    
    func toolbar() {
        toolBarDone.sizeToFit()
        toolBarDone.barTintColor = UIColor.red
        toolBarDone.isTranslucent = false
        let flexSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: self, action: nil)
        let barBtnDone = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.done, target: self, action: #selector(doneButtonTapped))
        barBtnDone.setTitleTextAttributes([NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 17) ,NSAttributedString.Key.foregroundColor: UIColor.white], for: .normal)
        toolBarDone.items = [flexSpace, barBtnDone, flexSpace]
        taskNameTextField.inputAccessoryView = toolBarDone
        taskDetailsTextView.inputAccessoryView = toolBarDone
    }
    
    @objc func doneButtonTapped() {
        view.endEditing(true)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}

extension AddTaskViewController: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        activeTextField = textField
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        activeTextField = nil
    }
}

extension AddTaskViewController: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        activeTextView = textView
    }
    func textViewDidEndEditing(_ textView: UITextView) {
        activeTextView = nil
    }
}
