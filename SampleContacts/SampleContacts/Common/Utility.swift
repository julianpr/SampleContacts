//
//  Utility.swift
//  SampleContacts
//
//  Created by Julian Pratama on 2017-08-28.
//  Copyright © 2017 Julian. All rights reserved.
//

import UIKit

class Utility {
    static func viewControllerByIdentifier(_ identifier: String) -> UIViewController {
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        let viewController = storyboard.instantiateViewController(withIdentifier: identifier)
        return viewController
    }
}
