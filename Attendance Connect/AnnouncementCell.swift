//
//  AnnouncementCell.swift
//  Attendance Connect
//
//  Created by Neel on 22/08/18.
//  Copyright © 2018 Neel Makhecha. All rights reserved.
//

import UIKit

class AnnouncementCell: UITableViewCell {
    
    
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var teacherLabel: UILabel!
    
    @IBOutlet weak var contentLabel: UILabel!
    
    @IBOutlet weak var dateLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
       // self.contentView.heightAnchor.constraint(equalToConstant: 200)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
