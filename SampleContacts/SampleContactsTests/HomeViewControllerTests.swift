//
//  HomeViewControllerTests.swift
//  SampleContacts
//
//  Created by Julian Pratama on 2017-08-30.
//  Copyright © 2017 Julian. All rights reserved.
//

import Foundation
import XCTest
import UIKit

@testable import SampleContacts

class HomeViewControllerTests: XCTestCase
{
    var systemUnderTest: HomeViewController!

    
    override func setUp() {
        super.setUp()
        
        let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        
        systemUnderTest = storyboard.instantiateViewController(withIdentifier: "HomeViewController") as! HomeViewController
        
        _ = systemUnderTest.view
    }
    
    func testSUT_TableViewIsNotNilAfterViewDidLoad() {
        
        XCTAssertNotNil(systemUnderTest.tableView)
    }
    
    func testSUT_ShouldSetTableViewDataSource() {
        
        XCTAssertNotNil(systemUnderTest.tableView.dataSource)
    }
    
    func testSUT_ShouldSetTableViewDelegate() {
        
        XCTAssertNotNil(systemUnderTest.tableView.dataSource)
    }
    
    func testSUT_ConformsToTableViewDataSourceProtocol() {
        
        
        
        XCTAssert(systemUnderTest.conforms(to: UITableViewDataSource.self))
        
        
        XCTAssert(systemUnderTest.responds(to: #selector(systemUnderTest.tableView(_:numberOfRowsInSection:))))
        
        XCTAssert(systemUnderTest.responds(to: #selector(systemUnderTest.tableView(_:cellForRowAt:))))
    }
    
    func testSUT_TableViewUsesCustomCell_SearchItemTableViewCell() {
        
        let firstCell = systemUnderTest.tableView.cellForRow(at: IndexPath(row: 0, section: 0 ))
        
        XCTAssert(firstCell is HomeCell) //whatever the name of your UITableViewCell subclass
    }
    
    func testSUT_ConformsToTableViewDelegateProtocol() {
        
        XCTAssert(systemUnderTest.conforms(to: UITableViewDelegate.self))
        
        XCTAssert(systemUnderTest.responds(to: #selector(systemUnderTest.tableView(_:didSelectRowAt:))))
    }
}
