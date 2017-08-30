//
//  HomePresenter.swift
//  SampleContacts
//
//  Created by Julian Pratama on 2017-08-25.
//  Copyright © 2017 Julian. All rights reserved.
//

import Foundation
import UIKit

class HomePresenter:HomePresenterProtocol, HomeInteractorOutputProtocol {
    var interactor: HomeInteractorInputProtocol?
    weak var view: HomeProtocol?
    var wireframe: HomeWireframeProtocol?

    func addAction(navigationController: UINavigationController, addFlag: Bool) {
        wireframe?.presentEditDetailInterface(navigationController: navigationController, addFlag: true)
    }
    
    
    func updateView()
    {
        interactor?.populateContacts()
    }
    
   
    func display(errorMessage: String) {
        view?.endRefreshing()
        view?.display(errorMessage: errorMessage)
        
    }
    
    func openDetails(navigationController: UINavigationController,contact: Contact)
    {
        wireframe?.presentContactDetailInterface(navigationController: navigationController, contact: contact)
    }

   
    
    
    
    
}
