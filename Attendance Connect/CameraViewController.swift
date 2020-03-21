//
//  CameraViewController.swift
//  Attendance Connect
//
//  Created by Neel on 23/09/18.
//  Copyright © 2018 Neel Makhecha. All rights reserved.
//

import UIKit
import AVFoundation
import Alamofire
import SwiftyJSON

class CameraViewController: UIViewController {
    
    var app_id = "" //Place your app_id here
    var app_key = "" //Place your app_key here

    
    var captureSession:AVCaptureSession?
    var videoPreviewayer:AVCaptureVideoPreviewLayer?
    var photoOutput = AVCapturePhotoOutput()
    var inputDevice:AVCaptureDeviceInput?
    var flash: AVCaptureDevice.FlashMode = .off
    var usingFrontCamera = false
    var usingFlash = false

    @IBOutlet weak var flashButtonOutlet: UIButton!
    
    @IBOutlet weak var resultView: UIView!
    
    
    @IBOutlet weak var resultTextView: UITextView!
    
    
    @IBOutlet weak var loadingIndicator: UIImageView!
    
    @IBOutlet weak var processingLabel: UILabel!
    
    
    @IBOutlet weak var cameraPreview: UIView!
    
    
    @IBOutlet weak var cancelButtonOutlet: UIButton!
    
    var receivedGalleryName = "\(selectedClassID)"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadingIndicator.alpha = 0
        processingLabel.alpha = 0
        
        resultView.alpha = 0
        
        AVCaptureDevice.requestAccess(for: AVMediaType.video) { response in
            if response {
                self.loadCamera()
            }
        }


    }
    
    
    @IBAction func closeTapped(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func capture() {
        let settings = AVCapturePhotoSettings()
        settings.flashMode = flash
        photoOutput.capturePhoto(with: settings, delegate: self)
    }
    
    @IBAction func captureTapped(_ sender: Any) {
        
        UIView.animate(withDuration: 0.25) {
            self.resultView.alpha = 1
            self.processingLabel.alpha = 1
            self.loadingIndicator.alpha = 1
        }
        
        UIView.animate(withDuration: 0.5, delay: 0, options: [.repeat,.autoreverse], animations: {
            self.loadingIndicator.transform = CGAffineTransform(rotationAngle: CGFloat.pi)
        }, completion: {
            (success) in
        })
        capture()
    }
    
    func recognize(imageBase64: String) {
        var request = URLRequest(url: URL(string: "https://api.kairos.com/recognize")!)
        request.httpMethod = HTTPMethod.post.rawValue
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue(app_id, forHTTPHeaderField: "app_id")
        request.setValue(app_key, forHTTPHeaderField: "app_key")
        
        let params : NSMutableDictionary? = [
            "image" : imageBase64,
            "gallery_name" : receivedGalleryName,
            ]
        
        let data = try! JSONSerialization.data(withJSONObject: params!, options: JSONSerialization.WritingOptions.prettyPrinted)
        
        let json = NSString(data: data, encoding: String.Encoding.utf8.rawValue)
        request.httpBody = json!.data(using: String.Encoding.utf8.rawValue);
        
        Alamofire.request(request).responseJSON { (response) in
            if((response.result.value) != nil) {
                let json = JSON(response.result.value)
                
                print("Original JSON")
                print(json)
                UIView.animate(withDuration: 0.5, animations: {
                    self.processingLabel.alpha = 0
                    self.loadingIndicator.alpha = 0
                })
                
                let data = response.data
                var subjectNames = [String]()
                let jsonObj = try? JSONSerialization.jsonObject(with: data!, options: []) as? [String:Any]
                print("jsonObj:")
                print(jsonObj)
                let images = jsonObj!?["images"] as? [Any]
                
                print("Images:")
                print(images)
                
                for image in images!{
                    let innerDict = image as! [String:Any]
                    
                    print("InnerDcit")
                    print(innerDict)
                    
                    let candidates = innerDict["candidates"] as! [[String:Any]]
                    print("Candidates")
                    print(candidates)
                    
                    var confidenceLevel:Int = 0
                    
                    for person in candidates{
                        
                        let confidenceString:NSNumber = person["confidence"] as! NSNumber
                        print("Obtained ConfidenceString: \(confidenceString)")
                        
                        var confidenceLevel:Float = Float(confidenceString)
                        
                        if confidenceLevel > 0.8{
                            print("Passed Confidence Level: \(confidenceLevel)")
                            subjectNames.append(person["subject_id"] as! String)
                        }else{
                            print("Failed Confidence Level: \(confidenceLevel)")
                        }
                        
                    }

                }
            
                
                print("All Person")
                print(subjectNames)
                
                subjectNames.removeDuplicates()
                
                print("SubjectName after removing duplicates")
                print(subjectNames)
                
                var resultString = String();
                resultString = "These are the people detected:\n"
                
                for person in subjectNames{
                    
                    resultString.append("\n" + person)
                    
                }
                
                self.resultTextView.text = "\(resultString)"
                self.cancelButtonOutlet.titleLabel?.text = "Close "
                let alert = UIAlertController(title: "Total People: \(subjectNames.count).", message: "", preferredStyle: .alert)
                let okAction = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
                alert.addAction(okAction)
                self.present(alert, animated: true, completion: nil)
                
            }
        }
    }
    
    
    @IBAction func cancelProcessing(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func changeCamera(_ sender: Any) {
        self.usingFrontCamera = !self.usingFrontCamera
        self.loadCamera()
    }
    
    
    @IBAction func flashSwitch(_ sender: Any) {
        
        self.usingFlash = !self.usingFlash
        
        if(self.usingFlash) {
            flash = .on
            flashButtonOutlet.setImage(UIImage(named: "flashOn"), for: .normal)
        } else {
            flash = .off
            flashButtonOutlet.setImage(UIImage(named: "flashOff"), for: .normal)
        }
    }
    
    
    
    func getFrontCamera() -> AVCaptureDevice?{
        return AVCaptureDevice.default(.builtInWideAngleCamera, for:AVMediaType.video, position: AVCaptureDevice.Position.front)!
    }
    
    func getBackCamera() -> AVCaptureDevice{
        return AVCaptureDevice.default(.builtInWideAngleCamera, for:AVMediaType.video, position: AVCaptureDevice.Position.back)!
    }
    
    func loadCamera() {
        var isFirst = false
        
        DispatchQueue.global().async {
            if(self.captureSession == nil){
                isFirst = true
                self.captureSession = AVCaptureSession()
                self.captureSession!.sessionPreset = AVCaptureSession.Preset.hd1280x720
            }
            var error: NSError?
            var input: AVCaptureDeviceInput!
            
            let currentCaptureDevice = (self.usingFrontCamera ? self.getFrontCamera() : self.getBackCamera())
            
            do {
                input = try AVCaptureDeviceInput(device: currentCaptureDevice!)
            } catch let error1 as NSError {
                error = error1
                input = nil
                print(error!.localizedDescription)
            }
            
            for i : AVCaptureDeviceInput in (self.captureSession?.inputs as! [AVCaptureDeviceInput]) {
                self.captureSession?.removeInput(i)
            }
            
            for i : AVCaptureOutput in (self.captureSession!.outputs) {
                self.captureSession?.removeOutput(i)
            }
            
            if error == nil && self.captureSession!.canAddInput(input) {
                self.captureSession!.addInput(input)
            }
            
            if (self.captureSession?.canAddOutput(self.photoOutput))! {
                self.captureSession?.addOutput(self.photoOutput)
            } else {
                print("Error: Couldn't add meta data output")
                return
            }
            
            DispatchQueue.main.async {
                if isFirst {
                    self.videoPreviewayer = AVCaptureVideoPreviewLayer(session: self.captureSession!)
                    self.videoPreviewayer!.videoGravity = AVLayerVideoGravity.resizeAspectFill
                    self.videoPreviewayer!.connection?.videoOrientation = AVCaptureVideoOrientation.portrait
                    self.videoPreviewayer?.frame = self.cameraPreview.layer.bounds
                    self.cameraPreview.layer.sublayers?.forEach { $0.removeFromSuperlayer() }
                    self.cameraPreview.layer.addSublayer(self.videoPreviewayer!)
                    self.captureSession!.startRunning()
                }
            }
        }
        
    }
    
    override var prefersStatusBarHidden: Bool{
        return true
    }
    
    func jsonToDict(json:JSON) -> [String:Any]?{
        
        var data:Data? = nil
        
        do{
            data = try json.rawData(options: .prettyPrinted)
            
            do{
                let dictionary:Dictionary = try JSONSerialization.jsonObject(with: data!, options: []) as! [String:Any]
                return dictionary
                
            }catch{
                print(error.localizedDescription)
            }
        }catch{
            print("Error occured while fetching rawdata from JSON")
            print(error.localizedDescription)
        }
        
        
            
        
        return nil
        
    }
    

}

extension CameraViewController : AVCapturePhotoCaptureDelegate {
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        let imageData = photo.fileDataRepresentation()
        let image = UIImage(data: imageData!)
        
        let imagedata = UIImageJPEGRepresentation(image!, 1.0)
        let base64String : String = imagedata!.base64EncodedString(options: Data.Base64EncodingOptions(rawValue: 0))
        let imageStr : String = base64String.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        
        print("RECOGNIZE")
        recognize(imageBase64: imageStr)
    }
}


//Extension of Array for removing the unnecessary duplicates obtained by manipulating image
extension Array where Element: Hashable {
    func removingDuplicates() -> [Element] {
        var addedDict = [Element: Bool]()
        
        return filter {
            addedDict.updateValue(true, forKey: $0) == nil
        }
    }
    
    mutating func removeDuplicates() {
        self = self.removingDuplicates()
    }
}   
