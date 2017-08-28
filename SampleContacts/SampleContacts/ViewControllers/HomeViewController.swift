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

    var contactDetailViewController: ContactDetailViewController? = nil
    var managedObjectContext: NSManagedObjectContext? = nil
    var presenter: HomePresenterProtocol?
    var indexOfLetters = [String]()



    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        presenter?.updateView()
        refreshData()

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
    
    func display(contacts: [Contact]) {
        
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


    // MARK: - Segues

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetail" {
            if let indexPath = tableView.indexPathForSelectedRow {
            let object = fetchedResultsController?.object(at: indexPath)
                let controller = (segue.destination as! UINavigationController).topViewController as! ContactDetailViewController
                controller.detailItem = object as? Event
                controller.navigationItem.leftBarButtonItem = splitViewController?.displayModeButtonItem
                controller.navigationItem.leftItemsSupplementBackButton = true
            }
        }
    }

    // MARK: - Table View

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

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            
        }
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
            if url != ""
            {
                cell.profilePic.kf.indicatorType = .activity
                let profileURL = URL(string: url)!
                cell.profilePic.kf.setImage(with: profileURL)
            }
        }
    }

}

