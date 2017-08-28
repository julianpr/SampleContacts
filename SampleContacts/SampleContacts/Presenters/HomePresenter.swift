//
//  HomePresenter.swift
//  SampleContacts
//
//  Created by Julian Pratama on 2017-08-25.
//  Copyright © 2017 Julian. All rights reserved.
//

import Foundation

class HomePresenter:HomePresenterProtocol, HomeInteractorOutputProtocol {
    var interactor: HomeInteractorInputProtocol?
    weak var view: HomeProtocol?
    private var contactsFound = [Contact]()
    var wireframe: HomeWireframeProtocol?

    
    func updateView()
    {
        interactor?.populateContacts()
    }
    
    func display()
    {
        view?.endRefreshing()
        view?.display(contacts: contactsFound)
    }
    
    func display(errorMessage: String) {
        view?.endRefreshing()
        
    }
    
    func populatingContacts(contacts: [Contact])
    {
        contactsFound = contacts
        self.display()
    }
    
    
    
    
}
