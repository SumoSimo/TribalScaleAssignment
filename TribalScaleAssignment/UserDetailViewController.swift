//
//  UserDetailViewController.swift
//  TribalScaleAssignment
//
//  Created by Simon Tsai on 6/3/17.
//  Copyright © 2017 Simon Tsai. All rights reserved.
//

import UIKit

class UserDetailViewController: UITableViewController {
  
  @IBOutlet private weak var userPhotoImageView: UIImageView! {
    
    didSet {
      
      userPhotoImageView.layer.cornerRadius = userPhotoImageView.frame.width / 2
      
    }
    
  }
  
  var user: User!
  
  override func viewDidLoad() {
    
    super.viewDidLoad()
    
    navigationItem.title = user.fullName
    
    let imageData = try! Data(contentsOf: URL(string: user.largePictureLink)!)
    
    userPhotoImageView.image = UIImage(data: imageData)
    
    tableView.estimatedRowHeight = 60
    tableView.rowHeight = UITableViewAutomaticDimension
    
  }
  
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    
    return 3
    
  }
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
    let cell: UITableViewCell
    
    let subject = self.subject(for: indexPath)
    
    let detail = self.detail(for: indexPath)
    
    if indexPath.row == 0 {
      
      let subjectDetailCell = tableView.dequeueReusableCell(
        withIdentifier: "SubjectDetailCell",
        for: indexPath
      ) as! SubjectDetailCell
      subjectDetailCell.subjectLabel.text = subject
      subjectDetailCell.detailLabel.text = detail
      
      cell = subjectDetailCell
      
    } else {
      
      let selector: Selector
      
      if indexPath.row == 1 {
        
        selector = #selector(UserDetailViewController.tryCalling)
        
      } else {
        
        selector = #selector(UserDetailViewController.tryEmailing)
        
      }
      
      let subjectDetailButtonCell = tableView.dequeueReusableCell(
        withIdentifier: "SubjectDetailButtonCell",
        for: indexPath
      ) as! SubjectDetailButtonCell
      subjectDetailButtonCell.subjectLabel.text = subject
      subjectDetailButtonCell.detailButton.setTitle(detail, for: .normal)
      subjectDetailButtonCell.detailButton.addTarget(self, action: selector, for: .touchUpInside)
      
      cell = subjectDetailButtonCell
      
    }
    
    return cell
    
  }
  
  private func subject(for indexPath: IndexPath) -> String {
    
    let subject: String
    
    if indexPath.row == 0 {
      
      subject = "Address:"
      
    } else if indexPath.row == 1 {
      
      subject = "Cell:"
      
    } else {
      
      subject = "Email:"
      
    }

    return subject
    
  }
  
  private func detail(for indexPath: IndexPath) -> String {
    
    let detail: String
    
    if indexPath.row == 0 {
      
      detail = "\(user.address.street)\n\(user.address.city), \(user.address.state) \(user.address.zipCode)"
      
    } else if indexPath.row == 1 {
      
      detail = user.cellPhoneNumber
      
    } else {
      
      detail = user.email
      
    }
    
    return detail
    
  }

}

// MARK: - IBActions/Target-Actions

private extension UserDetailViewController {
  
  @objc func tryCalling() {
    
    if let phoneURL = URL(string: "tel://\(user.cellPhoneNumber)"), UIApplication.shared.canOpenURL(phoneURL) {
      
      UIApplication.shared.open(phoneURL)
      
    }
    
  }
  
  @objc func tryEmailing() {
    
    if let emailURL = URL(string: "mailto:\(user.email)"), UIApplication.shared.canOpenURL(emailURL) {
      
      UIApplication.shared.open(emailURL)
      
    }
    
  }
  
}
