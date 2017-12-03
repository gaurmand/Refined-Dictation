//
//  InitializationViewController.swift
//  Refined Dictation
//
//  Created by Serran N on 11/11/17.
//  Copyright © 2017 Admin. All rights reserved.
//

import UIKit
import FirebaseAuth

class InitializationViewController: UIViewController {
    
    //MARK: Properties
    var recording: SpeechRecog?
    var filtering: SpeechFilter?
    var buttonState = "startRecButton"
    
    @IBOutlet weak var InstructionLabel: UILabel!
    @IBOutlet weak var PromptLabel: UILabel!
    @IBOutlet weak var RecordingButton: UIButton!
    @IBOutlet weak var DoneButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        DoneButton.isEnabled = false
        
        // pass in a proper values
        recording = SpeechRecog()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.navigationController?.setNavigationBarHidden(false, animated: true)    //shows navigation bar
        self.navigationController?.navigationBar.topItem?.setHidesBackButton(true, animated: false) //hides back button
    }

    //MARK: Actions
    @IBAction func SetIsNotFirstLaunchFlag(_ sender: UIBarButtonItem) {
        UserDefaults.standard.set(true, forKey: "IsNotFirstLaunch") // If done button is pressed, set IsNotFirstLaunch flag to true
        performSegue(withIdentifier: "init", sender: Any?)
    }
    
    @IBAction func RecordButtonPressed(_ sender: UIButton) {
        if(buttonState == "startRecButton"){ //start recording button was pressed
            InstructionLabel.text = "Tap the button again to stop recording"
            recording?.recBegin()
            RecordingButton.setImage(UIImage(named: "stop"), for: UIControlState.normal)
            buttonState = "stopRecButton"
            
            DoneButton.isEnabled = false
        }
        else{ //buttonState == "stopRecButton" -> stop recording button was pressed
            InstructionLabel.text = "..."
            recording?.recStop()
            
            if(updateUsrFilterLib(rawstring: (recording?.rawResult)!)){
                InstructionLabel.text = "Press done or tap the red button to redo your recording"
                DoneButton.isEnabled = true
            }
            else{
                InstructionLabel.text = "Your speech was not recognized, please tap the red button to redo your recording"
                DoneButton.isEnabled = false
            }
            
            RecordingButton.setImage(UIImage(named: "record"), for: UIControlState.normal)
            buttonState = "startRecButton"
        }
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destinationViewController = segue.destination as? RecordingViewController {
            destinationViewController.filtering = filtering
            destinationViewController.recording = recording
        }
    }
    
    //MARK: Private Methods
    
    private func updateUsrFilterLib(rawstring: String) -> Bool{
        let rawStrArr = rawstring.components(separatedBy: " ")
        var promptStrArr = ["rainy", "weather", "is", "the", "worst"]   //Array of words in the onscreen prompt
        var StrArr = [String]()
        
        for word in rawStrArr{  //removes empty strings from array
            if(word != ""){
                StrArr.append(word)
            }
        }
        
        if(StrArr.count < promptStrArr.count){  //# words spoken is less than the # words in prompt
            return false
        }
        if(!StrArr.contains(promptStrArr[0])){  //The first word in prompt is not in the array of spoken words
            return false
        }

 
        for index in 0...(StrArr.count - 1){    //finds tics by comparing prompt to the spoken sentence and adds them to userFilterLib
            if(index > promptStrArr.count - 1 ){
                CommonFilter.added(StrArr[index])
                continue
            }
            if(StrArr[index] != promptStrArr[index]){
                promptStrArr.insert("", at: index)
                CommonFilter.added(StrArr[index])
            }
        }
        
        
        
        return true
    }
}
