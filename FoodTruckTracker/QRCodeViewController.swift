//
//  QRCodeViewController.swift
//  FoodTruckTracker
//
//  Created by dp on 5/4/16.
//  Copyright © 2016 Dan Park. All rights reserved.
//

import UIKit

class QRCodeViewController: UIViewController {

    // MARK: IBOutlets
    
    @IBOutlet weak var foodTruckNameLabel: UILabel!
    @IBOutlet weak var couponDescriptionLabel: UILabel!
    @IBOutlet weak var expDateLabel: UILabel!
    
    @IBOutlet weak var qrCodeImage: UIImageView!
    
    // MARK: Properties
    var coupon = Coupon?()
    
    // MARK: View Management
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if coupon!.couponCode == "Not Valid" || coupon!.couponCode == "Unavailable" {
            qrCodeImage.image = UIImage(named: "question")
        } else {
        let image = self.generateQRCodeFromString(coupon!.couponCode)
        qrCodeImage.image = image
        }
        foodTruckNameLabel.text = coupon?.foodTruck
        couponDescriptionLabel.text = coupon?.couponDesc
        expDateLabel.text = coupon?.couponExp

    }
    
    // MARK: Methods
    
    func generateQRCodeFromString(string: String) -> UIImage? {
        let data = string.dataUsingEncoding(NSISOLatin1StringEncoding)
        
        if let filter = CIFilter(name: "CIQRCodeGenerator") {
            filter.setValue(data, forKey: "inputMessage")
            filter.setValue("H", forKey: "inputCorrectionLevel")
            let transform = CGAffineTransformMakeScale(10, 10)
            
            if let output = filter.outputImage?.imageByApplyingTransform(transform) {
                return UIImage(CIImage: output)
            }
        }
        
        return nil
    }
    

    @IBAction func onDoneButtonTapped(sender: AnyObject) {
        
        self.dismissViewControllerAnimated(true, completion: nil)
        
    }

}
