//
//  TodayScheduleTableCell.swift
//  Attendance Connect
//
//  Created by Neel on 27/09/18.
//  Copyright © 2018 Neel Makhecha. All rights reserved.
//

import UIKit

class TodayScheduleTableCell: UITableViewCell {
    
    @IBOutlet weak var subjectNameLabel: UILabel!
    
    
    @IBOutlet weak var facultyOrClassName: UILabel!
    
    @IBOutlet weak var timeLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }

}
