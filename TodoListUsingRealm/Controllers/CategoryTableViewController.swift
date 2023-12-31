//
//  CategoryTableViewController.swift
//  TodoListUsingRealm
//
//  Created by Burak Eryavuz on 25.06.2023.
//

import UIKit
import RealmSwift
import SwipeCellKit
import ChameleonFramework



class CategoryTableViewController: UITableViewController {
    
    let realm = try! Realm()
    
    
    
    
    // Results veri tipi otomatik guncellenen bir list yapisidir.
    // Bu yuzden de append vb. seyler kullanmamiza gerek yoktur.
    var categories : Results<Category>?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.loadCategory()
        
        tableView.rowHeight = 80.0
        tableView.separatorEffect = .none
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.navigationBar.barTintColor = UIColor.flatSkyBlue()
        navigationController?.navigationBar.backgroundColor = UIColor.flatSkyBlue()
        title = "ColorNote"
        
        
        
        
        
        
        
        

    }
    
    // MARK: - Add Button Method
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New Category", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add", style: .default) { (action) in
            
            if textField.text != "" {
                
                let newCategory = Category()
                newCategory.name = textField.text!
                newCategory.categoryColorName = UIColor.randomFlat().hexValue()
                
                self.saveCategory(object: newCategory)
                self.tableView.reloadData()
            }else {
                let newCategory = Category()
                newCategory.name = "Başlıksız Kategori"
                
                self.saveCategory(object: newCategory)
                self.tableView.reloadData()
            }
        }
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create New Category"
            textField = alertTextField
        }
        
        alert.addAction(action)
        
        present(alert, animated: true)
        
        
    }
    
    //MARK: - TableView DataSource Methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath) as! SwipeTableViewCell
        
        cell.textLabel?.text = categories?[indexPath.row].name ?? "No categories added yet."
        var color = categories?[indexPath.row].categoryColorName
        cell.backgroundColor = UIColor(hexString: color!)
        cell.textLabel?.textColor = .white
        
        cell.delegate = self
        
        return cell
    }
    
    
    
    //MARK: - TableView Delegate Methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        performSegue(withIdentifier: "goToItems", sender: nil)
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let destinationVC = segue.destination as! TodoViewController
        
        if let indexPath = tableView.indexPathForSelectedRow {
            destinationVC.selectedCategory = categories?[indexPath.row]
        }
    }
    
    //MARK: - Data Manipulation Methods
    func saveCategory(object: Object) {
        
        do {
            try realm.write({
                realm.add(object)
            })
        } catch {
            print("Error save category \(error.localizedDescription)")
        }
    }
    
    func loadCategory() {
        
        categories = realm.objects(Category.self)
        
        tableView.reloadData()
        
        
    }
    
    

}




extension CategoryTableViewController : SwipeTableViewCellDelegate {
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
        guard orientation == .right else { return nil }

        let deleteAction = SwipeAction(style: .destructive, title: "Delete") { action, indexPath in
            
            if let categoryForDeletion = self.categories?[indexPath.row] {
                
                do{
                    try self.realm.write({
                        self.realm.delete(categoryForDeletion)
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

