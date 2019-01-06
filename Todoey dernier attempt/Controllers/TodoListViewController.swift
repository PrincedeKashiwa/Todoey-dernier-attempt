//
//  ViewController.swift
//  Todoey dernier attempt
//
//  Created by BRUNO SMITH on 21/12/2018.
//  Copyright © 2018 BRUNO SMITH. All rights reserved.
//

import UIKit
import CoreData
//don't forget to change the superclass from UIVIEWCONTROLLER TO UITABLEVIEWCONTROLLER
//setting the class as delegate of search bar + control drag the search bar to the yellow button it represent the view controler could have just added , UIsearchbarcontroller delegater instead we use an extension
class TodoListViewController: UITableViewController {
    var itemArray = [Item]()
    var selectedCategory : Category? {
        //didset called once selectedcategory is assigned a value, its value is assigned on the category view controller
        didSet{
            loaditems()
        }
    }
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    override func viewDidLoad() {
        super.viewDidLoad()
        print (FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
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
//        context.delete(itemArray[indexPath.row])
//        itemArray.remove(at: indexPath.row) // first delete from the context then delete from item array otherwise bug
        
    }
    
    //MARK - Add new Items
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField() // creating this variable so it can be accessed by all the completion handlers! we're increasing the scope.
        let alert = UIAlertController(title: "Add new todoey item", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            //What will happen once the user clicks the add item button
            let newItem = Item(context: self.context)//specifying the context in which this class object will exist.. entities are like classes
            newItem.title = textField.text!
            newItem.done = false
            newItem.parentCategory = self.selectedCategory
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
       
        do {
        try context.save()
        } catch {
            print("error saving context , \(error)")
            
        }
        self.tableView.reloadData()
}
    //external parameter with, internal request, intenrnal used inside load items, external used when called, with default value
    func loaditems(with request: NSFetchRequest<Item> = Item.fetchRequest(), predicate: NSPredicate? = nil) {
        let categoryPredicate = NSPredicate(format: "parentCategory.name MATCHES %@", selectedCategory!.name!)
        //optional binding only executed if predicate not empty
        if let additionalPredicate = predicate {
            request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates:[categoryPredicate,additionalPredicate])
        } else {
            request.predicate = categoryPredicate
        }
        do {
            itemArray = try context.fetch(request)
        } catch {
            print("ERROR fetching data from request \(error)")
        }
    }
   
}
// try to split up fonctionalities for code organization and debug it easier
//MARK: - Search bar Methods
extension TodoListViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let request : NSFetchRequest<Item> = Item.fetchRequest()
        request.predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!) //which items have a title that contains the searchBar.text not case and diacretic sensitive caps accents etc
        
        request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
        loaditems(with: request)
        
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
