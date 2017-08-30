//
//  EditDetailViewController.swift
//  SampleContacts
//
//  Created by Julian Pratama on 2017-08-29.
//  Copyright © 2017 Julian. All rights reserved.
//

import Foundation
import UIKit
import AERecord

class EditDetailViewController: UIViewController, EditDetailProtocol,UITableViewDataSource,UITableViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate
{
    var presenter: EditDetailPresenterProtocol?
    var detailItem: Contact?
    var imagePicker: UIImagePickerController!
    var addFlag = false
    
    @IBOutlet weak var profilePic: UIImageView!
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var bottomTableView: UITableView!
    
    
    override func viewDidLoad() {
        self.bottomTableView.delegate = self
        self.bottomTableView.dataSource = self
        self.bottomTableView.allowsSelection = false;
        
        let colors = Colors()
        topView.backgroundColor = UIColor.clear
        let backgroundLayer = colors.gl
        backgroundLayer?.frame = self.view.frame
        topView.layer.insertSublayer(backgroundLayer!, at: 0)
        
        navigationController?.navigationBar.tintColor = UIColor(red: 80.0 / 255.0, green: 227.0 / 255.0, blue: 194.0 / 255.0, alpha: 1)
        
        configureView()
        
        let photoGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(editPhotoAction(tapGestureRecognizer:)))
        profilePic.addGestureRecognizer(photoGestureRecognizer)

        let doneButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.done, target: self, action: #selector(EditDetailViewController.doneAction))
        navigationItem.rightBarButtonItem = doneButton


        
        super.viewDidLoad()
    }
    
    func goBack()
    {
        _ = navigationController?.popViewController(animated: true)
    }
    
    func display(message: String) {
        let alertController = UIAlertController(title: "Success", message: message, preferredStyle: .alert)
        let OKAction = UIAlertAction(title: "OK", style: .default) { action in
            _ = self.navigationController?.popViewController(animated: true)
        }
        alertController.addAction(OKAction)
        self.present(alertController,animated:true)
    }
    
    func display(errorMessage: String) {
        let alertController = UIAlertController(title: "Error", message: errorMessage, preferredStyle: .alert)
        let OKAction = UIAlertAction(title: "OK", style: .default) { action in
        }
        alertController.addAction(OKAction)
        self.present(alertController,animated:true)
    }

    
    func doneAction()
    {
        let cell0 = bottomTableView.cellForRow(at: IndexPath.init(row: 0, section: 0)) as! EditDetailCell
        let cell1 = bottomTableView.cellForRow(at: IndexPath.init(row: 1, section: 0)) as! EditDetailCell
        let cell2 = bottomTableView.cellForRow(at: IndexPath.init(row: 2, section: 0)) as! EditDetailCell
        let cell3 = bottomTableView.cellForRow(at: IndexPath.init(row: 3, section: 0)) as! EditDetailCell
        
        let firstName = cell0.valueLabel.text
        let lastName = cell1.valueLabel.text
        let phone = cell2.valueLabel.text
        let email = cell3.valueLabel.text
        
        if firstName == ""
        {
            self.display(errorMessage: "First name can't be empty.")
            return
        }
        if lastName == ""
        {
            self.display(errorMessage: "Last name can't be empty.")
            return
        }
        if phone == ""
        {
            self.display(errorMessage: "Phone number can't be empty.")
            return
        }
        if email == ""
        {
            self.display(errorMessage: "Email can't be empty.")
            return
        }
        if phoneValidate(value: phone!) == false
        {
            self.display(errorMessage: "Invalid phone number.")
            return
        }
        if isValidEmail(testStr: email!) == false
        {
            self.display(errorMessage: "Invalid email address.")
            return
        }
        
        
        
        
        if let contact = detailItem
        {
            contact.firstName = firstName
            contact.lastName = lastName
            contact.phone = phone
            contact.email = email
            AERecord.saveAndWait()
            presenter?.updateContact(contact: contact, add: false)

        }
        else
        {
            if addFlag == true
            {
                if let newContact = Contact.create() as Contact?
                {
                    newContact.firstName = firstName
                    newContact.lastName = lastName
                    newContact.phone = phone
                    newContact.email = email
                    AERecord.saveAndWait()
                    presenter?.updateContact(contact: newContact, add: true)
                }
            }
        }
        
    }
    
    func editPhotoAction(tapGestureRecognizer: UITapGestureRecognizer)
    {
        let alertController = UIAlertController(title: "Upload Photo", message: "", preferredStyle: .alert)
        let cameraAction = UIAlertAction(title: "Camera", style: .default) { action in
            self.imagePicker =  UIImagePickerController()
            self.imagePicker.delegate = self
            self.imagePicker.sourceType = .camera
            self.present(self.imagePicker, animated: true, completion: nil)
        }
        let libraryAction = UIAlertAction(title: "Library", style: .default) { action in
            self.imagePicker =  UIImagePickerController()
            self.imagePicker.delegate = self
            self.imagePicker.sourceType = .photoLibrary
            self.present(self.imagePicker, animated: true, completion: nil)
        }

        
        alertController.addAction(cameraAction)
        alertController.addAction(libraryAction)
        self.present(alertController,animated:true)
        
        
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        imagePicker.dismiss(animated: true, completion: nil)
        profilePic.image = info[UIImagePickerControllerOriginalImage] as? UIImage
    }
    
    func configureView()
    {
        self.bottomTableView.tableFooterView = UIView()
        profilePic.image = #imageLiteral(resourceName: "contactPlaceholder")
        if let detail = detailItem as Contact? {
            if let profile = detail.profilePic
            {
                if profile != "" && profile != "/images/missing.png"
                {
                    profilePic.kf.indicatorType = .activity
                    let profileURL = URL(string: profile)!
                    profilePic.kf.setImage(with: profileURL, completionHandler: {
                        (image, error, cacheType, imageUrl) in
                        if error != nil
                        {
                            self.profilePic.image = #imageLiteral(resourceName: "contactPlaceholder")
                        }
                    })
                }

            }
        }
        
        Utility.circleImage(image: profilePic)
        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       
        return 4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "EditDetailCell", for: indexPath) as? EditDetailCell
        cell?.valueLabel.text = ""
        switch indexPath.row
        {
        case 0:
            cell?.titleLabel.text = "First Name"
            if let first = detailItem?.firstName
            {
                cell?.valueLabel.text = first
            }
            
        case 1:
            cell?.titleLabel.text = "Last Name"
            if let last = detailItem?.lastName
            {
                cell?.valueLabel.text = last
            }
        case 2:
            cell?.titleLabel.text = "mobile"
            if let phone = detailItem?.phone
            {
                cell?.valueLabel.text = phone
                cell?.valueLabel.keyboardType = .phonePad

            }
        case 3:
            cell?.titleLabel.text = "email"
            if let email = detailItem?.email
            {
                cell?.valueLabel.text = email
                cell?.valueLabel.keyboardType = .emailAddress
            }
        
        default:
            return cell!
        }
        
        return cell!
    }
    
    func isValidEmail(testStr:String) -> Bool {
        print("validate emilId: \(testStr)")
        let emailRegEx = "^(?:(?:(?:(?: )*(?:(?:(?:\\t| )*\\r\\n)?(?:\\t| )+))+(?: )*)|(?: )+)?(?:(?:(?:[-A-Za-z0-9!#$%&’*+/=?^_'{|}~]+(?:\\.[-A-Za-z0-9!#$%&’*+/=?^_'{|}~]+)*)|(?:\"(?:(?:(?:(?: )*(?:(?:[!#-Z^-~]|\\[|\\])|(?:\\\\(?:\\t|[ -~]))))+(?: )*)|(?: )+)\"))(?:@)(?:(?:(?:[A-Za-z0-9](?:[-A-Za-z0-9]{0,61}[A-Za-z0-9])?)(?:\\.[A-Za-z0-9](?:[-A-Za-z0-9]{0,61}[A-Za-z0-9])?)*)|(?:\\[(?:(?:(?:(?:(?:[0-9]|(?:[1-9][0-9])|(?:1[0-9][0-9])|(?:2[0-4][0-9])|(?:25[0-5]))\\.){3}(?:[0-9]|(?:[1-9][0-9])|(?:1[0-9][0-9])|(?:2[0-4][0-9])|(?:25[0-5]))))|(?:(?:(?: )*[!-Z^-~])*(?: )*)|(?:[Vv][0-9A-Fa-f]+\\.[-A-Za-z0-9._~!$&'()*+,;=:]+))\\])))(?:(?:(?:(?: )*(?:(?:(?:\\t| )*\\r\\n)?(?:\\t| )+))+(?: )*)|(?: )+)?$"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        let result = emailTest.evaluate(with: testStr)
        return result
    }
    
    func phoneValidate(value: String) -> Bool {
        let PHONE_REGEX = "^\\d{3}-\\d{3}-\\d{4}$"
        let phoneTest = NSPredicate(format: "SELF MATCHES %@", PHONE_REGEX)
        let result =  phoneTest.evaluate(with: value)
        return result
    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
