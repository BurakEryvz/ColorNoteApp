//
//  TodoViewController.swift
//  TodoListUsingRealm
//
//  Created by Burak Eryavuz on 25.06.2023.
//

import UIKit
import RealmSwift


class TodoViewController: UITableViewController {
    
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    let realm = try! Realm()
    
    var itemArray : Results<Item>?
    
    var selectedCategory : Category? {
        didSet{
            loadItems()
        }
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        searchBar.delegate = self
        
        
        
    }
    
    // MARK: - TableView Data Source Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ItemTableCell", for: indexPath)
        
        if let item = itemArray?[indexPath.row] {
            cell.textLabel?.text = item.title
            cell.accessoryType = item.isCheck ? .checkmark : .none
        }else {
            cell.textLabel?.text = "Not items added yet."
        }
        
        return cell
    }
    
    
    
    // MARK: - TableView Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
        if let item = itemArray?[indexPath.row] {
            do{
                try realm.write({
                    item.isCheck = !item.isCheck
                })
            }catch{
                print("Error saving data \(error)")
            }
            
        }
        
        tableView.reloadData()
        
        
        //secilen itemin yanıp sonerek secilmesini saglar.
        tableView.deselectRow(at: indexPath, animated: true)
        
        
    }
    
    

    
   //MARK: - Add Button Method
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New List Item", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            // what will happen once the user clicks the add item button on our UIALert
           
            if let currentCategory = self.selectedCategory {
                do{
                    try self.realm.write({
                        let newItem = Item()
                        newItem.title = textField.text!
                        newItem.isCheck = false
                        currentCategory.items.append(newItem)
                    })
                }catch{
                    print("Error saving item \(error)")
                }
                
            }
            
            
            self.tableView.reloadData()
        }
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create New Item"
            
            textField = alertTextField
        }
        
        //Alert'e action ekledik.
        alert.addAction(action)
        
        //Alert'i gostermek icin.
        present(alert, animated: true)
        
    }
    
    // MARK: - Model Manupulation Methods
    
    
    
    func saveItems(object : Object) {


        do{
            try realm.write({
                realm.add(object)
            })
        }catch{
            print("Error saving items \(error)")
        }

    }
    
    
    func loadItems() {
        itemArray = selectedCategory?.items.sorted(byKeyPath: "title", ascending: true)

        tableView.reloadData()

    }
    

   
}

// MARK: - Search Bar Methods
extension TodoViewController: UISearchBarDelegate {

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {


        if searchBar.text == "" {
            self.loadItems()
            tableView.reloadData()
        } else {
            
            itemArray = itemArray?.filter("title CONTAINS[cd] %@", searchBar.text!).sorted(byKeyPath: "title", ascending: true)

            tableView.reloadData()
        }

    }

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0 {
            loadItems()
            tableView.reloadData()


        }
        else {
            searchBarSearchButtonClicked(searchBar.self)
        }
    }

}
