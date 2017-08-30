//
//  EditDetailInteractor.swift
//  SampleContacts
//
//  Created by Julian Pratama on 2017-08-29.
//  Copyright © 2017 Julian. All rights reserved.
//

import Foundation
import Networking
import UIKit
import AERecord

class EditDetailInteractor: EditDetailInteractorInputProtocol
{
    var presenter: EditDetailInteractorOutputProtocol?
    
    func updateContact(contact: Contact, add: Bool)
     {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        let dateString = dateFormatter.string(from: Date())
        let networking = Networking(baseURL: "http://gojek-contacts-app.herokuapp.com/contacts")
        var params =
            ["first_name": contact.firstName ?? "",
             "last_name": contact.lastName ?? "",
             "email": contact.email ?? "",
             "phone_number": contact.phone ?? "",
             "profile_pic": contact.profilePic ?? "/images/missing.png",
             "favorite": contact.favorite,
             "updated_at": dateString] as [String : Any]

        
        if add
        {
            params["created_at"] = dateString
            networking.post(".json", parameters: params, completion: { result in
                switch result {
                case .success:
                    self.presenter?.display(message: "Success creating contact.")
                case .failure(let response):
                    self.presenter?.display(errorMessage: "Error creating contact. \(response.json.dictionary["errors"] ?? "")")
                    contact.delete()
                    AERecord.saveAndWait()
                }
            })
        }
        else
        {
            networking.put("/\(contact.id).json", parameters: params, completion: { result in
                switch result
                {
                case .success:
                    self.presenter?.display(message: "Success updating contact details.")
                case .failure(let response):
                    self.presenter?.display(errorMessage: "Error updating contact details. \(response.json.dictionary["errors"] ?? "")")
                        
                }
            })
        }

     }
}
