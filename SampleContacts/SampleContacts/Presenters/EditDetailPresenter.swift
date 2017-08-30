//
//  EditDetailPresenter.swift
//  SampleContacts
//
//  Created by Julian Pratama on 2017-08-29.
//  Copyright © 2017 Julian. All rights reserved.
//

import Foundation
class EditDetailPresenter: EditDetailPresenterProtocol, EditDetailInteractorOutputProtocol
{
    var interactor: EditDetailInteractorInputProtocol?
    weak var view: EditDetailProtocol?
    var wireframe: EditDetailWireframeProtocol?
    
    func updateContact(contact: Contact, add: Bool)
    {
        interactor?.updateContact(contact: contact, add: add)
    }
    
    func display(errorMessage: String)
    {
        view?.display(errorMessage: errorMessage)
    }
    func display(message:String)
    {
        view?.display(message: message)
    }
}
