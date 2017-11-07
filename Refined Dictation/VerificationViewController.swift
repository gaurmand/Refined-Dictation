//
//  VerificationViewController.swift
//  Refined Dictation
//
//  Created by Admin on 03/11/2017.
//  Copyright © 2017 Admin. All rights reserved.
//

import UIKit

class VerificationViewController: UIViewController, UITextViewDelegate {
    // var:
    var usr: User = User()
    var usrFilterLib: CommonFilter = CommonFilter()
    var recording: SpeechRecog = SpeechRecog()
    var filtering: SpeechFilter?
    var finalRes: FinalResult?
    
    @IBOutlet weak var DisplayFilteredTextField: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        DisplayFilteredTextField.delegate = self
        DisplayFilteredTextField.text = filtering!.filteredResult
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
    
//    @IBAction func seguetoVerfication(sender: UIStoryboardSegue) {
//        if (sender.identifier == "RecToVer"){
//            if let sourceViewController = sender.source as? RecordingViewController{
//                filtering = sourceViewController.filtering
//            }
//        }
//    }
 

}
