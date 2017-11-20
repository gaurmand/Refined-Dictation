//
//  WelcomeViewController.swift
//  Refined Dictation
//
//  Created by Serran N on 11/11/17.
//  Copyright © 2017 Admin. All rights reserved.
//

import UIKit

class WelcomeViewController: UIViewController {
    
    //MARK: Properties
    var usr: appUser?
    var usrFilterLib: CommonFilter?
    var recording: SpeechRecog?
    var filtering: SpeechFilter?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.navigationController?.isNavigationBarHidden = true //hide navigation bar
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destinationViewController = segue.destination as? InitializationViewController {
            destinationViewController.filtering = filtering
            destinationViewController.recording = recording
            destinationViewController.usrFilterLib = usrFilterLib
            destinationViewController.usr = usr
        }
    }

}
