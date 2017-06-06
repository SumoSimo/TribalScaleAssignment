//
//  UserRepository.swift
//  TribalScaleAssignment
//
//  Created by Simon Tsai on 6/2/17.
//  Copyright © 2017 Simon Tsai. All rights reserved.
//

import Foundation

class UserRepository {
  
  private let numberOfDesiredResults: Int
  
  private let urlSession: URLSessionProtocol
  
  init(numberOfDesiredResults: Int = 100, urlSession: URLSessionProtocol) {
    
    self.numberOfDesiredResults = numberOfDesiredResults
    
    self.urlSession = urlSession
    
  }
  
  func fetch(withSuccess success: ((_ users: [User]) -> Void)?, failure: (() -> Void)?) {
    
    let task = urlSession.dataTask(
      with: URL(string: "https://randomuser.me/api/1.1/?results=\(numberOfDesiredResults)")!,
      completionHandler: { data, response, error in
        
        DispatchQueue.main.async {
          
          guard error == nil else {
            
            failure?()
            
            return
            
          }
          
          if let data = data {
            
            let payload = try! JSONSerialization.jsonObject(with: data, options: .mutableContainers) as! [String: Any]
            
            guard !payload.contains(where: { key, _ -> Bool in
              
              return key == "error"
              
            }) else {
              
              failure?()
              
              return
              
            }
            
            let allUsersPayload = payload["results"] as! [[String: Any]]
            
            let users = allUsersPayload.map({ userPayload -> User in
                return User(userPayload: userPayload)
            })
            
            success?(users)
            
          } else {
            
            failure?()
            
          }
          
        }
        
      }
    )
    
    task.resume()
    
  }
  
}
