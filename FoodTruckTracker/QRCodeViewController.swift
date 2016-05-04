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
    
    let couponCode = "coupon code"
    
    // MARK: View Management
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let image = self.generateQRCodeFromString(couponCode)
        qrCodeImage.image = image

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
