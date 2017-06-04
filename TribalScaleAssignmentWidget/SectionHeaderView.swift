//
//  SectionHeaderView.swift
//  TribalScaleAssignment
//
//  Created by Simon Tsai on 6/3/17.
//  Copyright © 2017 Simon Tsai. All rights reserved.
//

import UIKit

class SectionHeaderView: UIView {
  
  @IBOutlet weak var titleLabel: UILabel!
  
  static func make() -> SectionHeaderView {
    
    return UINib(
      nibName: "SectionHeaderView",
      bundle: nil
    ).instantiate(withOwner: nil, options: nil).first as! SectionHeaderView
    
  }
  
}
