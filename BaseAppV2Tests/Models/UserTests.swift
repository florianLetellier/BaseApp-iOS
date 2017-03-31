//
//  UserTests.swift
//  BaseAppV2
//
//  Created by Emanuel  Guerrero on 3/7/17.
//  Copyright © 2017 SilverLogic. All rights reserved.
//

import XCTest
import CoreData
@testable import BaseAppV2

final class UserTests: BaseAppV2Tests {
    
    // MARK: - Functionality Tests
    func testAvatarUrl() {
        guard let user = NSEntityDescription.insertNewObject(forEntityName: User.entityName, into: CoreDataStack.shared.managedObjectContext) as? User else {
            XCTFail("Failed To Test CoreDataStack!")
            return
        }
        user.userId = 50
        let url = URL(string: "https://upload.wikimedia.org/wikipedia/commons/thumb/8/84/Apple_Computer_Logo_rainbow.svg/931px-Apple_Computer_Logo_rainbow.svg.png")!
        user.avatarUrl = url
        XCTAssertEqual(user.avatarUrl, url, "Formatting Not Correct!")
    }
    
    func testFullName() {
        guard let user = NSEntityDescription.insertNewObject(forEntityName: User.entityName, into: CoreDataStack.shared.managedObjectContext) as? User else {
            XCTFail("Failed To Test CoreDataStack!")
            return
        }
        user.userId = 52
        user.firstName = "Bob"
        user.lastName = "Saget"
        let fullName = user.fullName
        XCTAssertEqual(fullName, "Bob Saget", "Formatting Not Correct!")
        guard let user2 = NSEntityDescription.insertNewObject(forEntityName: User.entityName, into: CoreDataStack.shared.managedObjectContext) as? User else {
            XCTFail("Failed To Test CoreDataStack!")
            return
        }
        user2.userId = 53
        user2.firstName = nil
        user2.lastName = nil
        let fullName2 = user2.fullName
        XCTAssertEqual(fullName2, "Unidentified Name", "Formatting Not Correct!")
        guard let user3 = NSEntityDescription.insertNewObject(forEntityName: User.entityName, into: CoreDataStack.shared.managedObjectContext) as? User else {
            XCTFail("Failed To Test CoreDataStack!")
            return
        }
        user3.userId = 54
        user3.firstName = ""
        user3.lastName = ""
        let fullName3 = user3.fullName
        XCTAssertEqual(fullName3, "Unidentified Name", "Formatting Not Correct!")
    }
}
