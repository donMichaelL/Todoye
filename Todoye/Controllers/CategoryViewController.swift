//
//  CategoryViewController.swift
//  Todoye
//
//  Created by Michael Loukeris on 15/01/2018.
//  Copyright © 2018 Michael Loukeris. All rights reserved.
//

import UIKit
import RealmSwift
import ChameleonFramework

class CategoryViewController: SwipeTableViewController {
    
    let realm = try! Realm()
    
    var categories: Results<Category>?

    override func viewDidLoad() {
        super.viewDidLoad()
        loadCategories()
    }

    func loadCategories() {
        categories = realm.objects(Category.self)
        tableView.reloadData()
    }
    
    func save(category: Category) {
        do {
            try realm.write {
                
                realm.add(category)
            }
        } catch {
            debugPrint("Could not save \(error.localizedDescription)")
        }
    }
    
    override func updateModel(at indexPath: IndexPath) {
        if let categoryForDeletion = self.categories?[indexPath.row] {
            do {
                try self.realm.write {
                    self.realm.delete(categoryForDeletion)
                }
            } catch {
                print("Error deleting categoyr, \(error)")
            }
        }
    }
    
    @IBAction func addBtnWasPressed(_ sender: UIBarButtonItem) {
        let alert = UIAlertController(title: "New category", message: "Add new Category", preferredStyle: .alert)
        
        alert.addTextField { (textField) in
            textField.placeholder = "Type new category"
        }
        alert.addAction(UIAlertAction(title: "Save", style: .default, handler: { (alertAction) in
            let category = Category()
            category.name = alert.textFields?.first?.text ?? "New Category"
            category.colour = UIColor.randomFlat.hexValue()
            self.save(category: category)
            self.tableView.reloadData()
        }))
        present(alert, animated: true, completion: nil)
    }
}

//MARK: - TablewView Methods
extension CategoryViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        cell.textLabel?.text = categories?[indexPath.row].name ?? "No Category"
        cell.backgroundColor = UIColor(hexString: (categories?[indexPath.row].colour) ?? "1d9bf6")
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToItems", sender: self)
    }
}

//MARK: - Working with segue
extension CategoryViewController {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! ToDoListController
        if let indexPath = tableView.indexPathForSelectedRow {
            destinationVC.selectedCategory = categories?[indexPath.row]
        }
        
    }
}





