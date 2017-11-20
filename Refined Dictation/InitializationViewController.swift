//
//  InitializationViewController.swift
//  Refined Dictation
//
//  Created by Serran N on 11/11/17.
//  Copyright © 2017 Admin. All rights reserved.
//

import UIKit

class InitializationViewController: UIViewController {
    
    //MARK: Properties
    var buttonState = "startRecButton"
    
    @IBOutlet weak var InstructionLabel: UILabel!
    @IBOutlet weak var PromptLabel: UILabel!
    @IBOutlet weak var RecordingButton: UIButton!
    @IBOutlet weak var CancelButton: UIBarButtonItem!
    @IBOutlet weak var DoneButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        DoneButton.isEnabled = false
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
            RecordingButton.setImage(UIImage(named: "stop"), for: UIControlState.normal)
            buttonState = "stopRecButton"
            DoneButton.isEnabled = false
            CancelButton.isEnabled = false
        }
        else{ //buttonState == "stopRecButton" -> stop recording button was pressed
            InstructionLabel.text = "Press done or tap the red button to redo your recording"
            RecordingButton.setImage(UIImage(named: "record"), for: UIControlState.normal)
            buttonState = "startRecButton"
            DoneButton.isEnabled = true
            CancelButton.isEnabled = true
        }
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
