//
//  ViewController.swift
//  RetrieveContacts
//
//  Created by John N Blanchard on 11/29/16.
//  Copyright © 2016 John N Blanchard. All rights reserved.
//

import UIKit
import Contacts
import Foundation
import MessageUI

class ViewController: UIViewController {

    var contacts: Array<CNContact> = []
    var people: Array<Person> = []
    var completeJSON: Array<AnyObject> = []

    @IBOutlet var sendEmail: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()

        sendEmail.isEnabled = true

        let store = CNContactStore()
        store.requestAccess(for: .contacts) { granted, error in
            guard granted else {
                DispatchQueue.main.async {
                    print(error as Any)
                }
                return
            }
            let requestContacts = CNContactFetchRequest(keysToFetch:

                [CNContactIdentifierKey as CNKeyDescriptor,
                 CNContactNonGregorianBirthdayKey as CNKeyDescriptor,
                 CNContactBirthdayKey as CNKeyDescriptor,
                 CNContactNoteKey as CNKeyDescriptor,
                 CNContactJobTitleKey as CNKeyDescriptor,
                 CNContactNicknameKey as CNKeyDescriptor,
                 CNContactMiddleNameKey as CNKeyDescriptor,
                 CNContactEmailAddressesKey as CNKeyDescriptor,
                 CNContactImageDataKey as CNKeyDescriptor,
                 CNContactSocialProfilesKey as CNKeyDescriptor,
                 CNContactGivenNameKey as CNKeyDescriptor,
                 CNContactFamilyNameKey as CNKeyDescriptor,
                 CNContactPhoneNumbersKey as CNKeyDescriptor,
                 CNContactOrganizationNameKey as CNKeyDescriptor,
                 CNContactPostalAddressesKey as CNKeyDescriptor])
            do {
                try store.enumerateContacts(with: requestContacts, usingBlock: { (contact, completed) in

                    self.contacts.append(contact)

                    let aPerson = Person(first: contact.givenName, last: contact.familyName, emailAddress: "", postalAddress: "", phoneNumber: "", organizationName: contact.organizationName, facebookName: "")

                    var phoneNumber = ""
                    if !contact.phoneNumbers.isEmpty {
                        phoneNumber = contact.phoneNumbers[0].value.value(forKey: "digits") as! String
                    }
                    aPerson.phone = phoneNumber

                    var emailAddress = ""
                    if !contact.emailAddresses.isEmpty {
                        emailAddress = contact.emailAddresses[0].value as String
                    }
                    aPerson.email = emailAddress

                    if let facebookProfile = contact.socialProfiles.first {
                        if let displayName = facebookProfile.value.value(forKey: "displayname") as? String {
                            aPerson.facebook = displayName
                        }
                    }

                    self.people.append(aPerson)
                    guard self.addPersonToJSON(personObj: self.createJSONFromPerson(aPerson: aPerson)) else {
                        return
                    }
                })
            } catch {
                print(error)
            }
        }
    }

    func createJSONFromPerson(aPerson: Person) -> [String: AnyObject] {
        return [
            "name" : aPerson.name as AnyObject,
            "phoneNumber": aPerson.phone as AnyObject,
            "emailAddress": aPerson.email as AnyObject,
            "organizationName:": aPerson.organization as AnyObject,
            "facebookUsername": aPerson.facebook as AnyObject
        ]
    }

    func addPersonToJSON(personObj: [String: AnyObject]) -> Bool {
        completeJSON.append(personObj as AnyObject)
        if completeJSON.count == contacts.count {
            sendEmail.isEnabled = true
        }
        return JSONSerialization.isValidJSONObject(completeJSON)
    }

    @IBAction func sendEmailButtonPressed(_ sender: Any) {
        let mvc = MFMailComposeViewController()
        mvc.mailComposeDelegate = self
        mvc.setToRecipients([""])
        mvc.setSubject("Crko dabogda stoko seljacka!")
        let jsonString = try! JSONSerialization.data(withJSONObject: completeJSON, options: .prettyPrinted)
        mvc.setMessageBody(jsonString.base64EncodedString(), isHTML: false)
        mvc.title = "Sranje!"
        present(mvc, animated: true, completion: nil)
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension ViewController: MFMailComposeViewControllerDelegate {
    func mailComposeController(_ controller: MFMailComposeViewController,
                               didFinishWith result: MFMailComposeResult, error: Error?) {
        dismiss(animated: true, completion: nil)
    }
}

