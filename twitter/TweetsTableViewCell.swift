//
//  TweetsTableViewCell.swift
//  d04
//
//  Created by Anna BIBYK on 1/19/19.
//  Copyright © 2019 Anna BIBYK. All rights reserved.
//

import UIKit

class TweetsTableViewCell: UITableViewCell {
  
    @IBOutlet weak var searchBar: UISearchBar!
    
    @IBOutlet weak var loginLabel: UILabel!
    
    @IBOutlet weak var dateLabel: UILabel!
   
    @IBOutlet weak var tweetLabel: UILabel!
    
    var tweet : (String, String, String)? {
        didSet {
            if let t = tweet {
                loginLabel?.text = t.0
                dateLabel?.text = t.1
                tweetLabel?.text = t.2
            }
        }
    }
}

