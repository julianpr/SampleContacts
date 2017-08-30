//
//  ContactDetailWireframe.swift
//  SampleContacts
//
//  Created by Julian Pratama on 2017-08-28.
//  Copyright © 2017 Julian. All rights reserved.
//

import Foundation
import UIKit

class ContactDetailWireframe: ContactDetailWireframeProtocol
{
    var rootWireframe: RootWireframe?
    private var navigationController: UINavigationController?

    
    static func presentContactDetailInterface(in navigationController: UINavigationController, contact: Contact)
    {
        present(from: navigationController, contact: contact)
    }
    
    private static func present(from viewController: UIViewController, contact: Contact)
    {
        // Generating module components
        let view = Utility.viewControllerByIdentifier("ContactDetailViewController") as! ContactDetailViewController
        let presenter: ContactDetailPresenterProtocol & ContactDetailInteractorOutputProtocol = ContactDetailPresenter()
        let interactor: ContactDetailInteractorInputProtocol = ContactDetailInteractor()
        let wireframe = ContactDetailWireframe()
        let vc = viewController as? UINavigationController
        
        // Connecting
        view.presenter = presenter
        view.detailItem = contact
        presenter.view = view
        presenter.wireframe = wireframe
        presenter.interactor = interactor
        interactor.presenter = presenter
        wireframe.navigationController = vc
        
        // Navigation
        vc!.pushViewController(view, animated: true)
    }
    
    func presentEditDetailInterface(navigationController: UINavigationController, contact: Contact)
    {
        EditDetailWireframe.presentEditDetailInterface(in: navigationController, contact: contact)

    }
    
    func contactDetailViewControllerFromStoryboard() -> ContactDetailViewController
    {
        let viewController = Utility.viewControllerByIdentifier("ContactDetailViewController")
        return viewController as! ContactDetailViewController
    }
    
    
    
}
