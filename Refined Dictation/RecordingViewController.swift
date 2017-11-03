//
//  RecordingViewController.swift
//  Refined Dictation
//
//  Created by Admin on 03/11/2017.
//  Copyright © 2017 Admin. All rights reserved.
//

import UIKit

class RecordingViewController: UIViewController {
    @IBOutlet weak var RecordingButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func ChangeRecordButtonImage(_ sender: Any) {
        let StopRecording = UIImage(named: "stop")
        RecordingButton.setImage(StopRecording, for: UIControlState.normal)
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
