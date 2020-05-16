//
//  CategoryViewController.swift
//  Todoey
//
//  Created by Alexader Malygin on 16.05.2020.
//  Copyright © 2020 App Brewery. All rights reserved.
//

import UIKit
import CoreData


class CategoryViewController: UITableViewController {
	
	var categories = [Category]()
	
	let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		loadCategories()
		
	}
	
	
	// MARK: - TableView DataSource Methods
	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return categories.count
	}
	
	// MARK: - TableView Delegate
	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
		
		cell.textLabel?.text = categories[indexPath.row].name
		
		return cell
	}
	
	// MARK: - Data Manipulations
	
	func saveCategories() {
		
		do {
			try context.save()
		} catch {
			print(error)
		}
		
		
		self.tableView.reloadData()
	}
	
	func loadCategories(with request: NSFetchRequest<Category> = Category.fetchRequest()) {
		
		do {
			categories = try context.fetch(request)
		} catch {
			print("Error with load item \(error)")
		}
		
		tableView.reloadData()
		
	}
	
	
	// MARK: - Add new category
	
	@IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
		
		var textField = UITextField()
		
		let alert = UIAlertController(title: "Add New Category", message: "", preferredStyle: .alert)
		
		let action = UIAlertAction(title: "Add category", style: .default) { (action) in
			
			let newCategory = Category(context: self.context)
			newCategory.name = textField.text!
			
			self.categories.append(newCategory)
			
			self.saveCategories()
			
		}
		
		alert.addTextField { (addTextField) in
			addTextField.placeholder = "Create new category"
			textField = addTextField
		}
		alert.addAction(action)
		
		present(alert, animated: true, completion: nil)
	}
	
	
	
}
