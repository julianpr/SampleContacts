//
//  ContactDetailViewController.swift
//  SampleContacts
//
//  Created by Julian Pratama on 2017-08-23.
//  Copyright © 2017 Julian. All rights reserved.
//

import UIKit
import AERecord
import Foundation
import MessageUI
import Messages

class ContactDetailViewController: UIViewController, ContactDetailProtocol, UITableViewDelegate, UITableViewDataSource, MFMessageComposeViewControllerDelegate, MFMailComposeViewControllerDelegate {

    @IBOutlet weak var bottomTableView: UITableView!
    @IBOutlet weak var favoriteButton: UIImageView!
    @IBOutlet weak var emailButton: UIImageView!
    @IBOutlet weak var callButton: UIImageView!
    @IBOutlet weak var messageButton: UIImageView!
    @IBOutlet weak var profilePicImage: UIImageView!
    @IBOutlet weak var fullNameLabel: UILabel!
    @IBOutlet weak var topView: UIView!
    
    var presenter: ContactDetailPresenterProtocol?
    var detailItem: Contact?
    
    
    func display(message: String) {
        let alertController = UIAlertController(title: "Success", message: message, preferredStyle: .alert)
        let OKAction = UIAlertAction(title: "OK", style: .default) { action in  }
        alertController.addAction(OKAction)
        self.present(alertController,animated:true)
    }
    
    func display(errorMessage: String) {
        let alertController = UIAlertController(title: "Error", message: errorMessage, preferredStyle: .alert)
        let OKAction = UIAlertAction(title: "OK", style: .default) { action in  }
        alertController.addAction(OKAction)
        self.present(alertController,animated:true)
    }
    
    func configureView()
    {
        self.bottomTableView.tableFooterView = UIView()
        
        if let detail = detailItem as Contact? {
            fullNameLabel.text = (detail.firstName ?? "") + " " + (detail.lastName ?? "")
            if let profile = detail.profilePic
            {
                if profile != "" && profile != "/images/missing.png"
                {
                    profilePicImage.kf.indicatorType = .activity
                    let profileURL = URL(string: profile)!
                    profilePicImage.kf.setImage(with: profileURL, completionHandler: {
                        (image, error, cacheType, imageUrl) in
                        if error != nil
                        {
                            self.profilePicImage.image = #imageLiteral(resourceName: "contactPlaceholder")
                        }
                    })
                }
                else
                {
                    profilePicImage.image = #imageLiteral(resourceName: "contactPlaceholder")
                }
            }

            favoriteButton.isHighlighted = detail.favorite
            Utility.circleImage(image: profilePicImage)

        
        }
    }
    
    func reloadData(contact:Contact) {
        detailItem = contact
        self.bottomTableView.reloadData()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var count = 0
        if let _ = detailItem?.email
        {
            count = count + 1
        }
        
        if let _ = detailItem?.phone
        {
            count = count + 1
        }
        
        return count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ContactDetailCell", for: indexPath) as? ContactDetailCell
        switch indexPath.row
        {
        case 0:
            if let email = detailItem?.email
            {
                cell?.titleLabel.text = "email"
                cell?.valueLabel.text = email
            }
        case 1:
            if let phone = detailItem?.phone
            {
                cell?.titleLabel.text = "mobile"
                cell?.valueLabel.text = phone
            }
        default:
            return cell!
        }
        
        return cell!
    }
    
    func messageComposeViewController(_ controller: MFMessageComposeViewController, didFinishWith result: MessageComposeResult) {
        switch (result) {
        case MessageComposeResult.cancelled:
            print("Message was cancelled")
            self.dismiss(animated: true, completion: nil)
        case MessageComposeResult.failed:
            print("Message failed")
            self.dismiss(animated: true, completion: nil)
        case MessageComposeResult.sent:
            print("Message was sent")
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    func messageAction(tapGestureRecognizer: UITapGestureRecognizer)
    {
        
        // Your action
        if let contact = detailItem as Contact?,
            let phone = contact.phone as String?
        {
            let messageVC = MFMessageComposeViewController()
            messageVC.recipients = [phone]
            messageVC.messageComposeDelegate = self;
            
            self.present(messageVC, animated: false, completion: nil)
            
        }
        
    }
    
    func callAction(tapGestureRecognizer: UITapGestureRecognizer)
    {
        // Your action
        if let contact = detailItem as Contact?,
            let phone = contact.phone as String?
        {
            guard let number = URL(string: "tel://" + phone) else { return }
            UIApplication.shared.open(number)
        }
    }
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true, completion: nil)
    }
    func emailAction(tapGestureRecognizer: UITapGestureRecognizer)
    {
        // Your action
        if let contact = detailItem as Contact?,
            let email = contact.email as String?
        {
            let composeVC = MFMailComposeViewController()
            composeVC.mailComposeDelegate = self
            // Configure the fields of the interface.
            composeVC.setToRecipients([email])
            // Present the view controller modally.
            self.present(composeVC, animated: true, completion: nil)
        }
    }
    
    func favoriteAction(tapGestureRecognizer: UITapGestureRecognizer)
    {
        let tappedImage = tapGestureRecognizer.view as! UIImageView
        // Your action
        if let contact = detailItem as Contact?
        {
            tappedImage.isHighlighted = !tappedImage.isHighlighted
            contact.favorite = tappedImage.isHighlighted
            AERecord.saveAndWait()
            
            presenter?.updateContact(id: contact.id)
        }
        
    }
    
    func linkActions()
    {
        let messageGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(messageAction(tapGestureRecognizer:)))
        messageButton.addGestureRecognizer(messageGestureRecognizer)
        
        let callGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(callAction(tapGestureRecognizer:)))
        callButton.addGestureRecognizer(callGestureRecognizer)
        
        let emailGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(emailAction(tapGestureRecognizer:)))
        emailButton.addGestureRecognizer(emailGestureRecognizer)
        
        let favoriteGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(favoriteAction(tapGestureRecognizer:)))
        favoriteButton.addGestureRecognizer(favoriteGestureRecognizer)

    }
    
    func editAction()
    {
        presenter?.editAction(navigationController: self.navigationController!, contact: detailItem!)

    }

    override func viewDidLoad() {
        presenter?.loadContactData(id: detailItem!.id)

        self.bottomTableView.delegate = self
        self.bottomTableView.dataSource = self

        linkActions()
        
        let colors = Colors()
        topView.backgroundColor = UIColor.clear
        let backgroundLayer = colors.gl
        backgroundLayer?.frame = self.view.frame
        topView.layer.insertSublayer(backgroundLayer!, at: 0)
        
        let editButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.edit, target: self, action: #selector(ContactDetailViewController.editAction))
        navigationItem.rightBarButtonItem = editButton
        navigationController?.navigationBar.tintColor = UIColor(red: 80.0 / 255.0, green: 227.0 / 255.0, blue: 194.0 / 255.0, alpha: 1)
        
        super.viewDidLoad()
        
        
        // Do any additional setup after loading the view, typically from a nib.
        configureView()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        configureView()
        bottomTableView.reloadData()
        super.viewDidAppear(animated)
    }
    
//    override func viewDidLayoutSubviews() {
//        super.viewDidLayoutSubviews()
//        topView.frame = topView.bounds
//    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

class Colors {
    var gl:CAGradientLayer!
    
    init() {
        let colorTop = UIColor(red: 255.0 / 255.0, green: 255.0 / 255.0, blue: 255.0 / 255.0, alpha: 1.0).cgColor
        let colorBottom = UIColor(red: 80.0 / 255.0, green: 227.0 / 255.0, blue: 194.0 / 255.0, alpha: 0.28).cgColor
        
        self.gl = CAGradientLayer()
        self.gl.colors = [colorTop, colorBottom]
        self.gl.opacity = 0.5
        self.gl.locations = [0.0, 1.0]
    }
    
}

