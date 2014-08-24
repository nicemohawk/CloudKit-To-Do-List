//
//  NewTodoViewController.swift
//  ToDoCloudKit
//
//  Created by Anthony Geranio on 6/4/14.
//  Copyright (c) 2014 Anthony Geranio. All rights reserved.
//

import UIKit


class NewTodoViewController: UIViewController {
	@IBOutlet var todoDescriptionTextField : UITextField!
	@IBOutlet var priorityLabel: UILabel!
	@IBOutlet var flagButton: UISwitch!

	var todoViewController: TableViewController!

	@IBAction func addTodoButtonPressed(sender: AnyObject) {
		TodoStore.sharedStore.newTodoWithName(todoDescriptionTextField.text, andPriority: priorityLabel.text) {
			dispatch_async(dispatch_get_main_queue()) {
				self.todoViewController.tableView.reloadData()
			}
		}

		navigationController.popViewControllerAnimated(true)
	}

	@IBAction func addFlagButtonPressed(sender: AnyObject) {
		// Detect whether the UISwitch is on or off
		if(flagButton.on) {
			priorityLabel.text = "Important"
		} else {
			priorityLabel.text = "Not Important"
		}
	}
}
