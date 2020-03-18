//
//  AttendanceMethodViewController.swift
//  Attendance Connect
//
//  Created by Neel on 19/09/18.
//  Copyright © 2018 Neel Makhecha. All rights reserved.
//

import UIKit

class AttendanceMethodViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    
    @IBAction func closeButtonTapped(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func generateAttendanceCode(_ sender: Any) {
        
        let nextVC = self.storyboard?.instantiateViewController(withIdentifier: "attendanceCodeVC") as! AttendanceCodeViewController
        self.present(nextVC, animated: true, completion: nil)

    }
    
    
    @IBAction func generateAttendanceQRCode(_ sender: Any) {
    }
    
    @IBAction func useFaceRecognition(_ sender: Any) {
        
        let nextVC = self.storyboard?.instantiateViewController(withIdentifier: "scanFaceVC") as! ScanFaceViewController
        self.present(nextVC, animated: true, completion: nil)
    }
    
    
}
