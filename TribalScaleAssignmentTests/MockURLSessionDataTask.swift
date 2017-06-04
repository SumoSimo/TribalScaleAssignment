//
//  MockURLSessionDataTask.swift
//  TribalScaleAssignment
//
//  Created by Simon Tsai on 6/2/17.
//  Copyright © 2017 Simon Tsai. All rights reserved.
//

import Foundation

@testable import TribalScaleAssignment

class MockURLSessionDataTask: URLSessionDataTask {
  
  private let responseData: Data?
  
  internal let anError: NSError?
  
  private let completionHandler: (Data?, URLResponse?, Error?) -> Void
  
  init(responseData: Data?, error: NSError?, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) {
    
    self.responseData = responseData
    
    self.anError = error
    
    self.completionHandler = completionHandler
    
    super.init()
    
  }
  
  override func resume() {
    
    completionHandler(responseData, nil, anError)
    
  }
  
}
