//
//  HomeWireframe.swift
//  SampleContacts
//
//  Created by Julian Pratama on 2017-08-28.
//  Copyright © 2017 Julian. All rights reserved.
//

import Foundation
import UIKit

class HomeWireframe: HomeWireframeProtocol
{
    var rootWireframe: RootWireframe?
    weak fileprivate var window: UIWindow?

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
        
        //Navigating
        rootWireframe?.present(rootViewController: viewController, in: window)
        
    }
    
    fileprivate func homeViewControllerFromStoryboard() -> HomeViewController
    {
        let viewController = Utility.viewControllerByIdentifier("HomeViewController")
        return viewController as! HomeViewController
    }

}
