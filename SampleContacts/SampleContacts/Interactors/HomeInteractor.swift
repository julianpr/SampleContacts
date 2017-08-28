//
//  HomeInteractor.swift
//  SampleContacts
//
//  Created by Julian Pratama on 2017-08-25.
//  Copyright © 2017 Julian. All rights reserved.
//

import Foundation
import Networking
import AERecord


class HomeInteractor:HomeInteractorInputProtocol {
    
    weak var presenter: HomeInteractorOutputProtocol?
    private var contacts = [Contact]()
    
    func populateContacts() {
        let networking = Networking(baseURL: "http://gojek-contacts-app.herokuapp.com/contacts")
        networking.get(".json") { result in
            switch result {
            case .success(let response):
                if let json = response.json as JSON?,
                let jsonArray = json.array as [[String:Any]]?
                {
                    self.saveContacts(jsonArray: jsonArray)
                    self.presenter?.populatingContacts(contacts: self.contacts)
                }
                
                
                
            case .failure(let response):
                print(response)
//                self.presenter?.display(errorMessage: "Failed to get contacts. Please check your connection.")
            }
        }
    }
    
    func getContacts()
    {
        if let getContacts = Contact.all() as [Contact]?
        {
            contacts = getContacts
            self.presenter?.populatingContacts(contacts: contacts)
        }
    }
    
    func saveContacts(jsonArray: [[String:Any]])
    {
        var result = [Contact]()
        
        for element in jsonArray
        {
            if let id = element["id"] as? Int32,
            let firstName = element["first_name"] as? String,
            let lastName = element["last_name"] as? String,
            let profilePic = element["profile_pic"] as? String,
            let favorite = element["favorite"] as? Bool
            {
                
                //find or create
                if let newContact = Contact.firstOrCreate(with: "id", value: id) as Contact?
                {
                    newContact.firstName = firstName.trimmingCharacters(in: .whitespacesAndNewlines).capitalized
                    newContact.lastName = lastName.trimmingCharacters(in: .whitespacesAndNewlines).capitalized
                    newContact.profilePic = profilePic
                    newContact.favorite = favorite
                    
                    result.append(newContact)
                }
                else
                {
                    print("error in saving contacts")
                }
                
            }
        }
        contacts = result
        AERecord.saveAndWait()
    }
    
    
}
