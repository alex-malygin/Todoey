//
//  ViewController.swift
//  Todoey
//
//  Created by Philipp Muellauer on 02/12/2019.
//  Copyright © 2019 App Brewery. All rights reserved.
//

import UIKit
import CoreData

class ToDoListViewController: UITableViewController {
	
	var itemArray = [Item]()
	
	var selectedCategory : Category? {
		didSet {
//			loadItems()
		}
	}
	
	let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist")
	
	let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
	
	let defaults = UserDefaults.standard
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		
	}
	
	
	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return itemArray.count
	}
	
	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
		
		let item = itemArray[indexPath.row]
		
		cell.textLabel?.text = item.title
		
		cell.accessoryType = item.done == true ? .checkmark : .none
		
		return cell
	}
	
	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		
		itemArray[indexPath.row].done = !itemArray[indexPath.row].done
		
		self.saveItem()
		
		tableView.deselectRow(at: indexPath, animated: true)
		
	}
	
	override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
		return true
	}
	
	override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
		
		if editingStyle == .delete {
			
//			context.delete(itemArray[indexPath.row])
			itemArray.remove(at: indexPath.row)
			
			tableView.deleteRows(at: [indexPath], with: .fade)
			
			self.saveItem()
			
		} else if editingStyle == .insert {
			
		}
		
		
		
	}
	
	@IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
		
		var textField = UITextField()
		
		let alert = UIAlertController(title: "Add New Todoey Item", message: "", preferredStyle: .alert)
		
		let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
			
//			let newItem = Item(context: self.context)
//			newItem.title = textField.text!
//			newItem.done = false
//			newItem.parentCategory = self.selectedCategory
//
//			self.itemArray.append(newItem)
//
//			self.saveItem()
			
		}
		
		alert.addTextField { (addTextField) in
			addTextField.placeholder = "Create new item"
			textField = addTextField
		}
		alert.addAction(action)
		
		present(alert, animated: true, completion: nil)
		
	}
	
	func saveItem() {
		
		do {
			try context.save()
		} catch {
			print(error)
		}
		
		
		self.tableView.reloadData()
	}
	
//	func loadItems(with request: NSFetchRequest<Item> = Item.fetchRequest(), predicate: NSPredicate? = nil) {
//
//		let categoryPredicate = NSPredicate(format: "parentCategory.name MATCHES %@", selectedCategory!.name!)
//
//		if let addtionalPredicate = predicate {
//			request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [categoryPredicate, addtionalPredicate])
//		} else {
//			request.predicate = categoryPredicate
//		}
//
//		do {
//			itemArray = try context.fetch(request)
//		} catch {
//			print("Error with load item \(error)")
//		}
//
//		tableView.reloadData()
//
//	}
//}

//extension ToDoListViewController: UISearchBarDelegate {
//
//	func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
//
//		let request: NSFetchRequest<Item> = Item.fetchRequest()
//
//		let predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)
//
//		request.predicate = predicate
//
//		let sortDescriptor = NSSortDescriptor(key: "title", ascending: true)
//
//		request.sortDescriptors = [sortDescriptor]
//
//		loadItems(with: request, predicate: predicate)
//
//	}
//
	func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
		if searchBar.text?.count == 0 {
//			loadItems()
			
			DispatchQueue.main.async {
				searchBar.resignFirstResponder()
			}
			
		}
	}
	
	
}
