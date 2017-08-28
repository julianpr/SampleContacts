//
//  HomeProtocol.swift
//  SampleContacts
//
//  Created by Julian Pratama on 2017-08-25.
//  Copyright © 2017 Julian. All rights reserved.
//

import Foundation
import UIKit

protocol HomeProtocol: class
{
    var presenter: HomePresenterProtocol? { get set }
    
    func display(errorMessage: String)
    func endRefreshing()
    func display(contacts: [Contact])
}

protocol HomePresenterProtocol: class
{
    weak var view: HomeProtocol? { get set }
    var wireframe: HomeWireframeProtocol? { get set }

    var interactor: HomeInteractorInputProtocol? { get set }
    func updateView()
    func display()
}

protocol HomeInteractorInputProtocol: class
{
    var presenter: HomeInteractorOutputProtocol? { get set }    
    func saveContacts(jsonArray: [[String:Any]])
    func populateContacts()
}

protocol HomeInteractorOutputProtocol: class
{
    func populatingContacts(contacts: [Contact])
    func display(errorMessage: String)
}

protocol HomeWireframeProtocol: class
{
    func presentHomeInterface(in window: UIWindow)
}
