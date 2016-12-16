//
//  Person.swift
//  RetrieveContacts
//
//  Created by John N Blanchard on 11/29/16.
//  Copyright © 2016 John N Blanchard. All rights reserved.
//

import UIKit

class Person: NSObject {

    var firstName: String = ""
    var lastName: String = ""
    var name: String  = ""
    var email: String = ""
    var phone: String = ""
    var organization: String = ""
    var facebook: String = ""

    init(first: String, last: String, emailAddress: String, postalAddress: String, phoneNumber: String, organizationName: String, facebookName: String) {
        firstName = first
        lastName = last
        name = first + " " + last
        email = emailAddress
        phone = phoneNumber
        organization = organizationName
        facebook = facebookName
    }
}
