//
//  RecordingViewController.swift
//  Refined Dictation
//
//  Created by Admin on 03/11/2017.
//  Copyright © 2017 Admin. All rights reserved.
//

import UIKit

class RecordingViewController: UIViewController, UITextFieldDelegate {
    // vars:
    var usr: User = User()
    var usrFilterLib: CommonFilter = CommonFilter()
    var recording: SpeechRecog = SpeechRecog()
    var filtering: SpeechFilter = SpeechFilter()

    
    @IBOutlet weak var RecordingButton: UIButton!
    @IBOutlet weak var SearchField: UITextField!
    @IBOutlet weak var InstructionLabel: UILabel!
    @IBOutlet weak var DoneButton: UIBarButtonItem!
    var stopButton = false  //record button can be stop or start (true if stop, false if start)

    override func viewDidLoad() {
        super.viewDidLoad()
        SearchField.delegate = self //sets search field delegate
        DoneButton.isEnabled = false  //disables done button
        // Do any additional setup after loading the view.
        
        // TODO: pass in a proper user
        usrFilterLib = CommonFilter(usr: usr)
        recording = SpeechRecog(usr: usr)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        InstructionLabel.text = "Tap the red button below to start recording your voice"
        DoneButton.isEnabled = false
    }
    
    //MARK: UITextFieldDelegate
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        // Hide the keyboard when user presses return
        textField.resignFirstResponder()
        return true
    }
    
    
    //MARK: Actions
    // TODO: take the user to VerificationViewController upon the second press of record button
    @IBAction func RecordButtonPressed(_ sender: UIButton) {
        if(stopButton){ //changes stop record button to start record and segues to next view
            stopButton = false
            let StartRecording = UIImage(named: "record")
            RecordingButton.setImage(StartRecording, for: UIControlState.normal)
            InstructionLabel.text = "Press done or tap the red button to redo your recording"
            recording.recStop()
            #if DEBUG
                print(recording.rawResult)
            #endif
            // begin filtering
            filtering = SpeechFilter(usr: usr, rawResult: recording.rawResult, filterLib: usrFilterLib )
            #if DEBUG
                print(filtering.filteredResult)
            #endif
            DoneButton.isEnabled = true
            
        }
        else{   //changes start record button to stop record button
            stopButton = true
            let StopRecording = UIImage(named: "stop")
            RecordingButton.setImage(StopRecording, for: UIControlState.normal)
            InstructionLabel.text = "Tap the button again to stop recording"
            DoneButton.isEnabled = false
            recording.recBegin()
        }

    }
    
    // MARK: - Navigation
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    @IBAction func unwindToRecordingView(sender: UIStoryboardSegue) {
        
    }
    
//    func prepare(segue: UIStoryboardSegue, sender: AnyObject?) {
//        if segue.identifier == "MySegueID" {
//            if let destination = segue.destination as? VerificationViewController {
//                destination.usr = self.usr
//                destination.usrFilterLib = self.usrFilterLib
//                destination.recording = self.recording
//                destination.filtering.filteredResult = "hello"
//            }
//        }
//    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
       // let data = Data()
        if let destinationViewController = segue.destination as? VerificationViewController {
            destinationViewController.filtering = filtering
        }
    }
}
