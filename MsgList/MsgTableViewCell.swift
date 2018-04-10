//
//  MsgTableViewCell.swift
//  MsgList
//
//  Created by Anna Dickinson on 4/9/18.
//  Copyright © 2018 Anna Dickinson. All rights reserved.
//

import UIKit
import AlamofireImage

class MsgTableViewCell: UITableViewCell {
    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var contentLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
    }
    
    var firstInSequence: Bool = true {
        didSet {
            if firstInSequence {
                avatarImageView.isHidden = false
                nameLabel.isHidden = false
                dateLabel.isHidden = false
            }
            else {
                avatarImageView.isHidden = true
                nameLabel.isHidden = true
                dateLabel.isHidden = true
            }
        }
    }
    
    override func prepareForReuse() {
        avatarImageView.af_cancelImageRequest()

        firstInSequence = true
        avatarImageView.image = nil
        nameLabel.text = ""
        dateLabel.text = ""
        contentLabel.text = ""
    }
}
