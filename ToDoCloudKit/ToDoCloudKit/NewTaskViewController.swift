//
//  NewTaskViewController.swift
//  ToDoCloudKit
//
//  Created by Anthony Geranio on 6/4/14.
//  Copyright (c) 2014 Anthony Geranio. All rights reserved.
//

import UIKit
import CloudKit

class NewTaskViewController: UIViewController {

	// UITextField for task description.
	@IBOutlet var taskDescriptionTextField : UITextField!
	// UILabel for priority. Can either be 'Important' or 'Not Important'.
	@IBOutlet var priorityLabel: UILabel!
	// UISwitch for priority. Can be either 'Off' or 'On'. This also changes the priority label accordingly.
	@IBOutlet var flagButton: UISwitch!

	var todoViewController: TableViewController = TableViewController()

	
	override func viewDidLoad() {
		super.viewDidLoad()
		// Do any additional setup after loading the view.
	}

	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}

	// Create the button to add the task
	@IBAction func addTaskButtonPressed(sender: AnyObject) {

		TodoStore.sharedStore.newTodoWithName(taskDescriptionTextField.text, andPriority: priorityLabel.text) {
			dispatch_async(dispatch_get_main_queue()) {
				self.todoViewController.tableView.reloadData()
			}
		}

		navigationController.popViewControllerAnimated(true)
	}

	// Create the button to set the priority
	@IBAction func addFlagButtonPressed(sender: AnyObject) {
		// Detect wether the UISwitch is on or off
		if(flagButton.on) {
			priorityLabel.text = "Important"
		} else {
			priorityLabel.text = "Not Important"
		}
	}

}
