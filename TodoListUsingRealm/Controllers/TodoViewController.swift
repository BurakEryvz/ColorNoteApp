//
//  TodoViewController.swift
//  TodoListUsingRealm
//
//  Created by Burak Eryavuz on 25.06.2023.
//

import UIKit
import RealmSwift
import SwipeCellKit
import ChameleonFramework


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
        searchBar.delegate = self
        
        tableView.rowHeight = 80.0
        tableView.separatorEffect = .none
        
        
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        var color = selectedCategory?.categoryColorName
        navigationController?.navigationBar.barTintColor = UIColor(hexString: color!)
        navigationController?.navigationBar.backgroundColor = UIColor(hexString: color!)
        title = selectedCategory?.name
        searchBar.barTintColor = UIColor(hexString: color!)
        searchBar.tintColor = UIColor.white
        
        
    }
    
    // MARK: - TableView Data Source Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ItemTableCell", for: indexPath) as! SwipeTableViewCell
        
        if let item = itemArray?[indexPath.row] {
            cell.textLabel?.text = item.title
            cell.accessoryType = item.isCheck ? .checkmark : .none
            var color = selectedCategory?.categoryColorName
            cell.backgroundColor = UIColor(hexString: color!)!.darken(byPercentage: CGFloat(indexPath.row)/CGFloat(itemArray!.count))
            cell.textLabel?.textColor = .white
            
            
        }else {
            cell.textLabel?.text = "Not items added yet."
            cell.backgroundColor = .white
        }
        
        
        cell.delegate = self
        
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
                        newItem.itemColorName = UIColor.randomFlat().hexValue()
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

extension TodoViewController : SwipeTableViewCellDelegate {
    
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
        guard orientation == .right else { return nil }

        let deleteAction = SwipeAction(style: .destructive, title: "Delete") { action, indexPath in
            
            if let itemForDeletion = self.itemArray?[indexPath.row] {
                
                do{
                    try self.realm.write({
                        self.realm.delete(itemForDeletion)
                    })
                }catch{
                    print(error)
                }
                
                self.tableView.reloadData()
            }
            
        }

        // customize the action appearance
        deleteAction.image = UIImage(named: "Trash Icon")
        

        return [deleteAction]
    }
    
}
