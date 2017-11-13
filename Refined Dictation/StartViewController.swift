//
//  StartViewController.swift
//  Refined Dictation
//
//  Created by Admin on 30/10/2017.
//  Copyright © 2017 Admin. All rights reserved.
//

import UIKit

class StartViewController: UIViewController {
    
    //MARK: Properties
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
    
    //MARK: Actions
    @IBAction func SkipButton(_ sender: UIButton) {
        //UserDefaults.standard.removeObject(forKey: "IsNotFirstLaunch")  //always goes to welcome/initialization
        //UserDefaults.standard.set(true, forKey: "IsNotFirstLaunch")  //always goes to recording screen
        if (UserDefaults.standard.bool(forKey: "IsNotFirstLaunch")){
            performSegue(withIdentifier: "skip2", sender: Any?) // If not first launch go straight to record screen
        }
        else{
            performSegue(withIdentifier: "skip1", sender: Any?) // If first launch go to welcome and initialization screen
        }
    }
    
    //MARK: Navigation
    @IBAction func unwindToStartView(sender: UIStoryboardSegue) {}
}

