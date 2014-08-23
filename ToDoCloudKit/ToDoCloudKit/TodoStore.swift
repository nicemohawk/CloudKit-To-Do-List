//
//  TodoStore.swift
//  ToDoCloudKit
//
//  Created by Ben Lachman on 8/22/14.
//  Copyright (c) 2014 Anthony Geranio. All rights reserved.
//

import Foundation
import CloudKit

struct Todo {
	var recordID: CKRecordID?
	var name = "New Todo"
	var priority = "Not Important"

	init(record: CKRecord) {
		self.name = record.objectForKey("taskKey") as String
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

	func createOrUpdateTodoForRecord(record: CKRecord) {
		var foundTodo: Bool = false

		for todo in todos {
			if todo.recordID == record.recordID {
				// TODO: update todo

				foundTodo = true
				break;
			}
		}

		if foundTodo == false {
			todos.append(Todo(record: record))
		}
	}
}
