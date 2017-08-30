//
//  EditDetailProtocol.swift
//  SampleContacts
//
//  Created by Julian Pratama on 2017-08-29.
//  Copyright © 2017 Julian. All rights reserved.
//


import Foundation
import UIKit

protocol EditDetailProtocol: class
{
    var presenter: EditDetailPresenterProtocol? { get set }
    func display(errorMessage: String)
    func display(message:String)
    
}

protocol EditDetailPresenterProtocol: class
{
    weak var view: EditDetailProtocol? { get set }
    var wireframe: EditDetailWireframeProtocol? { get set }
    var interactor: EditDetailInteractorInputProtocol? { get set }
    
    func updateContact(contact: Contact, add: Bool)
    
}

protocol EditDetailInteractorInputProtocol: class
{
    var presenter: EditDetailInteractorOutputProtocol? { get set }
    
    func updateContact(contact: Contact, add: Bool)
    
}

protocol EditDetailInteractorOutputProtocol: class
{
    func display(errorMessage: String)
    func display(message:String)
}

protocol EditDetailWireframeProtocol: class
{
    static func presentEditDetailInterface(in navigationController:UINavigationController, contact: Contact)
    static func presentEditDetailInterface(in navigationController:UINavigationController, addFlag: Bool)

}
