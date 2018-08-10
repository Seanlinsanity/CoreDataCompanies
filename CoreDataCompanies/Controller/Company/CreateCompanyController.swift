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
    func didEditCompany(company: Company)
}

class CreateCompanyController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    var delegate: AddCompanyDelegate?
    var company: Company?{
        didSet{
            nameTextField.text = company?.name
            if let founded = company?.founded{
                datePicker.date = founded
            }
            if let imageData = company?.imageData{
                companyImageView.image = UIImage(data: imageData)
                setupCircularImageStyle()
            }
        }
    }
    
    lazy var companyImageView: UIImageView = {
        let iv = UIImageView(image: #imageLiteral(resourceName: "select_photo_empty"))
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.contentMode = .scaleAspectFill
        iv.isUserInteractionEnabled = true
        iv.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleSelectPhoto)))
        return iv
    }()
    
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
    
    let datePicker: UIDatePicker = {
        let dp = UIDatePicker()
        dp.datePickerMode = .date
        dp.translatesAutoresizingMaskIntoConstraints = false
        return dp
    }()
    
    override func viewWillAppear(_ animated: Bool) {
        navigationItem.title = company == nil ? "Create Company" : "Edit Company"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.darkBlue
        
        setupCancelButtonInNavBar(selector: #selector(handleCancel))
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Save", style: .plain, target: self, action: #selector(handleSave))
        
        setupUI()
    }
    
    private func setupUI(){
        
        let lightBlueBackgroundView = setupLightBlueBackgroundView(height: 350)
        
        view.addSubview(companyImageView)
        companyImageView.topAnchor.constraint(equalTo: view.topAnchor, constant: 8).isActive = true
        companyImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        companyImageView.widthAnchor.constraint(equalToConstant: 100).isActive = true
        companyImageView.heightAnchor.constraint(equalToConstant: 100).isActive = true
        
        view.addSubview(nameLabel)
        nameLabel.topAnchor.constraint(equalTo: companyImageView.bottomAnchor).isActive = true
        nameLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 16).isActive = true
        nameLabel.widthAnchor.constraint(equalToConstant: 100).isActive = true
        nameLabel.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        view.addSubview(nameTextField)
        nameTextField.topAnchor.constraint(equalTo: nameLabel.topAnchor).isActive = true
        nameTextField.leftAnchor.constraint(equalTo: nameLabel.rightAnchor).isActive = true
        nameTextField.heightAnchor.constraint(equalTo: nameLabel.heightAnchor).isActive = true
        nameTextField.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        
        view.addSubview(datePicker)
        datePicker.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 0).isActive = true
        datePicker.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 0).isActive = true
        datePicker.rightAnchor.constraint(equalTo: view.rightAnchor, constant: 0).isActive = true
        datePicker.bottomAnchor.constraint(equalTo: lightBlueBackgroundView.bottomAnchor, constant: 0).isActive = true
    }
    
    @objc private func handleSave(){
        if company == nil{
            createCompany()
        }else{
            saveCompanyChanges()
        }
    }
    
    private func saveCompanyChanges(){
        let context = CoreDataManager.shared.persistentContainer.viewContext
        company?.name = nameTextField.text
        company?.founded = datePicker.date
        
        if let image = companyImageView.image{
            let imageData = UIImageJPEGRepresentation(image, 0.8)
            company?.imageData = imageData
        }
        
        do{
            try context.save()
            
            dismiss(animated: true) {
                self.delegate?.didEditCompany(company: self.company!)
            }
            
        }catch let saveErr {
            print("failed to save company changes:", saveErr)
        }
        
    }
    
    private func createCompany(){
        let context = CoreDataManager.shared.persistentContainer.viewContext
        let company = NSEntityDescription.insertNewObject(forEntityName: "Company", into: context)
        
        guard let companyName = nameTextField.text else { return }

        company.setValue(companyName, forKey: "name")
        company.setValue(datePicker.date, forKey: "founded")
        
        if let companyImage = companyImageView.image{
            let imageData = UIImageJPEGRepresentation(companyImage, 0.8)
            company.setValue(imageData, forKey: "imageData")
        }
        
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
    
    @objc private func handleSelectPhoto(){
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        imagePickerController.allowsEditing = true
        
        present(imagePickerController, animated: true, completion: nil)
        
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        if let editedImage = info[UIImagePickerControllerEditedImage] as? UIImage{
            companyImageView.image = editedImage
        }else if let originalImage = info[UIImagePickerControllerOriginalImage] as? UIImage{
            companyImageView.image = originalImage
        }
        setupCircularImageStyle()
        
        dismiss(animated: true, completion: nil)
    }
    
    private func setupCircularImageStyle(){
        companyImageView.layer.cornerRadius = companyImageView.frame.width / 2
        companyImageView.clipsToBounds = true
        companyImageView.layer.borderColor = UIColor.darkBlue.cgColor
        companyImageView.layer.borderWidth = 2
    }
    
    @objc private func handleCancel(){
        dismiss(animated: true, completion: nil)
    }
    
    
}
