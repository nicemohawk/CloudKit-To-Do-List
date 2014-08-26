//
//  TableViewController.swift
//  ToDoCloudKit
//
//  Created by Anthony Geranio on 6/4/14.
//  Copyright (c) 2014 Anthony Geranio. All rights reserved.
//

import UIKit
import CloudKit


class TableViewController: UITableViewController, UITableViewDataSource, UITableViewDelegate {
	// Create a CKRecord for the items in our database we will be retreiving and storing
	var todoStore = TodoStore.sharedStore

	// Function to delete all todos in the UITableView and database
	@IBAction func deleteTodos(sender: AnyObject) {
	}
	
	// Function to load all todos in the UITableView and database
	func loadTodos() {
	}

	func completeTodoAtIndexPath(indexPath: NSIndexPath) {
	}

}
