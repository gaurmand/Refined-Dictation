//
//  VerificationViewController.swift
//  Refined Dictation
//
//  Created by Admin on 03/11/2017.
//  Copyright © 2017 Admin. All rights reserved.
//

import UIKit

class VerificationViewController: UIViewController, UITextViewDelegate {
    @IBOutlet weak var DisplayFilteredTextField: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        DisplayFilteredTextField.delegate = self
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: UITextViewDelegate
    func textViewDidBeginEditing(_ textView: UITextView){
        //let numLines = DisplayFilteredTextField.text.count
        //let lastline: NSRange = NSMakeRange(numLines+15,1)
        //DisplayFilteredTextField.scrollRangeToVisible(lastline)
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
     @IBAction func unwindToVerificationView(sender: UIStoryboardSegue) {
     
     }
 

}
