//
//  CustomMigrationPolicy.swift
//  CoreDataCompanies
//
//  Created by SEAN on 2018/5/10.
//  Copyright © 2018年 SEAN. All rights reserved.
//

import CoreData

class CustomMigrationPolicy: NSEntityMigrationPolicy{
    
    @objc func transformNumEmployees(forNum: NSNumber) -> String{
        if forNum.intValue < 150{
            return "small"
        }else{
            return "very large"
        }
    }
    
}
