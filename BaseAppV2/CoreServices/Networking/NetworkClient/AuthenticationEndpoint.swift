//
//  AuthenticationEndpoint.swift
//  BaseAppV2
//
//  Created by Emanuel  Guerrero on 3/8/17.
//  Copyright © 2017 SilverLogic. All rights reserved.
//

import Foundation
import Alamofire
import AlamofireCoreData

/**
    An enum that conforms to `BaseEndpoint`. It defines
    endpoints that would be used for authentication.
*/
enum AuthenticationEndpoint: BaseEndpoint {
    case login(email: String, password: String)
    case signUp(signUpInfo: SignUpInfo)
    case update(updateInfo: UpdateInfo, userId: Int)
    case currentUser
    case oauth2(oauth2Info: OAuth2Info)
    
    var endpointInfo: BaseEndpointInfo {
        let path: String
        let requestMethod: Alamofire.HTTPMethod
        let parameters: Alamofire.Parameters?
        let parameterEncoding: Alamofire.ParameterEncoding?
        let requiresAuthorization: Bool
        switch self {
        case let .login(email, password):
            path = "login"
            requestMethod = .post
            parameters = ["email": email, "password": password]
            parameterEncoding = JSONEncoding()
            requiresAuthorization = false
            break
        case let .signUp(signUpInfo):
            path = "register"
            requestMethod = .post
            parameters = signUpInfo.parameters
            parameterEncoding = JSONEncoding()
            requiresAuthorization = false
            break
        case let .update(updateInfo, userId):
            path = "users/\(userId)"
            requestMethod = .patch
            parameters = updateInfo.parameters
            parameterEncoding = JSONEncoding()
            requiresAuthorization = true
            break
        case .currentUser:
            path = "users/me"
            requestMethod = .get
            parameters = nil
            parameterEncoding = nil
            requiresAuthorization = true
            break
        case let .oauth2(oauth2Info):
            path = "social-auth"
            requestMethod = .post
            parameters = oauth2Info.parameters
            parameterEncoding = JSONEncoding()
            requiresAuthorization = false
            break
        }
        return BaseEndpointInfo(path: path, requestMethod: requestMethod, parameters: parameters, parameterEncoding: parameterEncoding, requiresAuthorization: requiresAuthorization)
    }
}


/**
    A struct encapsulating what information is needed
    when registering a user.
*/
struct SignUpInfo {
    
    // MARK: - Public Instance Attributes
    let email: String
    let password: String
    let referralCodeOfReferrer: String?
    
    
    // MARK: - Getters & Setters
    var parameters: Alamofire.Parameters {
        var params: Parameters = [
            "email": email,
            "password": password
        ]
        if let referralCode = referralCodeOfReferrer {
            params["referral_code"] = referralCode
        }
        return params
    }
    
    
    // MARK: - Initializers
    
    /**
        Initializes an instance of `SignUpInfo`.
     
        - Parameters:
            - email: A `String` representing the email of the user.
            - password: A `String` representing the password that the
                        user would enter when logging in.
            - referralCodeOfReferrer: A `String` representing the referral
                                      code of another user that referred the
                                      current user to the application. `nil` can
                                      be passed if referral code isn't being used.
    */
    init(email: String, password: String, referralCodeOfReferrer: String?) {
        self.email = email
        self.password = password
        self.referralCodeOfReferrer = referralCodeOfReferrer
    }
}


/**
    A struct encapsulating what information is needed
    when updating a user.
*/
struct UpdateInfo {
    
    // MARK: - Public Instance Attributes
    let referralCodeOfReferrer: String?
    let avatarBaseString: String?
    let firstName: String
    let lastName: String
    
    
    // MARK: - Getters & Setters
    var parameters: Alamofire.Parameters {
        var params: Parameters = [
            "first_name": firstName,
            "last_name": lastName
        ]
        if let baseString = avatarBaseString {
            params["avatar"] = baseString
        }
        if let referralCode = referralCodeOfReferrer {
            params["referral_code"] = referralCode
        }
        return params
    }
    
    
    // MARK: - Initializers
    
    /**
        Initializes an instance of `UpdateInfo`.
     
        - Parameters:
            - referralCodeOfReferrer: A `String` representing the referral
                                      code of another user that referred the
                                      current user to the application. This is
                                      used when the user signs up through social
                                      authentication. In regular email signup, `nil`
                                      would be passed.
            - avatarBaseString: A `String` representing the base sixty four representation
                                of an image. `nil` can be passed if no imaged was selected
                                or changed.
            - firstName: A `String` representing the first name of the user.
            - lastName: A `String` representing the last name of the user.
    */
    init(referralCodeOfReferrer: String?, avatarBaseString: String?, firstName: String, lastName: String) {
        self.referralCodeOfReferrer = referralCodeOfReferrer
        self.avatarBaseString = avatarBaseString
        self.firstName = firstName
        self.lastName = lastName
    }
}

/**
    A struct encapsulating what information is needed
    when doing OAuth2 Authentication.
*/
struct OAuth2Info {
    
    // MARK: - Public Instance Methods
    let provider: String
    let oauthCode: String
    let redirectUri: String
    let email: String?
    let referralCodeOfReferrer: String?
    
    
    // MARK: - Getters & Setters
    var parameters: Alamofire.Parameters {
        var params: Parameters = [
            "provider": provider,
            "code": oauthCode,
            "redirect_uri": redirectUri
        ]
        if let userEmail = email {
            params["email"] = userEmail
        }
        if let referralCode = referralCodeOfReferrer {
            params["referral_code"] = referralCode
        }
        return params
    }
    
    
    // MARK: - Initializers
    
    /**
        Initializes an instance of `OAuth2Info`.
     
        - Parameters:
            - provider: An `OAuth2Provider` representing the type of
                        OAuth provider used.
            - oauthCode: A `String` representing the OAuth authorization
                         code that is received from an OAuth2 provider.
            - redirectUri: A `String` representing the redirect used
                           for the provider.
            - email: A `String` representing the email of the user used
                     for logining in to the provider. This value would be 
                     filled if an error occured due to an email not being 
                     used for login. `nil` can be passed as a parameter.
            - referralCodeOfReferrer: A `String` representing the referral code of
                                      another user that the referred the current user
                                      to the application. In some situations, if the
                                      referral code can't be supplied due to the
                                      `oauthCode` expiring, the `UpdateInfo` can be used
                                      to pass the referral code. This only avaliable for
                                      twenty four hours after the user logged in. `nil`
                                      can be passed as a parameter.
    */
    init(provider: OAuth2Provider, oauthCode: String, redirectUri: String, email: String?, referralCodeOfReferrer: String?) {
        self.provider = provider.rawValue
        self.oauthCode = oauthCode
        self.redirectUri = redirectUri
        self.email = email
        self.referralCodeOfReferrer = referralCodeOfReferrer
    }
}


/**
    A struct representing the object sent back
    from the API when logging in a user
*/
struct LoginResponse: Wrapper {
    
    // MARK: - Public Instance Attributes
    var token: String!
    
    
    // MARK: - Initializers
    
    /**
        Initializes an instance of `LoginResponse`. This
        is used to conform to the protocol `Wrapper`.
    */
    init() {}
    
    
    // MARK: - Wrapper
    mutating func map(_ map: Map) {
        token <- map["token"]
    }
}


/**
    A struct representing the object sent back
    from the API when logging in a user using OAuth.
*/
struct OAuthResponse: Wrapper {
    
    // MARK: - Public Instance Attributes
    var token: String!
    var isNewUser: Bool!
    
    
    // MARK: - Initializers
    
    /**
        Initializes an instance of `OAuthResponse`. This
        is used to conform to the protocol `Wrapper`.
    */
    init() {}
    
    
    // MARK: - Wrapper
    mutating func map(_ map: Map) {
        token <- map["token"]
        isNewUser <- map["is_new"]
    }
}


/**
    An enum that specifies the
    type of OAuth provider.
*/
enum OAuth2Provider: String {
    case facebook = "facebook"
    case linkedIn = "linkedin-oauth2"
}
