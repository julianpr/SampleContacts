//
//  HomeWireframe.swift
//  SampleContacts
//
//  Created by Julian Pratama on 2017-08-28.
//  Copyright © 2017 Julian. All rights reserved.
//

import Foundation
import UIKit
import AERecord

class HomeWireframe: HomeWireframeProtocol
{
    var rootWireframe: RootWireframe?
    weak fileprivate var window: UIWindow?
    private var navigationController: UINavigationController?


    func presentHomeInterface(in window: UIWindow)
    {
        let viewController = homeViewControllerFromStoryboard()
        let presenter: HomePresenterProtocol & HomeInteractorOutputProtocol = HomePresenter()
        let interactor: HomeInteractorInputProtocol = HomeInteractor()
        
        // Connecting
        viewController.presenter = presenter
        presenter.view = viewController
        presenter.wireframe = self
        presenter.interactor = interactor
        interactor.presenter = presenter
        self.window = window
        
        let navigationController = UINavigationController(rootViewController: viewController)
        window.rootViewController = navigationController
        
        //Navigating
        rootWireframe?.present(rootViewController: navigationController, in: window)
        
    }
    
    func presentEditDetailInterface(navigationController: UINavigationController, addFlag: Bool)
    {
        EditDetailWireframe.presentEditDetailInterface(in: navigationController, addFlag: true)
        
    }
    
    func presentContactDetailInterface(navigationController: UINavigationController, contact: Contact)
    {
        ContactDetailWireframe.presentContactDetailInterface(in: navigationController, contact: contact)

    }
    
    fileprivate func homeViewControllerFromStoryboard() -> HomeViewController
    {
        let viewController = Utility.viewControllerByIdentifier("HomeViewController")
        return viewController as! HomeViewController
    }
    
    

}
