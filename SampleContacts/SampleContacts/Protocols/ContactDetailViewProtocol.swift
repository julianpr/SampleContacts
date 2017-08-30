//
//  ContactDetailViewProtocol.swift
//  SampleContacts
//
//  Created by Julian Pratama on 2017-08-25.
//  Copyright © 2017 Julian. All rights reserved.
//

import Foundation
import UIKit

protocol ContactDetailProtocol: class
{
    var presenter: ContactDetailPresenterProtocol? { get set }
    func reloadData(contact:Contact)
    func display(errorMessage:String)
    func display(message:String)
    
}

protocol ContactDetailPresenterProtocol: class
{
    weak var view: ContactDetailProtocol? { get set }
    var wireframe: ContactDetailWireframeProtocol? { get set }
    var interactor: ContactDetailInteractorInputProtocol? { get set }
    
    func loadContactData(id:Int32)
    func updateContact(id: Int32)
    func editAction(navigationController: UINavigationController!, contact: Contact)

    
}

protocol ContactDetailInteractorInputProtocol: class
{
    var presenter: ContactDetailInteractorOutputProtocol? { get set }
    
    func loadContactData(id:Int32)
    func updateContact(id: Int32)

    
}

protocol ContactDetailInteractorOutputProtocol: class
{
    func display(errorMessage: String)
    func reloadData(contact:Contact)
    func display(message:String)
}

protocol ContactDetailWireframeProtocol: class
{
    static func presentContactDetailInterface(in navigationController:UINavigationController, contact: Contact)
    func presentEditDetailInterface(navigationController: UINavigationController, contact: Contact)
}
