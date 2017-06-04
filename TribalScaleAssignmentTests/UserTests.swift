//
//  UserTests.swift
//  TribalScaleAssignment
//
//  Created by Simon Tsai on 6/2/17.
//  Copyright © 2017 Simon Tsai. All rights reserved.
//

import XCTest

@testable import TribalScaleAssignment

class UserFetchingTests: XCTestCase {
  
  func testUserFetchingShouldUseCorrectEndpoint() {
    
    let mockURLSession = MockURLSession()
    
    let userRepository = UserRepository(urlSession: mockURLSession)
    userRepository.fetch(withSuccess: nil, failure: nil)
    
    let expectedURL = URL(string: "https://randomuser.me/api/1.1/?results=100")!
    
    XCTAssertEqual(mockURLSession.lastURL, expectedURL)
    
  }
  
  func testUserFetchingShouldOnlyUseSessionOnce() {
    
    let mockURLSession = MockURLSession()
    
    let userRepository = UserRepository(urlSession: mockURLSession)
    userRepository.fetch(withSuccess: nil, failure: nil)
    
    XCTAssertEqual(mockURLSession.numberOfTimesUsed, 1)
    
  }
  
  func testUserFetchingWithOneDesiredResultShouldUseCorrectEndPoint() {
    
    let mockURLSession = MockURLSession()
    
    let userRepository = UserRepository(numberOfDesiredResults: 1, urlSession: mockURLSession)
    userRepository.fetch(withSuccess: nil, failure: nil)
    
    let expectedURL = URL(string: "https://randomuser.me/api/1.1/?results=1")!
    
    XCTAssertEqual(mockURLSession.lastURL, expectedURL)
    
  }
  
  func testUserFetchingConfiguredForOneResultShouldReturnUser() {
    
    let responsePayload = "{\"results\": [{\"name\": {\"first\": \"reis\", \"last\": \"martins\"}, \"dob\": \"1983-07-14 07:29:45\", \"location\": {\"street\": \"1861 jan pieterszoon coenstraat\", \"city\": \"maasdriel\", \"state\": \"zeeland\", \"postcode\": 69217}, \"cell\": \"(065)-247-9303\", \"email\": \"romain.hoogmoed@example.com\", \"picture\": {\"thumbnail\": \"https://randomuser.me/api/portraits/thumb/men/17.jpg\", \"large\": \"https://randomuser.me/api/portraits/men/17.jpg\"}}]}"
    
    let responseData = responsePayload.data(using: .utf8)!
    
    let mockURLSession = MockURLSession(responseData: responseData)
    
    let userRepository = UserRepository(numberOfDesiredResults: 1, urlSession: mockURLSession)
    userRepository.fetch(withSuccess: { users in
      
      var dateComponents = DateComponents()
      dateComponents.year = 1983
      dateComponents.month = 7
      dateComponents.day = 14
      dateComponents.hour = 7
      dateComponents.minute = 29
      dateComponents.second = 45
      
      var utcCalendar = Calendar(identifier: .gregorian)
      utcCalendar.timeZone = TimeZone(identifier: "UTC")!
      
      let birthday = utcCalendar.date(from: dateComponents)
      
      let expectedUsers = [
        User(
          firstName: "reis",
          lastName: "martins",
          address: Address(street: "1861 jan pieterszoon coenstraat", city: "maasdriel", state: "zeeland", zipCode: "69217"),
          cellPhoneNumber: "(065)-247-9303",
          email: "romain.hoogmoed@example.com",
          birthday: birthday,
          thumbnailLink: "https://randomuser.me/api/portraits/thumb/men/17.jpg",
          largePictureLink: "https://randomuser.me/api/portraits/men/17.jpg"
        )
      ]
      
      XCTAssertEqual(users, expectedUsers)
    
    }, failure: {
    
      XCTAssert(false, "The fetch should have succeeded because a valid response was provided")
    
    })
    
  }
  
  func testUserFetchingConfiguredWithErrorShouldFail() {
    
    let mockURLSession = MockURLSession(error: NSError())
    
    let userRepository = UserRepository(urlSession: mockURLSession)
    userRepository.fetch(withSuccess: { _ in
    
      XCTAssert(false, "The fetch should have failed since there was an error")
    
    }, failure: {
    
      XCTAssert(true)
    
    })
    
  }
  
}

class UserTests: XCTestCase {
  
  func testUserFullNameShouldCombineFirstAndLastNames() {
    
    let user = User(firstName: "joe", lastName: "schmoe")
    
    XCTAssertEqual(user.fullName, "Joe Schmoe")
    
  }
  
}
