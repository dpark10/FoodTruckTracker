//
//  QRScannerViewController.swift
//
//
//  Created by dp on 4/27/16.
//  Copyright © 2016 Dan Park. All rights reserved.
//

import UIKit
import AVFoundation

class ScannerViewController: UIViewController, AVCaptureMetadataOutputObjectsDelegate {
    
    @IBOutlet weak var qrCodeLabel: UILabel!
    @IBOutlet weak var qrCodeResultLabel: UILabel!
    
    var objCaptureSession: AVCaptureSession?
    var objCaptureVideoPreviewLayer: AVCaptureVideoPreviewLayer?
    var vwQRCode: UIView?
    var foodTruck = FoodTruck?()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.configureVideoCapture()
        self.addVideoPreviewLayer()
        self.initializeQRView()
        
    }
    
    func configureVideoCapture() {
        let objCaptureDevice = AVCaptureDevice.defaultDeviceWithMediaType(AVMediaTypeVideo)
        var error: NSError?
        let objCaptureDeviceInput: AnyObject!
        
        do {
            objCaptureDeviceInput = try AVCaptureDeviceInput(device: objCaptureDevice) as AVCaptureDeviceInput
        } catch let error1 as NSError {
            error = error1
            objCaptureDeviceInput = nil
        }
        
        if (error != nil) {
            let alertController:UIAlertController = UIAlertController(title: "Device Error", message: "Device not supported", preferredStyle: .Alert)
            let cancelAction:UIAlertAction = UIAlertAction(title: "OK", style: .Cancel, handler: { (alertAction) -> Void in
                alertController.dismissViewControllerAnimated(true, completion: nil)
            })
            
            alertController.addAction(cancelAction)
            self.presentViewController(alertController, animated: true, completion: nil)
            return
        }
        
        objCaptureSession = AVCaptureSession()
        objCaptureSession?.addInput(objCaptureDeviceInput as! AVCaptureInput)
        let objCaptureMetadataOutput = AVCaptureMetadataOutput()
        objCaptureSession?.addOutput(objCaptureMetadataOutput)
        objCaptureMetadataOutput.setMetadataObjectsDelegate(self, queue: dispatch_get_main_queue())
        objCaptureMetadataOutput.metadataObjectTypes = [AVMetadataObjectTypeQRCode]
        
    }
    
    func addVideoPreviewLayer() {
        objCaptureVideoPreviewLayer = AVCaptureVideoPreviewLayer(session: objCaptureSession)
        objCaptureVideoPreviewLayer?.videoGravity = AVLayerVideoGravityResizeAspectFill
        objCaptureVideoPreviewLayer?.frame = view.layer.bounds
        self.view.layer.addSublayer(objCaptureVideoPreviewLayer!)
        objCaptureSession?.startRunning()
        
        self.view.bringSubviewToFront(qrCodeLabel)
        self.view.bringSubviewToFront(qrCodeResultLabel)
    }
    
    
    func initializeQRView() {
        vwQRCode = UIView()
        vwQRCode?.layer.borderColor = UIColor.redColor().CGColor
        vwQRCode?.layer.borderWidth = 5
        self.view.addSubview(vwQRCode!)
        self.view.bringSubviewToFront(vwQRCode!)
    }
    
    func captureOutput(captureOutput: AVCaptureOutput!, didOutputMetadataObjects metadataObjects: [AnyObject]!, fromConnection connection: AVCaptureConnection!) {
        if metadataObjects == nil || metadataObjects.count == 0 {
            vwQRCode?.frame = CGRectZero
            qrCodeResultLabel.text = "No QR Code"
            return
        }
        let objMetadataMachineReadableCodeObject = metadataObjects[0] as! AVMetadataMachineReadableCodeObject
        if objMetadataMachineReadableCodeObject.type == AVMetadataObjectTypeQRCode {
            let objBarCode = objCaptureVideoPreviewLayer?.transformedMetadataObjectForMetadataObject(objMetadataMachineReadableCodeObject as AVMetadataMachineReadableCodeObject) as! AVMetadataMachineReadableCodeObject
            vwQRCode?.frame = objBarCode.bounds;
            if objMetadataMachineReadableCodeObject.stringValue != nil {
                qrCodeResultLabel.text = objMetadataMachineReadableCodeObject.stringValue
                let qrCode = qrCodeResultLabel.text
                let qrArray = qrCode!.characters.split{$0 == "."}.map(String.init)
                let couponCode = qrArray[0]
                let userID = qrArray[1]
                let couponID = qrArray[2]
                if couponCode == foodTruck?.couponCode {
                    AudioServicesPlaySystemSound(SystemSoundID(kSystemSoundID_Vibrate))
                    vwQRCode?.layer.borderColor = UIColor.greenColor().CGColor
                    objCaptureSession?.stopRunning()
                    let truckRef = DataService.dataService.REF_BASE.childByAppendingPath("visitedTrucks").childByAppendingPath("\(foodTruck?.name)\(userID)")
                    let truckDict = ["name": (foodTruck?.name)! as String, "truckID": (foodTruck?.uid)! as String, "userID": userID]
                    truckRef.setValue(truckDict)
                    let couponRef = DataService.dataService.REF_BASE.childByAppendingPath("coupons").childByAppendingPath(couponID)
                    let couponDict = ["couponCode": "Not Valid", "active?": false]
                    couponRef.updateChildValues(couponDict)
                    self.validCodeAlert(couponCode)
                    
                }
            }
        }
    }
    
    func validCodeAlert(couponCode: String) {
        let alert = UIAlertController(title: "This is a valid coupon", message: "Coupon code: \(couponCode)", preferredStyle: .Alert)
        let okAction = UIAlertAction(title: "OK", style: .Default) { UIAlertAction in
            self.reloadView()
        }
        alert.addAction(okAction)
     
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    func reloadView() {
        super.viewDidLoad()
        
        self.configureVideoCapture()
        self.addVideoPreviewLayer()
        self.initializeQRView()
    }
    
    @IBAction func dismissButtonTapped(sender: UIButton) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
}
