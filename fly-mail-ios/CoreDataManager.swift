//
//  CoreDataManager.swift
//  fly-mail-ios
//
//  Created by Karina Dolmatova on 22.01.2025.
//

import Foundation
import CoreData
import UIKit

class CoreDataManager {
    
    static let shared = CoreDataManager()
    private init() {}
    var people: [NSManagedObject] = []
    
    func save(name: String) {
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        let entity = NSEntityDescription.entity(forEntityName: "Person", in: managedContext)!
        let person = NSManagedObject(entity: entity, insertInto: managedContext)
        person.setValue(name, forKeyPath: "name")
        
        do {
            try managedContext.save()
            people.append(person)
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }
    
    func deleteObject(at index: Int) {
        guard index < people.count else { return }
        
        let personToDelete = people[index]
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        do {
            managedContext.delete(personToDelete)
            try managedContext.save()
            people.remove(at: index)
        } catch {
            print("Could not delete: \(error)")
        }
    }
    
    func fetchData() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Person")
        
        do {
            people = try managedContext.fetch(fetchRequest)
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
    }
}
