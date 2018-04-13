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
    

}
