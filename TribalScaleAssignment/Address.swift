//
//  Address.swift
//  TribalScaleAssignment
//
//  Created by Simon Tsai on 6/3/17.
//  Copyright © 2017 Simon Tsai. All rights reserved.
//

import Foundation

struct Address {
  
  let street: String
  
  let city: String
  
  let state: String
  
  let zipCode: String
  
  init(street: String = "", city: String = "", state: String = "", zipCode: String = "") {
    
    self.street = street
    
    self.city = city
    
    self.state = state
    
    self.zipCode = zipCode
    
  }
  
}

extension Address: Equatable {
  
  static func ==(lhs: Address, rhs: Address) -> Bool {
    
    return lhs.street == rhs.street && lhs.city == rhs.city && lhs.state == rhs.state && lhs.zipCode == rhs.zipCode
    
  }
  
}
