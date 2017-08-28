//
//  RootWireframe.swift
//  SampleContacts
//
//  Created by Julian Pratama on 2017-08-28.
//  Copyright © 2017 Julian. All rights reserved.
//

import Foundation
import UIKit

class RootWireframe : NSObject {
    func present(rootViewController: UIViewController, in window: UIWindow)
    {
        window.rootViewController = rootViewController
    }
}
