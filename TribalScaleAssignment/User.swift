//
//  User.swift
//  TribalScaleAssignment
//
//  Created by Simon Tsai on 6/2/17.
//  Copyright © 2017 Simon Tsai. All rights reserved.
//

import Foundation

struct User {
  
  let firstName: String
  
  let lastName: String
  
  let address: Address
  
  let cellPhoneNumber: String
  
  let email: String
  
  let birthday: Date?
  
  let thumbnailLink: String
  
  let largePictureLink: String
  
  var fullName: String {
    
    let capitalizedFirstName = firstName.capitalized.trimmingCharacters(in: .whitespacesAndNewlines)
    
    let capitalizedLastName = lastName.capitalized.trimmingCharacters(in: .whitespacesAndNewlines)
    
    return "\(capitalizedFirstName) \(capitalizedLastName)"
    
  }
  
  init(userPayload: [String: Any]) {
    
    let locationPayload = userPayload["location"] as! [String: Any]
    
    let street = locationPayload["street"] as! String
    
    let city = locationPayload["city"] as! String
    
    let state = locationPayload["state"] as! String
    
    let zipCode = locationPayload["postcode"]
    
    let zipCodeString: String
    
    if let zipCodeAsString = zipCode as? String {
      
      zipCodeString = zipCodeAsString
      
    } else if let zipCodeAsNumber = zipCode as? NSNumber {
      
      zipCodeString = zipCodeAsNumber.stringValue
      
    } else {
      
      zipCodeString = ""
      
    }
    
    let address = Address(street: street, city: city, state: state, zipCode: zipCodeString)
    
    let namePayload = userPayload["name"] as! [String: String]
    
    let picturePayload = userPayload["picture"] as! [String: String]
    
    let dobString = userPayload["dob"] as! String
    
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
    dateFormatter.timeZone = TimeZone(identifier: "UTC")
    
    let birthday = dateFormatter.date(from: dobString)
    
    self.init(
      firstName: namePayload["first"]!,
      lastName: namePayload["last"]!,
      address: address,
      cellPhoneNumber: userPayload["cell"] as! String,
      email: userPayload["email"] as! String,
      birthday: birthday,
      thumbnailLink: picturePayload["thumbnail"]!,
      largePictureLink: picturePayload["large"]!
    )
    
  }
  
  init(
    firstName: String = "",
    lastName: String = "",
    address: Address = Address(),
    cellPhoneNumber: String = "",
    email: String = "",
    birthday: Date? = nil,
    thumbnailLink: String = "",
    largePictureLink: String = "") {
    
    self.firstName = firstName
    
    self.lastName = lastName
    
    self.address = address
    
    self.cellPhoneNumber = cellPhoneNumber
    
    self.email = email
    
    self.birthday = birthday
    
    self.thumbnailLink = thumbnailLink
    
    self.largePictureLink = largePictureLink
    
  }
  
}

extension User: Equatable {
  
  static func ==(lhs: User, rhs: User) -> Bool {
    
    return lhs.firstName == rhs.firstName &&
      lhs.lastName == rhs.lastName &&
      lhs.address == rhs.address &&
      lhs.cellPhoneNumber == rhs.cellPhoneNumber &&
      lhs.email == rhs.email &&
      lhs.birthday == rhs.birthday &&
      lhs.thumbnailLink == rhs.thumbnailLink &&
      lhs.largePictureLink == rhs.largePictureLink
    
  }
  
}
