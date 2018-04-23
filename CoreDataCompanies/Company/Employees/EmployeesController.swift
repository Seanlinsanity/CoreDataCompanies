//
//  EmployeesController.swift
//  CoreDataCompanies
//
//  Created by SEAN on 2018/4/20.
//  Copyright © 2018年 SEAN. All rights reserved.
//

import UIKit
import CoreData

class IndentedLabel: UILabel {
    override func drawText(in rect: CGRect) {
        let insets = UIEdgeInsetsMake(0, 16, 0, 0)
        let customRect = UIEdgeInsetsInsetRect(rect, insets)
        super.drawText(in: customRect)
    }
}


class EmployeesController: UITableViewController, CreateEmployeeControllerDelegate {
    
    func didAddEmployee(employee: Employee) {
        employees.append(employee)
        tableView.reloadData()
    }
    
    let cellId = "cellId"
    var company: Company?
    var employees = [Employee]()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationItem.title = company?.name
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.backgroundColor = UIColor.darkBlue
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellId)
        
        setupPlusButtonInNavBar(selector: #selector(handleAdd))
        fetchEmployees()

    }
    
    
    var shortNameEmployees = [Employee]()
    var longNameEmployees = [Employee]()
    
    var allEmployees = [[Employee]]()
    
    private func fetchEmployees(){
        guard let companyEmployees = company?.employees?.allObjects as? [Employee] else { return }
        employees = companyEmployees
        
        shortNameEmployees = companyEmployees.filter({ (employee) -> Bool in
            if let count = employee.name?.count{
                return count < 13
            }
            return false
        })
        
        longNameEmployees = companyEmployees.filter({ (employee) -> Bool in
            if let count = employee.name?.count{
                return count >= 13
            }
            return false
        })
        
        allEmployees = [shortNameEmployees, longNameEmployees]
        
//        let context = CoreDataManager.shared.persistentContainer.viewContext
//        let request = NSFetchRequest<Employee>(entityName: "Employee")
//
//        do{
//            let employees = try context.fetch(request)
//            employees.forEach({print($0.name ?? "")})
//            self.employees = employees
//
//        }catch let err {
//            print("Failed to fetch employees:" ,err)
//        }
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return allEmployees.count
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let label = IndentedLabel()
        
        if section == 0{
            label.text = "Short names"
        }else if section == 1{
            label.text = "Long names"
        }else{
            label.text = "Really long names"
        }
        label.backgroundColor = .lightBlue
        label.textColor = .darkBlue
        label.font = UIFont.boldSystemFont(ofSize: 16)
        return label
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return allEmployees[section].count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath)
        
        let employee = allEmployees[indexPath.section][indexPath.row]

        cell.textLabel?.text = employee.name
        if let birthday = employee.employeeInformation?.birthday{
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "MMM dd, yyyy"
            cell.textLabel?.text = "\(employee.name ?? "") - \(dateFormatter.string(from: birthday))"
        }
        
        cell.backgroundColor = .tealColor
        cell.textLabel?.textColor = .white
        cell.textLabel?.font = UIFont.boldSystemFont(ofSize: 15)
        return cell
    }
    
    @objc private func handleAdd(){
        let createEmployeeController = CreateEmployeeController()
        createEmployeeController.delegate = self
        createEmployeeController.company = company
        let navController = UINavigationController(rootViewController: createEmployeeController)
        present(navController, animated: true, completion: nil)
    }
    
}
