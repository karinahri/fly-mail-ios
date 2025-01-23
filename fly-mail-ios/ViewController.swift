//
//  ViewController.swift
//  fly-mail-ios
//
//  Created by Karina Dolmatova on 21.01.2025.
//
import CoreData
import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "The List"
        tableView.register(UITableViewCell.self,forCellReuseIdentifier: "Cell")
        CoreDataManager.shared.fetchData()
        tableView.reloadData()
        
    }
    
    @IBAction func addName(_ sender: Any) {
        let alert = UIAlertController(title: "New Name", message: "Add a new name", preferredStyle: .alert)
        
        let saveAction = UIAlertAction(title: "Save", style: .default) { [unowned self] action in
            guard let textField = alert.textFields?.first,
                  let nameToSave = textField.text else {
                return
            }
            CoreDataManager.shared.save(name: nameToSave)
            self.tableView.reloadData()
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        alert.addTextField()
        alert.addAction(saveAction)
        alert.addAction(cancelAction)
        present(alert, animated: true)
    }
}

extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return CoreDataManager.shared.people.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let person = CoreDataManager.shared.people[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell",for: indexPath)
        cell.textLabel?.text = person.value(forKeyPath: "name") as? String
        return cell
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete {
            CoreDataManager.shared.deleteObject(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
}
