//
//  ContactDetailInteractor.swift
//  SampleContacts
//
//  Created by Julian Pratama on 2017-08-28.
//  Copyright © 2017 Julian. All rights reserved.
//

import Foundation
import Networking
import AERecord

class ContactDetailInteractor:ContactDetailInteractorInputProtocol {
    var presenter: ContactDetailInteractorOutputProtocol?
    
    func loadContactData(id:Int32)
    {
        let networking = Networking(baseURL: "http://gojek-contacts-app.herokuapp.com/contacts/\(id)")
        networking.get(".json") { result in
            switch result {
            case .success(let response):
                if let json = response.json as JSON?,
                let jsonDict = json.dictionary as [String:Any]?
                {
                    if let contact = self.saveContactInfo(jsonDict: jsonDict)
                    {
                        self.presenter?.reloadData(contact: contact)
                    }
                    else
                    {
                        print("can't find contact in coredata")
                    }
                }
                
                
                
            case .failure(let response):
                print(response)
                //                self.presenter?.display(errorMessage: "Failed to get contacts. Please check your connection.")
            }
        }
    }
    
    func updateContact(id: Int32) {
        let networking = Networking(baseURL: "http://gojek-contacts-app.herokuapp.com/contacts/\(id)")
        if let contact = Contact.first(with: "id", value: id) as Contact?
        {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
            let dateString = dateFormatter.string(from: Date())
            
            let params =
                        ["first_name": contact.firstName ?? "",
                          "last_name": contact.lastName ?? "",
                          "email": contact.email ?? "",
                          "phone_number": contact.phone ?? "",
                          "profile_pic": contact.profilePic ?? "/images/missing.png",
                          "favorite": contact.favorite,
                          "updated_at": dateString] as [String : Any]
            
            
            networking.put(".json", parameters: params, completion: { result in
                switch result {
                case .success:
                    self.presenter?.display(message: "Success updating contact details")
                case .failure(let response):
                    
                    self.presenter?.display(errorMessage: "Error updating contact details. \(response.error.description)")
                    
                }
            })
        }
    
    }
    
    func saveContactInfo(jsonDict: [String:Any]?) -> Contact?
    {
        if  let jsonD = jsonDict,
            let contactId = jsonD["id"] as? Int32,
            let findContact = Contact.first(with: "id", value: contactId) as Contact?
        {
            if let email = jsonD["email"] as? String
            {
                if email.trimmingCharacters(in: .whitespacesAndNewlines) != ""
                {
                    findContact.email = email.trimmingCharacters(in: .whitespacesAndNewlines)
                }
            }
            
            if let phone = jsonD["phone_number"] as? String
            {
                if phone.trimmingCharacters(in: .whitespacesAndNewlines) != ""
                {
                    findContact.phone = phone.trimmingCharacters(in: .whitespacesAndNewlines)
                }

            }
            AERecord.save()
            return findContact
        }
        
        return nil
    }

}
