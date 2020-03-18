//
//  AnnouncementExpandViewController.swift
//  Attendance Connect
//
//  Created by Neel on 27/08/18.
//  Copyright © 2018 Neel Makhecha. All rights reserved.
//

import UIKit

class AnnouncementExpandViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
   
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
       // self.navigationController?.hidesBarsOnSwipe = true
       // self.navigationController?.title = "Memory of Steve Jobs"
        self.navigationItem.title = "Announcement"
          self.navigationItem.largeTitleDisplayMode = .never

    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.row == 0{
            
            let cell:TitleCell = tableView.dequeueReusableCell(withIdentifier: "titleCell") as! TitleCell
            cell.titleLabel.text = "Presentation Tomorrow"
            cell.teacherLabel.text = "Ms. Miley Jackson"
            tableView.rowHeight = CGFloat(65)
            //cell.contentView.heightAnchor.constraint(equalToConstant: 65)
            return cell
        
        }
        
        else if indexPath.row == 1{
            
            let cell:DateCell = tableView.dequeueReusableCell(withIdentifier: "dateCell") as! DateCell
            cell.dateLabel.text = "September 31, 2018"
            tableView.rowHeight = CGFloat(20)
            //cell.contentView.heightAnchor.constraint(equalToConstant: 20)
            return cell
        }
        
        else if indexPath.row == 2{
            
            let cell:ContentCell = tableView.dequeueReusableCell(withIdentifier: "contentCell") as! ContentCell
            cell.contentLabel.text = "Hello Students! Tomorrow be prepared with your presentation for Software Group Project. Be prepared with following things:\n1. PowerPoint PPT\n2. More then 50% of your completed project demo. \n3. Partners of the project should remain present if any. \n4. All the partners are supposed to speak at least 1 min. about the project in presentation. "
            
            tableView.rowHeight = CGFloat(280)
            //
            cell.contentLabel.heightAnchor.constraint(equalToConstant: 280)
            
            return cell
        }
        
        else{
            
            let cell:DateCell = tableView.dequeueReusableCell(withIdentifier: "dateCell") as! DateCell
            
            cell.dateLabel.text = "Extraneous Cell Generated"
            return cell
        }
    }

}

class TitleCell:UITableViewCell{
    
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var teacherLabel: UILabel!
    
}

class DateCell:UITableViewCell{

    @IBOutlet weak var dateLabel: UILabel!

}

class ContentCell:UITableViewCell{
    
    @IBOutlet weak var contentLabel: UILabel!
    
}
