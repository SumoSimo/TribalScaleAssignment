//
//  UserCell.swift
//  TribalScaleAssignment
//
//  Created by Simon Tsai on 6/3/17.
//  Copyright © 2017 Simon Tsai. All rights reserved.
//

import UIKit

class UserCell: UITableViewCell {
  
  @IBOutlet weak var avatarImageView: UIImageView! {
    
    didSet {
      
      avatarImageView.layer.cornerRadius = avatarImageView.frame.size.width / 2
      
    }
    
  }
  
  @IBOutlet weak var nameLabel: UILabel!

}
