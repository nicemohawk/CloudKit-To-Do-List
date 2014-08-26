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
	}

	func deleteAllRecordsWithCompletion( deleteFinished: ((NSError!) -> Void)! ) {
	}

	func newTodoWithName(name: String, andPriority priority: String, completion: (Void -> Void)) {
	}

	func createOrUpdateTodoForRecord(record: CKRecord) {
	}
}
