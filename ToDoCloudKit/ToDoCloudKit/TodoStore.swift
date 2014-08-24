//
//  TodoStore.swift
//  ToDoCloudKit
//
//  Created by Ben Lachman on 8/22/14.
//  Copyright (c) 2014 Ben Lachman. All rights reserved.
//

import Foundation
import CloudKit

struct Todo {
	var recordID: CKRecordID?
	var name = "New Todo"
	var priority = "Not Important"

	init(record: CKRecord) {
		self.name = record.objectForKey("todoNameKey") as String
		self.priority = record.objectForKey("priorityKey") as String

		self.recordID = record.recordID
	}
}

private let _singletonInstance = TodoStore()

class TodoStore {
	var todos: [Todo] = []

	class var sharedStore: TodoStore {
		return _singletonInstance
	}

	func fetchAllRecordsWithCompletion(fetchFinished:((CKQueryCursor!, NSError!) -> Void)!) {
		var query = CKQuery(recordType: "todo", predicate: NSPredicate(format: "TRUEPREDICATE"))
		var queryOperation = CKQueryOperation(query: query)

		queryOperation.recordFetchedBlock = { (record: CKRecord!) in
			self.createOrUpdateTodoForRecord(record)
		}

		queryOperation.queryCompletionBlock = fetchFinished

		// Create the database where you will retreive your new data from
		var database: CKDatabase = CKContainer.defaultContainer().privateCloudDatabase
		database.addOperation(queryOperation)
	}

	func deleteAllRecordsWithCompletion( deleteFinished: ((NSError!) -> Void)! ) {
		self.fetchAllRecordsWithCompletion { (cursor, error) in
			if error != nil {
				println(error)
			}

			// Iterate through the array content ids
			var ids : [CKRecordID] = []

			for todo in self.todos {
				if let recordID = todo.recordID? {
					ids.append(recordID)
				}
			}

			// retreive the database where we will delete the data from
			var database: CKDatabase = CKContainer.defaultContainer().privateCloudDatabase

			// Delete the data from the database using the ids we iterated through
			var deleteItemsOperation: CKModifyRecordsOperation = CKModifyRecordsOperation(recordsToSave: nil, recordIDsToDelete: ids)

			deleteItemsOperation.modifyRecordsCompletionBlock = { (savedRecords, deletedRecordIDs, operationError) -> Void in
				if deletedRecordIDs.count > 0 {
					self.todos = []
				}

				deleteFinished(operationError)
			}
			
			database.addOperation(deleteItemsOperation)
		}
	}

	func newTodoWithName(name: String, andPriority priority: String, completion: (Void -> Void)) {
		// Create record to save todos
		var record: CKRecord = CKRecord(recordType: "todo")
		// Save todo description for key: todoNameKey
		record.setObject(name, forKey: "todoNameKey")
		// Save priority for key: priorityKey
		record.setObject(priority, forKey: "priorityKey")
		// Create the private database for the user to save their data to
		var database: CKDatabase = CKContainer.defaultContainer().privateCloudDatabase

		// Save data to the database for the record: todo
		database.saveRecord(record) { (record: CKRecord?, error: NSError?) in
			if error != nil {
				println(error)
			} else {
				TodoStore.sharedStore.createOrUpdateTodoForRecord(record!)
			}

			completion()
		}
	}

	func createOrUpdateTodoForRecord(record: CKRecord) {
		var foundTodo: Bool = false

		for (index, todo) in enumerate(todos) {
			if todo.recordID == record.recordID {
				foundTodo = true

				self.todos[index].name = record.objectForKey("todoNameKey") as String
				self.todos[index].priority = record.objectForKey("priorityKey") as String

				break;
			}
		}

		if foundTodo == false {
			todos.append(Todo(record: record))
		}
	}
}
