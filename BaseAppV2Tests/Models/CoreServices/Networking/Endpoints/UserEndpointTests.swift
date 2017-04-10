//
//  UserEndpointTests.swift
//  BaseAppV2
//
//  Created by Emanuel  Guerrero on 3/30/17.
//  Copyright © 2017 SilverLogic. All rights reserved.
//

import XCTest
import Alamofire
@testable import BaseAppV2

final class UserEndpointTests: BaseAppV2Tests {
    
    // MARK: - Functional Tests
    func testUserEndpoint() {
        let userEndpoint = UserEndpoint.user(userId: 1)
        XCTAssertNotNil(userEndpoint, "Value Should Not Be Nil!")
        XCTAssertEqual(userEndpoint.endpointInfo.path, "users/1", "Path Not Correct!")
        XCTAssertEqual(userEndpoint.endpointInfo.requestMethod, .get, "Request Method Not Correct!")
        XCTAssertNil(userEndpoint.endpointInfo.parameters, "Value Should Be Nil!")
        XCTAssertTrue(userEndpoint.endpointInfo.parameterEncoding is URLEncoding, "Encoding Not Correct!")
        XCTAssertFalse(userEndpoint.endpointInfo.requiresAuthorization, "Value Should Be False!")
    }
    
    func testUsersEndpoint() {
        let usersEndpoint = UserEndpoint.users(pagination: nil)
        XCTAssertNotNil(usersEndpoint, "Value Should Not Be Nil!")
        XCTAssertEqual(usersEndpoint.endpointInfo.path, "users", "Path Not Correct!")
        XCTAssertEqual(usersEndpoint.endpointInfo.requestMethod, .get, "Request Method Not Correct!")
        XCTAssertNil(usersEndpoint.endpointInfo.parameters, "Value Should Be Nil!")
        XCTAssertTrue(usersEndpoint.endpointInfo.parameterEncoding is URLEncoding, "Encoding Not Correct!")
        XCTAssertFalse(usersEndpoint.endpointInfo.requiresAuthorization, "Value Should Be False!")
    }
}
