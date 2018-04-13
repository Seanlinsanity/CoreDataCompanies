//
//  CreateCompanyController.swift
//  CoreDataCompanies
//
//  Created by SEAN on 2018/3/31.
//  Copyright © 2018年 SEAN. All rights reserved.
//

import UIKit
import CoreData

protocol AddCompanyDelegate {
    func addCompany(company: Company)
}

class CreateCompanyController: UIViewController {
    
    var delegate: AddCompanyDelegate?
    
    let nameLabel: UILabel = {
        let lb = UILabel()
        lb.text = "Name"
        lb.translatesAutoresizingMaskIntoConstraints = false
        return lb
    }()
    
    let nameTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Enter name..."
        tf.translatesAutoresizingMaskIntoConstraints = false
        return tf
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.darkBlue
        
        navigationItem.title = "Create Company"
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(handleCancel))
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Save", style: .plain, target: self, action: #selector(handleSave))
        
        setupUI()
    }
    
    private func setupUI(){
        
        let lightBlueBackgroundView = UIView()
        lightBlueBackgroundView.backgroundColor = .lightBlue
        lightBlueBackgroundView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(lightBlueBackgroundView)
        lightBlueBackgroundView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        lightBlueBackgroundView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        lightBlueBackgroundView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        lightBlueBackgroundView.heightAnchor.constraint(equalToConstant: 300).isActive = true
        
        view.addSubview(nameLabel)
        nameLabel.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        nameLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 16).isActive = true
        nameLabel.widthAnchor.constraint(equalToConstant: 100).isActive = true
        nameLabel.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        view.addSubview(nameTextField)
        nameTextField.topAnchor.constraint(equalTo: nameLabel.topAnchor).isActive = true
        nameTextField.leftAnchor.constraint(equalTo: nameLabel.rightAnchor).isActive = true
        nameTextField.heightAnchor.constraint(equalTo: nameLabel.heightAnchor).isActive = true
        nameTextField.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        
        
    }
    
    @objc private func handleSave(){
                
        let context = CoreDataManager.shared.persistentContainer.viewContext
        let company = NSEntityDescription.insertNewObject(forEntityName: "Company", into: context)
        
        guard let companyName = nameLabel.text else { return }
        company.setValue(companyName, forKey: "name")
        
        //preform the save
        do{
            try context.save()
            
            dismiss(animated: true) {
                self.delegate?.addCompany(company: company as! Company)
            }
            
        }catch let saveErr {
            print("failed to save company:", saveErr)
        }

    }
    
    @objc private func handleCancel(){
        dismiss(animated: true, completion: nil)
    }
    
    
}
