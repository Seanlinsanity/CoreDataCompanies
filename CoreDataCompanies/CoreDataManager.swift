//
//  CoreDataManager.swift
//  CoreDataCompanies
//
//  Created by SEAN on 2018/4/13.
//  Copyright © 2018年 SEAN. All rights reserved.
//

import CoreData

struct CoreDataManager {
    
    static let shared = CoreDataManager()   //will live forever as long as app is still alive, it's properties will too
    
    //initialization of Core Data stack
    let persistentContainer: NSPersistentContainer = {
        
        let container = NSPersistentContainer(name: "DataModel")
        container.loadPersistentStores { (storeDescription, err) in
            
            if let err = err {
                fatalError("Loading of store failed: \(err)")
            }
        }
        
        return container
    }()
    
    func fetchCompanies() -> [Company]{
        
        let context = persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<Company>(entityName: "Company")
        
        do{
            let companies = try context.fetch(fetchRequest)
            return companies
            
        }catch let fetchErr{
            print("failed to fetch company:", fetchErr)
            return []
        }
    }
    
    func createEmpolyee(employeeName: String, company: Company) -> (Employee?, Error?){
        let context = persistentContainer.viewContext
        let employee = NSEntityDescription.insertNewObject(forEntityName: "Employee", into: context) as! Employee
        employee.company = company
        employee.setValue(employeeName, forKey: "name")
        
        let employeeInfomation = NSEntityDescription.insertNewObject(forEntityName: "EmployeeInformation", into: context) as! EmployeeInformation
        employeeInfomation.taxid = "30"
        
        employee.employeeInformation = employeeInfomation
        
        do {
            try context.save()
            return (employee, nil)
        } catch let err {
            print("Failed to create employee:", err)
            return (nil ,err)
        }
    }
    

}
