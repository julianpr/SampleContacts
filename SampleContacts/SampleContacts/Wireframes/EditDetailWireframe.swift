//
//  EditDetailWireframe.swift
//  SampleContacts
//
//  Created by Julian Pratama on 2017-08-29.
//  Copyright © 2017 Julian. All rights reserved.
//

import Foundation
import UIKit

class EditDetailWireframe: EditDetailWireframeProtocol
{
    var rootWireframe: RootWireframe?
    private var navigationController: UINavigationController?
    
    
    static func presentEditDetailInterface(in navigationController: UINavigationController, contact: Contact)
    {
        present(from: navigationController, contact: contact)
    }
    
    static func presentEditDetailInterface(in navigationController: UINavigationController, addFlag: Bool)
    {
        present(from: navigationController, addFlag: addFlag)
    }
    
    private static func present(from viewController: UIViewController, addFlag: Bool)
    {
        // Generating module components
        let view = Utility.viewControllerByIdentifier("EditDetailViewController") as! EditDetailViewController
        let presenter: EditDetailPresenterProtocol & EditDetailInteractorOutputProtocol = EditDetailPresenter()
        let interactor: EditDetailInteractorInputProtocol = EditDetailInteractor()
        let wireframe = EditDetailWireframe()
        let vc = viewController as? UINavigationController
        
        // Connecting
        view.presenter = presenter
        view.addFlag = addFlag
        presenter.view = view
        presenter.wireframe = wireframe
        presenter.interactor = interactor
        interactor.presenter = presenter
        wireframe.navigationController = vc
        
        // Navigation
        
        vc!.pushViewController(view, animated: true)
    }
    
    private static func present(from viewController: UIViewController, contact: Contact)
    {
        // Generating module components
        let view = Utility.viewControllerByIdentifier("EditDetailViewController") as! EditDetailViewController
        let presenter: EditDetailPresenterProtocol & EditDetailInteractorOutputProtocol = EditDetailPresenter()
        let interactor: EditDetailInteractorInputProtocol = EditDetailInteractor()
        let wireframe = EditDetailWireframe()
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
    
    func editDetailViewControllerFromStoryboard() -> EditDetailViewController
    {
        let viewController = Utility.viewControllerByIdentifier("EditDetailViewController")
        return viewController as! EditDetailViewController
    }
    
    
    
}
