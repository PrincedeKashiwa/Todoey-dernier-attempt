//
//  ViewController.swift
//  Todoey dernier attempt
//
//  Created by BRUNO SMITH on 21/12/2018.
//  Copyright © 2018 BRUNO SMITH. All rights reserved.
//

import UIKit
import RealmSwift
import ChameleonFramework
//don't forget to change the superclass from UIVIEWCONTROLLER TO UITABLEVIEWCONTROLLER
//setting the class as delegate of search bar + control drag the search bar to the yellow button it represent the view controler could have just added, UIsearchbarcontroller delegater instead we use an extension
class TodoListViewController: SwipeTableViewController {
    var toDoItems : Results<Item>?
    let realm = try! Realm()
    var selectedCategory : Category? {
        //didset called once selectedcategory is assigned a value, its value is assigned on the category view controller
        didSet{
            loaditems()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.rowHeight = 80.0
        tableView.separatorStyle = .none
        
    }
    //viewdidAppear gets called after view did load and after navcontroller fully loaded that's why we put it there, its a different lifecycle time point
    override func viewDidAppear(_ animated: Bool) {
        //ifselectedCategory?.colour not nil will proceed to this method
        //title is the name on navbar
        title = selectedCategory!.name
        if let colourHex = selectedCategory?.colour {
            //guarding against scenarios where navbar is nil
            guard let navBar = navigationController?.navigationBar else {fatalError("Navigation controller does not exist")}
            navBar.barTintColor = UIColor(hexString: colourHex)
        }
    }

    //MARK - TableView Datasource

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return toDoItems?.count ?? 1
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        if let item = toDoItems?[indexPath.row] {
        cell.textLabel?.text = item.title
            //okay to force unraw since the initial if let only occurs if todoitems not empty
            //if not nil then darken it
            if let colour = UIColor(hexString: selectedCategory!.colour)?.darken(byPercentage: CGFloat(indexPath.row) / CGFloat(toDoItems!.count)) {
                    cell.backgroundColor = colour
                    cell.textLabel?.textColor = ContrastColorOf(colour, returnFlat: true)
                }
        // ternary operator. value = condition ? value if true : value if false
        cell.accessoryType = item.done == true ? .checkmark : .none
        } else {
            cell.textLabel?.text = "No Items Added"
        }
        return cell
    }
    //MARK - TABLEVIEW Delegate methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let item = toDoItems?[indexPath.row] {
            do {
                try realm.write {
                    item.done = !item.done
                } } catch{
                print ("issue saving done property \(error)")
                }
            }
        tableView.reloadData()
        tableView.deselectRow(at: indexPath, animated: true)//flashes grey
        }
    //MARK - Add new Items
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField() // creating this variable so it can be accessed by all the completion handlers! we're increasing the scope.
        let alert = UIAlertController(title: "Add new todoey item", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            //What will happen once the user clicks the add item button
            if let currentCategory = self.selectedCategory {
                do {
                try self.realm.write {
                    let newItem = Item()
                    newItem.title = textField.text! //done already specified in the class
                    newItem.dateCreated = Date()
                    currentCategory.items.append(newItem)}
                }catch{
                    print("Error Saving Items \(error)")}
            }
            self.tableView.reloadData()
            // since its closure you have to add self to explain where the item array exists ie the current class

        }
            alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Creeaate item meeeec"
            textField = alertTextField
        }
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
}
    //external parameter with, internal request, intenrnal used inside load items, external used when called, with default value
    func loaditems() {
        toDoItems = selectedCategory?.items.sorted(byKeyPath: "title", ascending: true)
}
override func updateModel(at indexPath: IndexPath) {
    if let itemForDeletion = self.toDoItems?[indexPath.row] {
        do {
            try self.realm.write {
                self.realm.delete(itemForDeletion)
            }
        } catch {
            print("Error deleting category \(error)")
        }
        tableView.reloadData()
    }
}
}
// try to split up fonctionalities for code organization and debug it easier
//MARK: - Search bar Methods
extension TodoListViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        toDoItems = toDoItems?.filter("title CONTAINS[cd] %@", searchBar.text!).sorted(byKeyPath: "dateCreated", ascending: true)
        tableView.reloadData()

    }
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0 {
            loaditems()
            //dispatchqueue decides what goes on the foreground and background, here forcing it in the foreground, where you should update your UI elements

            DispatchQueue.main.async {
                searchBar.resignFirstResponder() //relinquish its status as first responder so no longer the thing selected, no keyboard no cursor.
            }

        }
}
}
