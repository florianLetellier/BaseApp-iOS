//
//  SessionManagerTests.swift
//  BaseAppV2
//
//  Created by Emanuel  Guerrero on 3/17/17.
//  Copyright © 2017 SilverLogic. All rights reserved.
//

import XCTest
import CoreData
@testable import BaseAppV2

final class SessionManagerTests: BaseAppV2Tests {
    
    // MARK: - Private Instance Attributes
    fileprivate var sharedManager: SessionManager!
}


// MARK: - Setup & Tear Down
extension SessionManagerTests {
    override func setUp() {
        super.setUp()
        sharedManager = SessionManager.shared
    }
    
    override func tearDown() {
        super.tearDown()
        sharedManager = nil
    }
}


// MARK: - Functional Tests
extension SessionManagerTests {
    func testUpdate() {
        guard let user = NSEntityDescription.insertNewObject(forEntityName: User.entityName, into: CoreDataStack.shared.managedObjectContext) as? User else {
            XCTFail("Error Creating Test User Model!")
            return
        }
        sharedManager.currentUser = DynamicBinder(user)
        sharedManager.currentUser.value?.userId = 210
        let updateInfo = UpdateInfo(referralCodeOfReferrer: nil, avatarBaseString: nil, firstName: "Bob", lastName: "Saget")
        let updateUserExpectation = expectation(description: "Test Updating User")
        sharedManager.update(updateInfo, success: {
            XCTAssertEqual(self.sharedManager.currentUser.value?.firstName, "Bob", "Updating User Failed!")
            XCTAssertEqual(self.sharedManager.currentUser.value?.lastName, "Saget", "Updating User Failed!")
            updateUserExpectation.fulfill()
        }) { (error: BaseError) in
            XCTFail("Error Updating User!")
            updateUserExpectation.fulfill()
        }
        waitForExpectations(timeout: 10, handler: nil)
    }
}
