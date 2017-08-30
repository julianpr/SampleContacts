//
//  HomeProtocol.swift
//  SampleContacts
//
//  Created by Julian Pratama on 2017-08-25.
//  Copyright © 2017 Julian. All rights reserved.
//

import Foundation
import UIKit
import AERecord

protocol HomeProtocol: class
{
    var presenter: HomePresenterProtocol? { get set }
    
    func display(errorMessage: String)
    func endRefreshing()
}

protocol HomePresenterProtocol: class
{
    weak var view: HomeProtocol? { get set }
    var wireframe: HomeWireframeProtocol? { get set }
    var interactor: HomeInteractorInputProtocol? { get set }
    
    func updateView()
    func openDetails(navigationController: UINavigationController,contact: Contact)
    func addAction(navigationController: UINavigationController, addFlag: Bool)

}

protocol HomeInteractorInputProtocol: class
{
    var presenter: HomeInteractorOutputProtocol? { get set }    
    func saveContacts(jsonArray: [[String:Any]])
    func populateContacts()
    func getContacts()

}

protocol HomeInteractorOutputProtocol: class
{
    func display(errorMessage: String)
}

protocol HomeWireframeProtocol: class
{
    func presentHomeInterface(in window: UIWindow)
    func presentContactDetailInterface(navigationController: UINavigationController,contact: Contact)
    func presentEditDetailInterface(navigationController: UINavigationController, addFlag: Bool)

}
