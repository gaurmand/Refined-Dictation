
//
//  RecordingViewController.swift
//  Refined Dictation
//
//  Created by Admin on 03/11/2017.
//  Copyright © 2017 Admin. All rights reserved.
//

import UIKit
import FirebaseAuth

class RecordingViewController: UIViewController, UITextFieldDelegate {
    
    //MARK: Properties
    var recording: SpeechRecog = SpeechRecog()
    var filtering: SpeechFilter = SpeechFilter()
    var buttonState = "startRecButton"

    @IBOutlet weak var SignOutButton: UIBarButtonItem!
    @IBOutlet weak var RecordingButton: UIButton!
    @IBOutlet weak var SearchField: UITextField!
    @IBOutlet weak var InstructionLabel: UILabel!
    @IBOutlet weak var DoneButton: UIBarButtonItem!

    override func viewDidLoad() {
        super.viewDidLoad()
        SearchField.delegate = self //sets search field delegate
        DoneButton.isEnabled = false  //disables done button
        
        // TODO: pass in a proper user
        recording = SpeechRecog()
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
        if(buttonState == "startRecButton"){ //start recording button was pressed
            InstructionLabel.text = "Tap the button again to stop recording"
            recording.recBegin()
            RecordingButton.setImage(UIImage(named: "stop"), for: UIControlState.normal)
            buttonState = "stopRecButton"
            DoneButton.isEnabled = false
            SignOutButton.isEnabled = false
        }
        else{ //buttonState == "stopRecButton" -> stop recording button was pressed
            InstructionLabel.text = "..."
            recording.recStop()
            
            #if DEBUG
                print("raw: " + recording.rawResult)
            #endif
            filtering = SpeechFilter(rawResult: recording.rawResult) // begin filtering
            #if DEBUG
                print("filtered: " + filtering.filteredResult)
            #endif
            
            InstructionLabel.text = "Press done or tap the red button to redo your recording"
            RecordingButton.setImage(UIImage(named: "record"), for: UIControlState.normal)
            buttonState = "startRecButton"
            DoneButton.isEnabled = true
            SignOutButton.isEnabled = true
        }
    }
    
    // MARK: Navigation
    @IBAction func unwindToRecordingView(sender: UIStoryboardSegue) {}
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destinationViewController = segue.destination as? VerificationViewController {
            destinationViewController.filtering = filtering
        }
    }
}
