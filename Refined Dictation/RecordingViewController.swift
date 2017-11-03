//
//  RecordingViewController.swift
//  Refined Dictation
//
//  Created by Admin on 03/11/2017.
//  Copyright © 2017 Admin. All rights reserved.
//

import UIKit

class RecordingViewController: UIViewController, UITextFieldDelegate {
    @IBOutlet weak var RecordingButton: UIButton!
    @IBOutlet weak var SearchField: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()
        SearchField.delegate = self //sets search field delegate
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    


    
    // MARK: - Navigation
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    @IBAction func unwindToRecordingView(sender: UIStoryboardSegue) {
        
    }
    
    //MARK: UITextFieldDelegate
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        // Hide the keyboard when user presses return
        textField.resignFirstResponder()
        return true
    }
    
    
    //MARK: Actions
    
    @IBAction func ChangeRecordButtonImage(_ sender: Any) {
        let StopRecording = UIImage(named: "stop")
        RecordingButton.setImage(StopRecording, for: UIControlState.normal)
    }
 

}
