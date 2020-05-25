//
//  ViewController.swift
//  Todoey
//
//  Created by Philipp Muellauer on 02/12/2019.
//  Copyright © 2019 App Brewery. All rights reserved.
//

import UIKit
import RealmSwift

class ToDoListViewController: UITableViewController {
	
	let realm = try! Realm()
	
	var itemArray: Results<Item>?
	
	var selectedCategory : Category? {
		didSet {
			loadItems()
		}
	}
	
	let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist")

	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		
	}
	
	
	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return itemArray?.count ?? 1
	}
	
	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
		
		if let item = itemArray?[indexPath.row] {
			
			cell.textLabel?.text = item.title
			
			cell.accessoryType = item.done == true ? .checkmark : .none
			
		} else {
			
			cell.textLabel?.text = "No Item Added"
			
		}
		
		
		return cell
	}
	
	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		
		if let item = itemArray?[indexPath.row] {
			
			do {
				
				try realm.write {
					item.done = !item.done
				}
				
			} catch {
				print(error)
			}
		}
		
		tableView.reloadData()
		tableView.deselectRow(at: indexPath, animated: true)
		
	}
	
	override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
		return true
	}
	
	override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
		
		if editingStyle == .delete {
			
			if let item = itemArray?[indexPath.row] {
					
					do {
						
						try realm.write {
							realm.delete(item)
						}
						
					} catch {
						print(error)
					}
				}
				
				tableView.reloadData()
			
		} else if editingStyle == .insert {
			
		}
		
		
	}
	
	@IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
		
		var textField = UITextField()
		
		let alert = UIAlertController(title: "Add New Todoey Item", message: "", preferredStyle: .alert)
		
		let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
			
			if let currentCategoty = self.selectedCategory {
				do {
					
					try self.realm.write{
						let newItem = Item()
						newItem.dateCreated = Date()
						newItem.title = textField.text!
						currentCategoty.items.append(newItem)
						
					}
				} catch {
					print(error)
				}
			}
			
			self.tableView.reloadData()
		}
		
		alert.addTextField { (addTextField) in
			addTextField.placeholder = "Create new item"
			textField = addTextField
		}
		alert.addAction(action)
		
		present(alert, animated: true, completion: nil)
		
	}
	
	func saveItem(item: Item) {
		
		do {
			try realm.write{
				realm.add(item)
			}
		} catch {
			print(error)
		}
		
		self.tableView.reloadData()
	}
	
	func loadItems() {
		
		itemArray = selectedCategory?.items.sorted(byKeyPath: "title", ascending: true)
		
		tableView.reloadData()
		
	}
}

extension ToDoListViewController: UISearchBarDelegate {

	func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
		
		itemArray = itemArray?.filter("title CONTAINS[cd] %@", searchBar.text as Any).sorted(byKeyPath: "dateCreated", ascending: true)
		
	}
	


func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
	if searchBar.text?.count == 0 {
				loadItems()
		
		DispatchQueue.main.async {
			searchBar.resignFirstResponder()
		}
		
	}
}
	
}


