//
//  ViewController.swift
//  Todoey dernier attempt
//
//  Created by BRUNO SMITH on 21/12/2018.
//  Copyright © 2018 BRUNO SMITH. All rights reserved.
//

import UIKit
//don't forget to change the superclass from UIVIEWCONTROLLER TO UITABLEVIEWCONTROLLER
class TodoListViewController: UITableViewController {
    var itemArray = [Item]()
    let defaults = UserDefaults.standard //singleton from the class userdefaults
    override func viewDidLoad() {
        super.viewDidLoad()
        let newitem = Item()
        newitem.title = "Find Mike"
        itemArray.append(newitem)
        if let items = defaults.array(forKey: "ToDoListArray") as? [Item] {
            itemArray = items
         // casting it as an array of strings
        // Do any additional setup after loading the view, typically from a nib.
    }
    }

    //MARK - TableView Datasource

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        let item = itemArray[indexPath.row]
        cell.textLabel?.text = item.title
        // ternary operator. value = condition ? value if true : value if false
        cell.accessoryType = item.done == true ? .checkmark : .none
        return cell
    }
    //MARK - TABLEVIEW Delegate methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //print (itemArray[indexPath.row])
        itemArray[indexPath.row].done = !itemArray[indexPath.row].done //equals the opposite of current itemarrayindexpath.row.done
        tableView.reloadData()
        tableView.deselectRow(at: indexPath, animated: true)//flashes grey
        
    }
    
    //MARK - Add new Items
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField() // creating this variable so it can be accessed by all the completion handlers! we're increasing the scope.
        let alert = UIAlertController(title: "Add new todoey item", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            //What will happen once the user clicks the add item button
            let newItem = Item()
            newItem.title = textField.text!
            self.itemArray.append(newItem) //force unwrap it since string will never be equal to nil even if empty, its set to empty string
            // since its closure you have to add self to explain where the item array exists ie the current class
            self.defaults.set(self.itemArray, forKey: "ToDoListArray")
            self.tableView.reloadData()
        }
            alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Creeaate item meeeec"
            textField = alertTextField
        }
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
}

