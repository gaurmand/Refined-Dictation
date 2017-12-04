
//
//  RecordingViewController.swift
//  Refined Dictation
//
//  Created by Admin on 03/11/2017.
//  Copyright © 2017 Admin. All rights reserved.
//

import UIKit
import FirebaseAuth

class RecordingViewController: UIViewController {
    
    //MARK: Properties
    var recording: SpeechRecog?
    var filtering: SpeechFilter?
    var buttonState = "startRecButton"

    @IBOutlet weak var RecordingButton: UIButton!
    @IBOutlet weak var InstructionLabel: UILabel!
    @IBOutlet weak var DoneButton: UIBarButtonItem!
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        DoneButton.isEnabled = false  //disables done button
        
        // pass in a proper values
        recording = SpeechRecog()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.navigationController?.setNavigationBarHidden(false, animated: true)    //shows navigation bar
        self.navigationController?.navigationBar.topItem?.setHidesBackButton(true, animated: false) //hides back button
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        InstructionLabel.text = "Tap the red button below to start recording your voice"
        DoneButton.isEnabled = false
    }
    
    //MARK: Actions
    // TODO: take the user to VerificationViewController upon the second press of record button
    @IBAction func RecordButtonPressed(_ sender: UIButton) {
        if(buttonState == "startRecButton"){ //start recording button was pressed
            InstructionLabel.text = "Tap the button again to stop recording"
            recording?.recBegin()
            RecordingButton.setImage(UIImage(named: "stop"), for: UIControlState.normal)
            buttonState = "stopRecButton"
            DoneButton.isEnabled = false
            
//            // DEBUG: TEST
//            let a = FinalResult(raw: "String", filtered: "filteredString", edited: "EditedString", STTT: 0.1111, filterT: 0.2222)
//            a.insertDictationToFIR()
        }
        else{ //buttonState == "stopRecButton" -> stop recording button was pressed
            InstructionLabel.text = "..."
            recording?.recStop()
            
            filtering = SpeechFilter(recording!.rawResult) // begin filtering
            
            InstructionLabel.text = "Press done or tap the red button to redo your recording"
            RecordingButton.setImage(UIImage(named: "record"), for: UIControlState.normal)
            buttonState = "startRecButton"
            DoneButton.isEnabled = true
        }
    }
    
    // MARK: Navigation
    @IBAction func unwindToRecordingView(sender: UIStoryboardSegue) {
        if let sourceViewController = sender.source as? VerificationViewController {
            
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destinationViewController = segue.destination as? VerificationViewController {
            destinationViewController.finalRes = FinalResult(raw: (filtering?.rawResult)!, filtered: filtering?.filteredResult, edited: nil, STTT: (recording?.recordTime)!, filterT: (filtering?.filterTime)!)
            destinationViewController.filtering = filtering
        }
        else if let destinationViewController = segue.destination as? FavouriteTableViewController {
            destinationViewController.filtering = filtering
        }
        else if let destinationViewController = segue.destination as? HistoryTableViewController {
            destinationViewController.filtering = filtering
        }
    }
}
