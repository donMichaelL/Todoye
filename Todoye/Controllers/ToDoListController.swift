//
//  ViewController.swift
//  Todoye
//
//  Created by Michael Loukeris on 02/01/2018.
//  Copyright © 2018 Michael Loukeris. All rights reserved.
//

import UIKit
import CoreData

class ToDoListController: UITableViewController {
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var itemArray = [Item]()

    var selectedCategory : Category? {
        didSet {
            loadItems()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
        searchBar.delegate = self
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        let item = itemArray[indexPath.row]
        cell.textLabel?.text = item.title
        cell.accessoryType = item.done ? .checkmark : .none
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        itemArray[indexPath.row].done = !itemArray[indexPath.row].done
//        Delete objects
//        context.delete(itemArray[indexPath.row])
//        itemArray.remove(at: indexPath.row)
        saveItems()
        tableView.reloadData()
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    @IBAction func barBtnWasPressed(_ sender: Any) {
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add new Todoye item", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add item", style: .default) { (action) in

            let newItem = Item(context: self.context)
            newItem.title = textField.text ?? "New item"
            newItem.done = false
            newItem.parentCategory = self.selectedCategory
            self.itemArray.append(newItem)
            
            self.saveItems()
            self.tableView.reloadData()
        }
        
        alert.addTextField { (alertField) in
            alertField.placeholder = "Create new Item"
            textField = alertField
        }
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
    }
    
    func saveItems() {
        do {
            try context.save()
        } catch {
            print("Error encoding item array, \(error)")
        }
    }
    
    func loadItems(with request: NSFetchRequest<Item> = Item.fetchRequest(), predicate: NSPredicate? = nil) {
        let categoryPredicate = NSPredicate(format: "parentCategory.name MATCHES %@", (selectedCategory?.name)!)
        
        if let additionalPredicate = predicate {
            request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [categoryPredicate, additionalPredicate])
        } else {
            request.predicate = categoryPredicate
        }

        do {
            itemArray = try context.fetch(request)
        } catch {
            print("Error fetching data from content")
        }
        tableView.reloadData()
    }
}

//MARK: - Search Bar Methods

extension ToDoListController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let request: NSFetchRequest<Item> = Item.fetchRequest()
        let predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)
        request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
        
        loadItems(with: request, predicate: predicate)
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
