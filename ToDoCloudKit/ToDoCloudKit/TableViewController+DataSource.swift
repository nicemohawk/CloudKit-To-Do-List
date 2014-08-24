//
//  TableViewController+DataSource.swift
//  ToDoCloudKit
//
//  Created by Ben Lachman on 8/22/14.
//  Copyright (c) 2014 Ben Lachman. All rights reserved.
//

import UIKit

extension TableViewController {
	override func numberOfSectionsInTableView(tableView: UITableView?) -> Int {
		// Return the number of sections.
		return 1
	}

	override func tableView(tableView: UITableView?, numberOfRowsInSection section: Int) -> Int {
		// Return the number of rows in the section.
		return self.todoStore.todos.count
	}

	override func tableView(tableView: UITableView?, cellForRowAtIndexPath indexPath: NSIndexPath!) -> UITableViewCell? {
		let cellIdentifier = "todoCell"

		let cell: UITableViewCell = UITableViewCell(style: UITableViewCellStyle.Value1, reuseIdentifier: cellIdentifier)

		var todo = todoStore.todos[indexPath.row]

		// Set the main cell label for the key we retreived: todoNameKey. This can be optional.
		cell.textLabel.text = todo.name

		// Set the detail cell label for the key we retreived: priorityKey. This can be optional.
		cell.detailTextLabel.text = todo.priority

		return cell
	}

	override func tableView(tableView: UITableView!, didSelectRowAtIndexPath indexPath: NSIndexPath!) {
		// Deselect the row using an animation.
		self.tableView.deselectRowAtIndexPath(indexPath, animated: true)

		self.completeTodoAtIndexPath(indexPath)
	}
}
