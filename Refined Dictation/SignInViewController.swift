//
//  SignInViewController.swift
//  Refined Dictation
//
//  Created by Serran N on 11/11/17.
//  Copyright © 2017 Admin. All rights reserved.
//

import UIKit

class SignInViewController: UIViewController, UITextFieldDelegate {
    
    //MARK: Properties
    @IBOutlet weak var ErrorLabel: UILabel!
    @IBOutlet weak var UsernameTextField: UITextField!
    @IBOutlet weak var PasswordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        UsernameTextField.delegate = self
        PasswordTextField.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(false)
        ErrorLabel.text = "" //no error, so error label is empty
        self.navigationController?.setNavigationBarHidden(false, animated: true)    //shows navigation bar
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: Actions
    @IBAction func SignInButton(_ sender: Any) {
        if SignIn(){
            performSegue(withIdentifier: "signin", sender: Any)
        }
        else{
            ErrorLabel.text = "Incorrect username or password"
        }
    }
    
    //MARK: UITextFieldDelegate
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        // Hide the keyboard when user presses return
        textField.resignFirstResponder()
        return true
    }
    
    //MARK: Private Methods
    private func SignIn() ->Bool{
        return true
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
