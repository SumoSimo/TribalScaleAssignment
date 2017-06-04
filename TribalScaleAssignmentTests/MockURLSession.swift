//
//  MockURLSession.swift
//  TribalScaleAssignment
//
//  Created by Simon Tsai on 6/2/17.
//  Copyright © 2017 Simon Tsai. All rights reserved.
//

import Foundation

@testable import TribalScaleAssignment

class MockURLSession: URLSessionProtocol {

  private(set) var lastURL: URL?
  
  private(set) var numberOfTimesUsed = 0
  
  private let responseData: Data?
  
  private let error: NSError?
  
  init(responseData: Data? = nil, error: NSError? = nil) {
    
    self.responseData = responseData
    
    self.error = error
    
  }
  
  func dataTask(with url: URL, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask {
    
    lastURL = url
    
    numberOfTimesUsed += 1
    
    return MockURLSessionDataTask(responseData: responseData, error: error, completionHandler: completionHandler)
    
  }

}
