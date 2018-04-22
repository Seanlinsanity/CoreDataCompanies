//
//  CompaniesController+createCompany.swift
//  CoreDataCompanies
//
//  Created by SEAN on 2018/4/20.
//  Copyright © 2018年 SEAN. All rights reserved.
//

import UIKit

extension CompaniesController: AddCompanyDelegate{
    
    func addCompany(company: Company) {
        companies.append(company)
        let newIndexPath = IndexPath(row: companies.count - 1 , section: 0)
        
        tableView.insertRows(at: [newIndexPath], with: .automatic)
    }
    
    func didEditCompany(company: Company){
        
        let row = companies.index(of: company)
        let reloadIndexPahth = IndexPath(row: row!, section: 0)
        tableView.reloadRows(at: [reloadIndexPahth], with: .middle)
    }
    
}
