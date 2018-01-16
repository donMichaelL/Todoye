//
//  CategoryViewController.swift
//  Todoye
//
//  Created by Michael Loukeris on 15/01/2018.
//  Copyright © 2018 Michael Loukeris. All rights reserved.
//

import UIKit
import CoreData

class CategoryViewController: UITableViewController {
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var categories = [Category]()

    override func viewDidLoad() {
        super.viewDidLoad()
        loadCategories()
    }

    func loadCategories() {
        let request: NSFetchRequest<Category> = Category.fetchRequest()
        do {
            categories = try context.fetch(request)
        }catch {
            debugPrint("Could not fetch \(error.localizedDescription)")
        }
    }
    
    func saveCategory() {
        do {
            try context.save()
        } catch {
            debugPrint("Could not save \(error.localizedDescription)")
        }
    }
    
    @IBAction func addBtnWasPressed(_ sender: UIBarButtonItem) {
        let alert = UIAlertController(title: "New category", message: "Add new Category", preferredStyle: .alert)
        
        alert.addTextField { (textField) in
            textField.placeholder = "Add new BASE_URL"
        }
        alert.addAction(UIAlertAction(title: "Save", style: .default, handler: { (alertAction) in
            let category = Category(context: self.context)
            category.name = alert.textFields?.first?.text ?? "New Category"
            self.categories.append(category)
            self.saveCategory()
            self.tableView.reloadData()
        }))
        present(alert, animated: true, completion: nil)
    }
}

//MARK: - TablewView Methods
extension CategoryViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
        cell.textLabel?.text = categories[indexPath.row].name!
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
            destinationVC.selectedCategory = categories[indexPath.row]
        }
        
    }
}
