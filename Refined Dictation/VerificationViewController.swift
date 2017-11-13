//
//  VerificationViewController.swift
//  Refined Dictation
//
//  Created by Admin on 03/11/2017.
//  Copyright © 2017 Admin. All rights reserved.
//

import UIKit

class VerificationViewController: UIViewController, UITextViewDelegate {
    // Properties
    var usr: User = User()
    var usrFilterLib: CommonFilter = CommonFilter()
    var recording: SpeechRecog = SpeechRecog()
    var filtering: SpeechFilter?
    var finalRes: FinalResult?
    
    @IBOutlet weak var DisplayFilteredTextField: UITextView!
    @IBOutlet weak var Outline: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        DisplayFilteredTextField.delegate = self
        //DisplayFilteredTextField.keyboardDismissMode = UIScrollViewKeyboardDismissMode.onDrag
        DisplayFilteredTextField.text = filtering?.filteredResult
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: UITextViewDelegate
    func textViewDidBeginEditing(_ textView: UITextView){
        DisplayFilteredTextField.frame.size.height = 250
        Outline.frame.size.height = 254
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        DisplayFilteredTextField.frame.size.height = 445
        Outline.frame.size.height = 449
    }
    func textViewDidChange(_ textView: UITextView) {
        if (DisplayFilteredTextField.text.hasSuffix("\n")){             //If user hits return, dismiss keyboard
            DisplayFilteredTextField.text.removeLast()
            DisplayFilteredTextField.resignFirstResponder()
        }
    }
 
    // MARK: Navigation
     @IBAction func unwindToVerificationView(sender: UIStoryboardSegue) {}
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        DisplayFilteredTextField.resignFirstResponder() //Dismiss keyboard before segueing
    }
 

}
