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
    var usr: appUser?
    var usrFilterLib: CommonFilter?
    var recording: SpeechRecog?
    var filtering: SpeechFilter?
    var buttonState = "startRecButton"
    
    @IBOutlet weak var InstructionLabel: UILabel!
    @IBOutlet weak var PromptLabel: UILabel!
    @IBOutlet weak var RecordingButton: UIButton!
    @IBOutlet weak var SignOutButton: UIBarButtonItem!
    @IBOutlet weak var DoneButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        DoneButton.isEnabled = false
        
        // pass in a proper values
        usr = appUser(FirBUser: Auth.auth().currentUser!)
        usrFilterLib = CommonFilter(usr: usr!)
        recording = SpeechRecog(usr: usr!)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.navigationController?.setNavigationBarHidden(false, animated: true)    //shows navigation bar
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
            SignOutButton.isEnabled = false
        }
        else{ //buttonState == "stopRecButton" -> stop recording button was pressed
            InstructionLabel.text = "..."
            recording?.recStop()
            
            #if DEBUG
                print("raw:" + (recording?.rawResult)!)
            #endif
            
            //usrFilterLib = CommonFilter(usr: usr!) //resets filter words library
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
            SignOutButton.isEnabled = true
        }
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destinationViewController = segue.destination as? RecordingViewController {
            destinationViewController.filtering = filtering
            destinationViewController.recording = recording
            destinationViewController.usrFilterLib = usrFilterLib
            destinationViewController.usr = usr
        }
    }
    
    //MARK: Private Methods
    
    private func updateUsrFilterLib(rawstring: String) -> Bool{
        var rawStrArr = rawstring.components(separatedBy: " ")
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
                usrFilterLib?.addToList(word: StrArr[index])
                continue
            }
            if(StrArr[index] != promptStrArr[index]){
                promptStrArr.insert("", at: index)
                usrFilterLib?.addToList(word: StrArr[index])
            }
        }
        
        
        
        return true
    }
}
