//
//  TodayViewController.swift
//  TribalScaleAssignmentWidget
//
//  Created by Simon Tsai on 6/3/17.
//  Copyright © 2017 Simon Tsai. All rights reserved.
//

import UIKit
import NotificationCenter

class TodayViewController: UIViewController, NCWidgetProviding {
        
  @IBOutlet private weak var tableView: UITableView!
  
  private let userRepository = UserRepository(urlSession: URLSession(configuration: .default))
  
  fileprivate let avatarRepository = AvatarRepository()
  
  fileprivate var users: [User]?
  
  override func viewDidLoad() {
    
    super.viewDidLoad()
    
    extensionContext?.widgetLargestAvailableDisplayMode = .expanded
    
  }
  
  func widgetPerformUpdate(completionHandler: (@escaping (NCUpdateResult) -> Void)) {
    userRepository.fetch(
      withSuccess: { [weak self] users in
        
        let todayDateComponents = Calendar.current.dateComponents([.month, .day], from: Date())
        
        self?.users = Array(users.filter({ user -> Bool in
          
          guard let birthday = user.birthday else {
            
            return false
            
          }
          
          let birthdayDateComponents = Calendar.current.dateComponents([.month, .day], from: birthday)
          
          return todayDateComponents.month! == birthdayDateComponents.month! &&
            todayDateComponents.day! == birthdayDateComponents.day!
          
        }).prefix(3))
        
        self?.tableView.reloadData()
        
        completionHandler(.newData)
        
      }, failure: {
        
        completionHandler(.noData)
        
      }
    )
    
  }
  
  func widgetActiveDisplayModeDidChange(_ activeDisplayMode: NCWidgetDisplayMode, withMaximumSize maxSize: CGSize) {
    
    switch activeDisplayMode {
    case .compact:
      preferredContentSize = CGSize(width: maxSize.width, height: 210)
    case .expanded:
      preferredContentSize = CGSize(width: maxSize.width, height: 250)
    }
    
  }
    
}

extension TodayViewController: UITableViewDataSource {
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    
    guard let users = users else {
      
      return 0
      
    }
    
    return users.count > 0 ? users.count : 1
    
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
    // At this point, 'users' must be allocated
    guard users!.count > 0 else {
      
      return tableView.dequeueReusableCell(withIdentifier: "noBirthdaysCell", for: indexPath)
      
    }
    
    let userCell = tableView.dequeueReusableCell(withIdentifier: "UserCell", for: indexPath) as! UserCell
    userCell.nameLabel.text = users![indexPath.row].fullName // At this point, 'users' must be allocated
    
    return userCell
    
  }
  
}

extension TodayViewController: UITableViewDelegate {
  
  func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
    
    // At this point, 'users' must be allocated
    guard users!.count > 0 else {
      
      return
      
    }
    
    let userCell = cell as! UserCell
    userCell.avatarImageView.image = nil
    
    // At this point, 'users' must be allocated
    avatarRepository.fetch(for: users![indexPath.row], success: { avatarImage in
      
      userCell.avatarImageView.image = avatarImage
      
    })
    
  }
  
  func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
    
    // At this point, 'users' must be allocated
    guard users!.count > 0 else {
      
      return
      
    }
    
    // At this point, 'users' must be allocated
    avatarRepository.cancelFetch(for: users![indexPath.row])
    
  }
  
  func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
    
    return 35
    
  }
  
  func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
    
    // Don't need to focus on recycling of header views since it's just one section in a widget
    let sectionHeaderView = SectionHeaderView.make()
    sectionHeaderView.backgroundColor = view.backgroundColor
    sectionHeaderView.titleLabel.text = "Birthdays"
    
    return sectionHeaderView
    
  }
  
}

extension URLSession: URLSessionProtocol {}
