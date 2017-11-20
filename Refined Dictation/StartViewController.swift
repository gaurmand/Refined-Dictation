//
//  StartViewController.swift
//  Refined Dictation
//
//  Created by Admin on 30/10/2017.
//  Copyright © 2017 Admin. All rights reserved.
// Modified based on: https://github.com/udacity/ios-nd-firebase

import UIKit
import Firebase
import FirebaseAuth
import FirebaseAuthUI
import FirebaseGoogleAuthUI
import FirebaseFacebookAuthUI

// global variable to record if the user performed a signed in in this launch of Refined Dictation
var DIDSIGNIN: Bool = false

class StartViewController: UIViewController {
    // MARK: Properties
    
    var ref: DatabaseReference!
//  var messages: [DataSnapshot]! = []
    fileprivate var _refHandle: DatabaseHandle!
    fileprivate var _authHandle: AuthStateDidChangeListenerHandle!
    var user: User?
    var displayName = "Anonymous"
    
    var usr: appUser = appUser()
    var usrFilterLib: CommonFilter = CommonFilter()
    var recording: SpeechRecog = SpeechRecog()
    var filtering: SpeechFilter = SpeechFilter()
    var unwindFlag = false //true if
    
    // MARK: Life Cycle
    
    override func viewDidLoad() {
        configureAuth()

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.navigationController?.isNavigationBarHidden = true
        
        if(unwindFlag){//sign in
            self.signedInStatus(isSignedIn: false)
            self.loginSession()
        }
        
        UserDefaults.standard.removeObject(forKey: "IsNotFirstLaunch")  //always goes to welcome/initialization
        //UserDefaults.standard.set(true, forKey: "IsNotFirstLaunch")  //always goes to recording screen
        if (UserDefaults.standard.bool(forKey: "IsNotFirstLaunch")){
            performSegue(withIdentifier: "skip2", sender: Any?) // If not first launch go straight to record screen
        }
        else{
            performSegue(withIdentifier: "skip1", sender: Any?) // If first launch go to welcome and initialization screen
        }

    }
    
//    override func viewWillDisappear(_ animated: Bool) {
//        super.viewWillDisappear(animated)
//    }
    
    // MARK: Config
    
    func configureAuth() {
        let provider: [FUIAuthProvider] = [FUIGoogleAuth(), FUIFacebookAuth()]

        FUIAuth.defaultAuthUI()?.providers = provider
//        FUIAuth.defaultAuthUI()?.delegate = self as! FUIAuthDelegate

        
        // listen for changes in the authorization state
        _authHandle = Auth.auth().addStateDidChangeListener { (auth: Auth, user: User?) in            
            // check if there is a current user
            if let activeUser = user {
                // check if the current app user is the current FIRUser
                if self.user != activeUser {
                    self.user = activeUser
                    self.signedInStatus(isSignedIn: true)
                    let name = user!.email!.components(separatedBy: "@")[0]
                    self.displayName = name
                }
            } else {
                // user must sign in
                self.signedInStatus(isSignedIn: false)
                self.loginSession()
            }
        }
    }
    
    func configureDatabase() {
        ref = Database.database().reference()
        // VER3: retrieve search and favourite list
//        // listen for new messages in the firebase database
//        _refHandle = ref.child("messages").observe(.childAdded) { (snapshot: DataSnapshot)in
//            self.messages.append(snapshot)
//            self.messagesTable.insertRows(at: [IndexPath(row: self.messages.count-1, section: 0)], with: .automatic)
//        }
    }
    
    deinit {
        ref.child("messages").removeObserver(withHandle: _refHandle)
        Auth.auth().removeStateDidChangeListener(_authHandle)
    }
    
    
    // MARK: Sign In and Out
    
    func signedInStatus(isSignedIn: Bool) {
//        signInButton.isHidden = isSignedIn
//        signOutButton.isHidden = !isSignedIn
        // jump to home view controller
        
        if isSignedIn {
            configureDatabase()
        }
    }
    
    func loginSession() {
        let myCustomerViewController = customAuthUIViewController(authUI: FUIAuth.defaultAuthUI()!)
        let navController = UINavigationController(rootViewController: myCustomerViewController)
        navController.title = "Welcome to Refined Dictation"
        self.present(navController, animated: false, completion: nil)

    }


//// Writing to database
//        mdata[Constants.MessageFields.name] = displayName
//        ref.child("messages").childByAutoId().setValue(mdata)
    
    
    //MARK: Navigation

    @IBAction func unwindToStartView(sender: UIStoryboardSegue) {
        do {    //sign out
            try Auth.auth().signOut()
        } catch {
            print("unable to sign out: \(error)")
        }
        unwindFlag = true
    }
    
    @IBAction func showLoginView(_ sender: AnyObject) {
        loginSession()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destinationViewController = segue.destination as? WelcomeViewController {
            destinationViewController.filtering = filtering
            destinationViewController.recording = recording
            destinationViewController.usrFilterLib = usrFilterLib
            destinationViewController.usr = usr
        }
        else  if let destinationViewController = segue.destination as? RecordingViewController {
            destinationViewController.filtering = filtering
            destinationViewController.recording = recording
            destinationViewController.usrFilterLib = usrFilterLib
            destinationViewController.usr = usr
        }
    }

}


class customAuthUIViewController: FUIAuthPickerViewController {

    override init(nibName: String?, bundle: Bundle?, authUI: FUIAuth) {
        super.init(nibName: "FUIAuthPickerViewController", bundle: bundle, authUI: authUI)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // attach background
        let width = UIScreen.main.bounds.size.width
        let height = UIScreen.main.bounds.size.height
        let imageViewBackground = UIImageView(frame: CGRect(x: 0, y: 0, width: width, height: height))
        imageViewBackground.image = UIImage(named: "background")
        imageViewBackground.contentMode = UIViewContentMode.scaleAspectFill
        view.insertSubview(imageViewBackground, at: 0)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(false)
        self.navigationController?.isNavigationBarHidden = true //hide navigation bar
    }
    
    
}
//
//// MARK: - FCViewController: UITableViewDelegate, UITableViewDataSource
//// To be modified to enable search/favourite in VER3
//extension FCViewController: UITableViewDelegate, UITableViewDataSource {
//
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return messages.count
//    }
//
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        // dequeue cell
//        let cell: UITableViewCell! = messagesTable.dequeueReusableCell(withIdentifier: "messageCell", for: indexPath)
//        // unpack message from firebase data snapshot
//        let messageSnapshot = messages[indexPath.row]
//        let message = messageSnapshot.value as! [String: String]
//        let name = message[Constants.MessageFields.name] ?? "[username]"
//        // if image message, then grab image and display it
//        if let imageUrl = message[Constants.MessageFields.imageUrl] {
//            cell!.textLabel?.text = "sent by: \(name)"
//            // image already exists in cache
//            if let cachedImage = imageCache.object(forKey: imageUrl as NSString) {
//                cell.imageView?.image = cachedImage
//                cell.setNeedsLayout()
//            } else {
//                // download image
//                Storage.storage().reference(forURL: imageUrl).getData(maxSize: INT64_MAX, completion: { (data, error) in
//                    guard error == nil else {
//                        print("Error downloading: \(error!)")
//                        return
//                    }
//                    let messageImage = UIImage.init(data: data!, scale: 50)
//                    self.imageCache.setObject(messageImage!, forKey: imageUrl as NSString as NSString)
//                    // check if the cell is still on screen, if so, update cell image
//                    if cell == tableView.cellForRow(at: indexPath) {
//                        DispatchQueue.main.async {
//                            cell.imageView?.image = messageImage
//                            cell.setNeedsLayout()
//                        }
//                    }
//                })
//            }
//        } else {
//            // otherwise, update cell for regular message
//            let text = message[Constants.MessageFields.text] ?? "[message]"
//            cell!.textLabel?.text = name + ": " + text
//            cell!.imageView?.image = placeholderImage
//        }
//        return cell!
//    }
//
//    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
//        return UITableViewAutomaticDimension
//    }
//
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        // skip if keyboard is shown
//        guard !messageTextField.isFirstResponder else { return }
//        // unpack message from firebase data snapshot
//        let messageSnapshot: DataSnapshot! = messages[(indexPath as NSIndexPath).row]
//        let message = messageSnapshot.value as! [String: String]
//        // if tapped row with image message, then display image
//        if let imageUrl = message[Constants.MessageFields.imageUrl] {
//            if let cachedImage = imageCache.object(forKey: imageUrl as NSString) {
//                showImageDisplay(cachedImage)
//            } else {
//                Storage.storage().reference(forURL: imageUrl).getData(maxSize: INT64_MAX, completion: { (data, error) in
//                    guard error == nil else {
//                        print("Error downloading: \(error!)")
//                        return
//                    }
//                    self.showImageDisplay(UIImage.init(data: data!)!)
//                })
//            }
//        }
//    }
//
//}
 
