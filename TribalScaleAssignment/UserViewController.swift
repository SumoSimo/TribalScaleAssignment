//
//  UserViewController.swift
//  TribalScaleAssignment
//
//  Created by Simon Tsai on 6/2/17.
//  Copyright © 2017 Simon Tsai. All rights reserved.
//

import MBProgressHUD
import UIKit

class UserViewController: UITableViewController {
  
  private let userRepository = UserRepository(urlSession: URLSession(configuration: .default))
  
  private let avatarRepository = AvatarRepository()
  
  private var users: [User]?
  
  private lazy var userFetchFailure: () -> Void = {
  
    return { [weak self] in

      guard let `self` = self else {
        
        return
        
      }
      
      MBProgressHUD.hide(for: self.view, animated: true)
      
      let tryAgainAction = UIAlertAction(title: "Try Again", style: .default, handler: { _ in
        
        self.fetchUsers()
    
      })
      
      let alertController = UIAlertController(title: "Error", message: "Please try again", preferredStyle: .alert)
      alertController.addAction(tryAgainAction)
      
      self.present(alertController, animated: true, completion: nil)
      
    }
    
  }()
  
  override func viewDidLoad() {
    
    super.viewDidLoad()
    
    fetchUsers()
    
  }
  
  func fetchUsers() {
    
    let progressHUD = MBProgressHUD.showAdded(to: view, animated: true)
    
    userRepository.fetch(
      withSuccess: { [weak self] users in
        
        self?.users = users
        
        progressHUD.hide(animated: true)
        
        self?.tableView.reloadData()
        
      }, failure: userFetchFailure
    )
    
  }
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    
    super.prepare(for: segue, sender: sender)
    
    if let userDetailViewController = segue.destination as? UserDetailViewController {
      
      userDetailViewController.user = sender as! User
      
    }
    
  }
  
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    
    guard let users = users else {
      
      return 0
      
    }
    
    return users.count > 0 ? users.count : 1
    
  }
   
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
    // At this point, 'users' must be allocated
    guard users!.count > 0 else {
      
      return tableView.dequeueReusableCell(withIdentifier: "noContactsCell", for: indexPath)
      
    }
    
    // At this point, 'users' must be allocated
    let user = users![indexPath.row]
    
    let userCell = tableView.dequeueReusableCell(withIdentifier: "UserCell", for: indexPath) as! UserCell
    userCell.nameLabel.text = user.fullName
    
    return userCell
    
  }
  
  override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
    
    // At this point, 'users' must be allocated
    guard users!.count > 0 else {
      
      return
      
    }
    
    let userCell = cell as! UserCell
    userCell.avatarImageView.image = nil
    
    // At this point, 'users' must be allocated
    avatarRepository.fetch(for: users![indexPath.row], success: { avatarImage in
      
      // The fact that the success closure is even called means the cell has never gone off the screen with respect to 'didEndDisplaying cell:'
      userCell.avatarImageView.image = avatarImage
      
    })
    
  }
  
  override func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
    
    // At this point, 'users' must be allocated
    guard users!.count > 0 else {
      
      return
      
    }
    
    // At this point, 'users' must be allocated
    avatarRepository.cancelFetch(for: users![indexPath.row])
    
  }
  
  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    
    tableView.deselectRow(at: indexPath, animated: true)
    
    // At this point, 'users' must be allocated
    performSegue(withIdentifier: "userDetailSegueIdentifier", sender: users![indexPath.row])
    
  }
  
}

extension URLSession: URLSessionProtocol {}
