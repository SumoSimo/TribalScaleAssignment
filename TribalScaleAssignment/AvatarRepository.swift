//
//  AvatarRepository.swift
//  TribalScaleAssignment
//
//  Created by Simon Tsai on 6/3/17.
//  Copyright © 2017 Simon Tsai. All rights reserved.
//

import Foundation
import UIKit

class AvatarRepository {
  
  private let urlSession = URLSession(configuration: .default)
  
  private var cache: [String: UIImage] = [:]
  
  private var thumbnailLinkToTaskMapping: [String: URLSessionDataTask] = [:]
  
  func fetch(for user: User, success: @escaping (_ image: UIImage) -> Void) {
    
    if let cachedImage = cache[user.thumbnailLink] {
        
      success(cachedImage)
      
    } else if let avatarURL = URL(string: user.thumbnailLink) {
      
      let avatarTask = urlSession.dataTask(with: avatarURL, completionHandler: { [weak self] data, _, error in
        
        if let avatarData = data, let avatarImage = UIImage(data: avatarData) {
          
          DispatchQueue.main.async { [weak self] in
            
            self?.cache[user.thumbnailLink] = avatarImage
            
            self?.thumbnailLinkToTaskMapping.removeValue(forKey: user.thumbnailLink)
            
            success(avatarImage)
            
          }
          
        }
        
      })
      
      thumbnailLinkToTaskMapping[user.thumbnailLink] = avatarTask
      
      avatarTask.resume()
      
    }
    
  }
  
  func cancelFetch(for user: User) {
    
    if let task = thumbnailLinkToTaskMapping[user.thumbnailLink] {
      
      task.cancel()
      
      thumbnailLinkToTaskMapping.removeValue(forKey: user.thumbnailLink)
      
    }
    
  }
  
}
