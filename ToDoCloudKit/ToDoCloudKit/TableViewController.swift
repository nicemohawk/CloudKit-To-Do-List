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

	// Function to load all tasks in the UITableView and database
	func loadTasks() {
		// Finish fetching the items for the recordX
		todoStore.fetchAllRecordsWithCompletion() { (cursor, error) in
			if error != nil {
				println(error)
			}

			println("End fetch")

			// Reload the UITableView with the retreived contents
			dispatch_async(dispatch_get_main_queue()) {
				self.tableView.reloadData()
			}
		}
	}

	// Function to delete all tasks in the UITableView and database
	@IBAction func deleteTasks(sender: AnyObject) {
		// Create the query to load the tasks

		todoStore.deleteAllRecordsWithCompletion { (error) -> Void in
			// Reload the UITableView and retreive the new contents
			dispatch_async(dispatch_get_main_queue()) {
				self.tableView.reloadData()
			}
		}
	}

	func deleteTodoAtIndexPath(indexPath: NSIndexPath) {
		var itemToDelete = todoStore.todos.removeAtIndex(indexPath.row)
		tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)

		var database: CKDatabase = CKContainer.defaultContainer().privateCloudDatabase

		database.deleteRecordWithID(itemToDelete.recordID) { (deletedRecord, error) -> Void in
			if error != nil {
				println("error: \(error)")
			} else {
				println("deleted task: \(itemToDelete.name)")
			}
		}
	}

	override func viewDidAppear(animated: Bool)  {
		super.viewDidAppear(animated)

		loadTasks()
	}

	override func viewDidLoad() {
		super.viewDidLoad()

		self.tableView.delegate = self
		self.tableView.dataSource = self

		dispatch_async(dispatch_get_main_queue()) {
			self.tableView.reloadData()
		}
	}

	override func prepareForSegue(segue: UIStoryboardSegue!, sender: AnyObject!) {
		super.prepareForSegue(segue, sender: sender)

		if let newTaskViewController = segue.destinationViewController as? NewTaskViewController {
			newTaskViewController.todoViewController = self
		}
	}
}
