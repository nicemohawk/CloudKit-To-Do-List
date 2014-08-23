//
//  TableViewController.swift
//  ToDoCloudKit
//
//  Created by Anthony Geranio on 6/4/14.
//  Copyright (c) 2014 Anthony Geranio. All rights reserved.
//

import UIKit
import CloudKit
import Foundation


class TableViewController: UITableViewController, UITableViewDataSource, UITableViewDelegate {
	// Create a CKRecord for the items in our database we will be retreiving and storing
	var records: [CKRecord] = []
	var todoStore = TodoStore.sharedStore

	// Function to load all tasks in the UITableView and database
	func loadTasks() {

		// Create the query to load the tasks
		var query = CKQuery(recordType: "task", predicate: NSPredicate(format: "TRUEPREDICATE"))
		var queryOperation = CKQueryOperation(query: query)

		println("Start fetch")

		// Add the newly fetched record to our records array
		func fetched(record: CKRecord!) {
			records.append(record)
		}

		queryOperation.recordFetchedBlock = fetched

		// Finish fetching the items for the recordX
		func fetchFinished(cursor: CKQueryCursor?, error: NSError?) {

			if error != nil {
				println(error)
			}

			println("End fetch")

			// Print items array contents
			println(records)

			// Add contents of the item array to the tasks array
			for record in self.records {
				todoStore.createOrUpdateTodoForRecord(record)
			}

			records = []

			// Reload the UITableView with the retreived contents
			dispatch_async(dispatch_get_main_queue()) {
				self.tableView.reloadData()
			}
		}

		queryOperation.queryCompletionBlock = fetchFinished

		// Create the database you will retreive information from
		var database: CKDatabase = CKContainer.defaultContainer().privateCloudDatabase
		database.addOperation(queryOperation)
	}

	// Function to delete all tasks in the UITableView and database
	@IBAction func deleteTasks(sender: AnyObject) {

		// Create the query to load the tasks
		var query = CKQuery(recordType: "task", predicate: NSPredicate(format: "TRUEPREDICATE"))
		var queryOperation = CKQueryOperation(query: query)
		println("Start fetch")

		// Fetch the items for the record
		func fetched(record: CKRecord!) {
			records.append(record)
		}

		queryOperation.recordFetchedBlock = fetched

		// Finish fetching the items for the record
		func fetchFinished(cursor: CKQueryCursor?, error: NSError?) {

			if error != nil {
				println(error)
			}

			println("End fetch")

			// Print items array contents
			println(records)

			// Iterate through the array content ids
			var ids : [CKRecordID] = []
			for item in records {
				ids.append(item.recordID)
			}

			// Create the database where you will delete your data from
			var database: CKDatabase = CKContainer.defaultContainer().privateCloudDatabase

			// Delete the data from the database using the ids we iterated through
			var deleteItemsOperation: CKModifyRecordsOperation = CKModifyRecordsOperation(recordsToSave: nil, recordIDsToDelete: ids)

			deleteItemsOperation.modifyRecordsCompletionBlock = { (savedRecords, deletedRecordIDs, operationError) -> Void in
				if deletedRecordIDs.count > 0 {
					self.todoStore.todos = []
				}

				// Reload the UITableView and retreive the new contents
				dispatch_async(dispatch_get_main_queue()) {
					self.tableView.reloadData()
				}
			}

			database.addOperation(deleteItemsOperation)
		}

		queryOperation.queryCompletionBlock = fetchFinished

		// Create the database where you will retreive your new data from
		var database: CKDatabase = CKContainer.defaultContainer().privateCloudDatabase
		database.addOperation(queryOperation)
	}

	func deleteTodoAtIndexPath(indexPath: NSIndexPath) {
		var itemToDelete = todoStore.todos.removeAtIndex(indexPath.row)
		tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)

		var database: CKDatabase = CKContainer.defaultContainer().privateCloudDatabase

		database.deleteRecordWithID(itemToDelete.recordID, completionHandler: { (deletedRecord, error) -> Void in
			if error != nil {
				println("error: \(error)")
			} else {
				println("deleted task: \(itemToDelete.name)")
			}
		})
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
			newTaskViewController.todoVC = self
		}
	}

	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}


}
