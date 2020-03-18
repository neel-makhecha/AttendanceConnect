//
//  ScanFaceViewController.swift
//  Attendance Connect
//
//  Created by Neel on 23/09/18.
//  Copyright © 2018 Neel Makhecha. All rights reserved.
//

import UIKit

class ScanFaceViewController: UIViewController {
    
    
    @IBOutlet weak var faceAnimationView: UIImageView!
    
    
    @IBOutlet weak var MainLabel: UILabel!
    
    
    @IBOutlet weak var performScanOutlet: UIButton!
    
    
    @IBOutlet weak var cancelButtonOutlet: UIButton!
    
    var app_id = ""
    var app_key = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        faceAnimationView.loadGif(name: "ScanAnim")

    }
    
    override func viewDidAppear(_ animated: Bool) {
        if animated{
            
            UIView.animate(withDuration: 4.5, animations: {
                self.MainLabel.alpha = 0.9
            }) { (success) in
                if success{
                    
                    UIView.animate(withDuration: 0.3, animations: {
                        self.MainLabel.alpha = 0
                    }, completion: { (success) in
                        if success{
                            self.MainLabel.text = "Ready for Scan"
                            
                            UIView.animate(withDuration: 0.3, animations: {
                                self.MainLabel.alpha = 1
                                self.performScanOutlet.alpha = 1
                                self.cancelButtonOutlet.alpha = 1
                            }, completion: { (success) in
                                if success{
                                    self.faceAnimationView.image = UIImage(named: "FaceStill")
                                }
                            })
                        }
                    })
                }
            }
        }
    }
    
    
    
    
    @IBAction func performScan(_ sender: Any) {
        let nextVC = self.storyboard?.instantiateViewController(withIdentifier: "cameraVC") as! CameraViewController
        self.present(nextVC, animated: true, completion: nil)
    }
    
    
    @IBAction func cancelTapped(_ sender: Any) {
        
        self.dismiss(animated: true, completion: nil)
    }
    

    

}
