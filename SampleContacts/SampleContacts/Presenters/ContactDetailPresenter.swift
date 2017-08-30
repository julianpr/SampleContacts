//
//  ContactDetailPresenter.swift
//  SampleContacts
//
//  Created by Julian Pratama on 2017-08-28.
//  Copyright © 2017 Julian. All rights reserved.
//

import Foundation
import UIKit

class ContactDetailPresenter:ContactDetailPresenterProtocol, ContactDetailInteractorOutputProtocol {
    
    var interactor: ContactDetailInteractorInputProtocol?
    weak var view: ContactDetailProtocol?
    var wireframe: ContactDetailWireframeProtocol?
    
    
    func editAction(navigationController: UINavigationController!, contact: Contact) {
        wireframe?.presentEditDetailInterface(navigationController: navigationController, contact: contact)
    }
    
    func display(errorMessage: String) {
        view?.display(errorMessage: errorMessage)
    }
    
    func display(message:String)
    {
        view?.display(message: message)
    }
    func updateContact(id: Int32)
    {
        interactor?.updateContact(id: id)
    }
    
    
    func loadContactData(id:Int32)
    {
        interactor?.loadContactData(id: id)
    }
    
    func reloadData(contact:Contact) {
        view?.reloadData(contact:contact)
    }
}
