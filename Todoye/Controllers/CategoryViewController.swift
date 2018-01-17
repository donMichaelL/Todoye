//
//  CategoryViewController.swift
//  Todoye
//
//  Created by Michael Loukeris on 15/01/2018.
//  Copyright © 2018 Michael Loukeris. All rights reserved.
//

import UIKit
import RealmSwift

class CategoryViewController: UITableViewController {
    
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
    
    @IBAction func addBtnWasPressed(_ sender: UIBarButtonItem) {
        let alert = UIAlertController(title: "New category", message: "Add new Category", preferredStyle: .alert)
        
        alert.addTextField { (textField) in
            textField.placeholder = "Type new category"
        }
        alert.addAction(UIAlertAction(title: "Save", style: .default, handler: { (alertAction) in
            let category = Category()
            category.name = alert.textFields?.first?.text ?? "New Category"
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
        cell.textLabel?.text = categories?[indexPath.row].name ?? "No Category"
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
