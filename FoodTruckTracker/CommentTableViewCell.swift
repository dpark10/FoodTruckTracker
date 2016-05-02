//
//  CommentTableViewCell.swift
//  FoodTruckTracker
//
//  Created by Dylan Bruschi on 5/1/16.
//  Copyright © 2016 Dan Park. All rights reserved.
//

import UIKit
import Cosmos

class CommentTableViewCell: UITableViewCell, UITextViewDelegate{
    
    @IBOutlet weak var commentTextView: UITextView!
    
    @IBOutlet weak var ratingView: CosmosView!
    
    var foodTruck: FoodTruck?
    var comments: Dictionary<String, Double>?
    
    
    override func awakeFromNib() {
        commentTextView.delegate = self
        commentTextView.layer.borderWidth = 1
        commentTextView.layer.borderColor = UIColor.redColor().CGColor

    }
    
    func textViewDidChange(textView: UITextView) {
        print(commentTextView.text)
    
    }
    
    func textView(textView: UITextView, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool {
        if (text == "\n") {
            let ref = DataService.dataService.REF_BASE.childByAppendingPath("foodTrucks").childByAppendingPath(foodTruck?.uid)
            comments![commentTextView.text] = ratingView.rating
            let newComments = ["comments": comments as! NSDictionary]
            ref.updateChildValues(newComments)
            
            textView.resignFirstResponder()
        }
        return true
    }
    

}
