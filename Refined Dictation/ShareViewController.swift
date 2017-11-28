//
//  ShareViewController.swift
//  Refined Dictation
//
//  Created by Serran N on 11/27/17.
//  Copyright © 2017 Admin. All rights reserved.
//

import UIKit
import MessageUI

class ShareViewController: UIViewController, MFMessageComposeViewControllerDelegate, MFMailComposeViewControllerDelegate {
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
    
    @IBAction func ShareText(_ sender: Any) {
        let composeVC = MFMessageComposeViewController()
        composeVC.messageComposeDelegate = self
        
        if (!MFMessageComposeViewController.canSendText()) {
            print("SMS services are not available")
        }
        else{
            // Configure the fields of the interface.
            composeVC.recipients = ["4085551212"]
            composeVC.body = filtering?.filteredResult
            
            // Present the view controller modally.
            self.present(composeVC, animated: true, completion: nil)
        }
    }
    
    @IBAction func ShareMail(_ sender: Any) {
        if !MFMailComposeViewController.canSendMail(){
            print("Mail services are not available")
        }
        else{
            let composeVC = MFMailComposeViewController()
            composeVC.mailComposeDelegate = self
            
            // Configure the fields of the interface.
            composeVC.setToRecipients(["address@example.com"])
            composeVC.setSubject("ayy")
            composeVC.setMessageBody((filtering?.filteredResult)!, isHTML: false)
            
            // Present the view controller modally.
            self.present(composeVC, animated: true, completion: nil)
        }
    }
    
    //MARK: Delegates
    func messageComposeViewController(_ controller: MFMessageComposeViewController, didFinishWith result: MessageComposeResult) {
        // Check the result or perform other tasks.
        
        // Dismiss the message compose view controller.
        controller.dismiss(animated: true, completion: nil)
        
    }
    
    func mailComposeController(controller: MFMailComposeViewController, didFinishWithResult result: MFMailComposeResult, error: NSError?) {
        // Check the result or perform other tasks.
        
        // Dismiss the mail compose view controller.
        controller.dismiss(animated: true, completion: nil)
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
