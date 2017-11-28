//
//  ShareViewController.swift
//  Refined Dictation
//
//  Created by Serran N on 11/27/17.
//  Copyright © 2017 Admin. All rights reserved.
//

import UIKit

class ShareViewController: UIViewController {
    // Properties
    var usrFilterLib: CommonFilter?
    var recording: SpeechRecog?
    var filtering: SpeechFilter?
    var finalRes: FinalResult?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //Mark: Actions
    @IBAction func ShareTwitter(_ sender: Any) {
        let composer = TWTRComposer()
        
        composer.setText("just setting up my Twitter Kit")
        //composer.setImage(UIImage(named: "twitterkit"))
        
        // Called from a UIViewController
        composer.show(from: self.navigationController!){ (result) in
            if (result == .done) {
            print("Successfully composed Tweet")
            } else {
            print("Cancelled composing")
            }
        }
    }

    @IBAction func ShareClipboard(_ sender: Any) {
        UIPasteboard.general.string = filtering?.filteredResult
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
