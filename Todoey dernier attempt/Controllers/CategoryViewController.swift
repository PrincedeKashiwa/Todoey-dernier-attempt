//
//  CategoryViewController.swift
//  Todoey dernier attempt
//
//  Created by BRUNO SMITH on 06/01/2019.
//  Copyright © 2019 BRUNO SMITH. All rights reserved.
//

import UIKit
import RealmSwift
import ChameleonFramework

class CategoryViewController: SwipeTableViewController {
let realm = try! Realm()
    var categories : Results<Category>? // results used in realm just a specific data type, making it an optional not force unwrapping!
    override func viewDidLoad() {
        super.viewDidLoad()
      loadCategories()
    tableView.rowHeight = 80.0
    tableView.separatorStyle = .none

    }

    //MARK: - TableView Datasource Methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories?.count ?? 1 // if it is nil : make it equal to 1, nil coalescent operator
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //cell that comes from superclass
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        if let category = categories?[indexPath.row] {
        cell.textLabel?.text = category.name
        guard let categorycolour = UIColor(hexString: category.colour) else {fatalError()}
        cell.backgroundColor = categorycolour
        cell.textLabel?.textColor = ContrastColorOf(categorycolour, returnFlat: true)
        }
        return cell
    }
    //MARK: - Tableview Delegate Methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToItems", sender: self)
    }
    //preparing for the segue and we know it will take us to the todolistviewcontroller
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! TodoListViewController
        if let indexPath = tableView.indexPathForSelectedRow {
            destinationVC.selectedCategory = categories?[indexPath.row]
        }
    }
    //MARK: - Data Manipulation Methods
    func loadCategories() {
        categories = realm.objects(Category.self) //category not opaque pointer
        tableView.reloadData() //this reloads the data sources methods "override func..."
    }
    //opaque pointer
    func save(category : Category) {
        do { try realm.write {
            realm.add(category)
            }
            
        } catch {
            print("error with saving categories \(error)")
        }
        tableView.reloadData()
    }
    
    //MARK: - Delete Data from Swipe
    
    override func updateModel(at indexPath: IndexPath) {
        if let categoryForDeletion = self.categories?[indexPath.row] {
            do {
                try self.realm.write {
                    self.realm.delete(categoryForDeletion)
                }
            } catch {
                print("Error deleting category \(error)")
            }
            tableView.reloadData()
        }
    }
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var textfield = UITextField()
        let alert = UIAlertController(title: "Add New Category", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add", style: .default) { (action) in
            let newCategory = Category()
            newCategory.name = textfield.text!
            newCategory.colour = UIColor.randomFlat.hexValue()
            self.save(category: newCategory)
        }
        alert.addAction(action)
        alert.addTextField { (alerttextfield) in
            alerttextfield.placeholder = "create category"
            textfield = alerttextfield
        }
        present(alert, animated: true, completion: nil)
        
        }

    
}
