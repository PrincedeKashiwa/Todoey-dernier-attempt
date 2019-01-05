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
    let datafilepath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist")
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
    
        loaditems()
        

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
        itemArray[indexPath.row].done = !itemArray[indexPath.row].done //equals the opposite of current itemarrayindexpath.row.done
        saveitems()
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
            self.saveitems()
        }
            alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Creeaate item meeeec"
            textField = alertTextField
        }
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
        func saveitems () {
        let encoder = PropertyListEncoder()
        do {
            let data = try encoder.encode(itemArray)
            try data.write(to: datafilepath!)
        } catch {
            print("error encoding item array , \(error)")
            
        }
        self.tableView.reloadData()
}
    
    func loaditems() {
        if let data = try? Data(contentsOf: datafilepath!) {
        let decoder = PropertyListDecoder()
            do { itemArray = try decoder.decode([Item].self, from: data)
            } catch {
                print(";..'")
            }
    }
}
}
