//
//  MsgTableViewSectionHeader.swift
//  MsgList
//
//  Created by Anna Dickinson on 4/9/18.
//  Copyright © 2018 Anna Dickinson. All rights reserved.
//

import UIKit

class MsgTableViewSectionHeader: UITableViewHeaderFooterView {
    @IBOutlet weak var dateLabel: UILabel!
    
    override func prepareForReuse() {
        dateLabel.text = ""
    }
}
