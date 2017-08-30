//
//  HomeViewController.swift
//  SampleContacts
//
//  Created by Julian Pratama on 2017-08-23.
//  Copyright © 2017 Julian. All rights reserved.
//

import UIKit
import CoreData
import AECoreDataUI
import AERecord
import Kingfisher

class HomeViewController: CoreDataTableViewController,HomeProtocol {

    var presenter: HomePresenterProtocol?



    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        let addButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.add, target: self, action: #selector(HomeViewController.addAction))
        navigationItem.rightBarButtonItem = addButton
        navigationController?.navigationBar.tintColor = UIColor(red: 80.0 / 255.0, green: 227.0 / 255.0, blue: 194.0 / 255.0, alpha: 1)

        
        // Do any additional setup after loading the view, typically from a nib.
        presenter?.updateView()
        refreshData()

    }
    
    func addAction()
    {
        presenter?.addAction(navigationController: self.navigationController!, addFlag: true)
    }
    
    func refreshData()
    {
        let sortDescriptors = [NSSortDescriptor(key: "lastName", ascending: true)]
        let request = Contact.createFetchRequest(sortDescriptors: sortDescriptors)
        fetchedResultsController = NSFetchedResultsController(fetchRequest: request,
                                                              managedObjectContext: AERecord.Context.default,
                                                              sectionNameKeyPath: "lastNameInitial", cacheName: nil)
    }
    
    func endRefreshing() {
        self.refreshControl?.endRefreshing()
    }
    
    func display(errorMessage: String) {
        let alertController = UIAlertController(title: "Error", message: errorMessage, preferredStyle: .alert)
        let OKAction = UIAlertAction(title: "OK", style: .default) { action in  }
        alertController.addAction(OKAction)
        self.present(alertController,animated:true) 
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table View
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let frc = fetchedResultsController,
            let object = frc.object(at: indexPath) as? Contact
        {
            presenter?.openDetails(navigationController: self.navigationController!, contact: object)
        }
    }
    
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return fetchedResultsController!.sections!.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return (fetchedResultsController?.sections![section].numberOfObjects)!
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "HomeCell", for: indexPath) as? HomeCell
        if let frc = fetchedResultsController,
            let object = frc.object(at: indexPath) as? Contact
        {
            configureCell(cell!, withContact: object)
        }
        return cell!
    }

    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    
    override func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        return fetchedResultsController?.sectionIndexTitles
    }
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return fetchedResultsController?.sectionIndexTitles[section]
    }
    
    override func tableView(_ tableView: UITableView, sectionForSectionIndexTitle title: String, at index: Int) -> Int {
        return fetchedResultsController!.section(forSectionIndexTitle: title, at: index)
    }

    func configureCell(_ cell: HomeCell, withContact contact: Contact) {
        cell.firstNameLabel.text = contact.firstName ?? ""
        cell.lastNameLabel.text = contact.lastName ?? ""
        cell.favIcon.isHidden = !contact.favorite
        Utility.circleImage(image: cell.profilePic)
        
        if let url = contact.profilePic as String?
        {
            if url != "" && url != "/images/missing.png"
            {
                cell.profilePic.kf.indicatorType = .activity
                let profileURL = URL(string: url)!
                cell.profilePic.kf.setImage(with: profileURL)
            }
            else
            {
                cell.profilePic.image = #imageLiteral(resourceName: "contactPlaceholder")
            }
        }
    }

}

