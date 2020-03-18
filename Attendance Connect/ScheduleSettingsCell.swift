//
//  ScheduleSettingsCell.swift
//  Attendance Connect
//
//  Created by Neel on 22/09/18.
//  Copyright © 2018 Neel Makhecha. All rights reserved.
//

import UIKit

class ScheduleSettingsCell: UITableViewCell {

    @IBOutlet weak var scheuledCheckButton: UIButton!
    
    @IBOutlet weak var dayLabel: UILabel!
    
    @IBOutlet weak var hoursButton: UIButton!
    
    @IBOutlet weak var minutesLabel: UIButton!
    
    @IBOutlet weak var ampmButton: UIButton!
    
    var scheduled:Bool = Bool()
    var hours:Int = Int()
    var minutes:Int = Int()
    var isAM:Bool = Bool()
    
    @IBAction func scheduledCheckButtonTapped(_ sender: Any) {
        
        if scheduled == true{
            scheuledCheckButton.setImage(UIImage(named: "done"), for: .normal)

            print("Schedule Enabled")
            scheduled = false
        }
        else{
            scheuledCheckButton.setImage(UIImage(named: "close"), for: .normal)
            print("Schedule Disabled")
            scheduled = true
        }
    }
    
    
    @IBAction func hoursButtonTapped(_ sender: Any) {
        
        
        
        
    }
    
    
    @IBAction func minutesButtonTapped(_ sender: Any) {
    }
    
    @IBAction func ampmButtonTapped(_ sender: Any) {
    }
    
}
