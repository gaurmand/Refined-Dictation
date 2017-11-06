//
//  dataObjs.swift
//  cmpt275_team1
//
//  Created by Shawn Wang on 2017-11-02.
//  Copyright © 2017 cmpt275. All rights reserved.
//

import Foundation
//import Alamofire    // HTTP requests  // handled by Watson SDK
import SpeechToTextV1

let EXCLUDE_MOST_COMMON_WORD_COUNT = 200    // used in CommonFilter() class


// Pre-processors are not allowed in Swift.
// Instead, MACROs are now defined in project -> Build Setting -> Swift Compiler - Custom Flags -> Active Compilation Conditions
// This project uses:
//#define VER1      // Things to be taken out later on. DO NOT REMOVE FLAG UPON RELEASE
//#define VER2      // Things to do later on. AKA, 'TODO's
//#define DEBUG
// make sure DEBUG and VER2 are both turned off upon VER1 release

// TODO: Ver. 1 will not implement custom profile. Hardcoded for now w
// MARK: handles the management of a per-user custom profile
// constructed upon launch
class User{
    // properties:
    var name: String
    var usrID: Int
    var WatsonID: String
    var WatsonPsswrd: String
    
    // default constructor:
    // TODO: if(existing user): retrieve credentials using keychain; if(newUser): call newUserProfile()
    init(keychainCred: KeychainWrapper? = nil){
        // TODO: Getting user info from server is not supported in Ver. 1
        // Sample info are hardcoded for now
        #if VER2
            getUsrInfo(KeychainWrapper)
        #endif
        #if VER1
        name = "Alice"
        usrID=0
        WatsonID = "70c6c385-6d1f-4cd1-9239-eaf59fc38a08"
        WatsonPsswrd = "Ph70dloSxwhe"
        #endif
    }
    
    // cpy constructor:
    init(usr: User){
        self.name = usr.name
        self.usrID = usr.usrID
        self.WatsonID = usr.WatsonID
        self.WatsonPsswrd = usr.WatsonPsswrd
    }
    
    #if VER2
    // used to retrieve user info to populate User class from server
    internal func getUsrInfo(){
        
    }
    
    // MARK: Assigns a new user a profile including: WatsonCredentials, userID, and name (retrieved from fb/google or asked)
    // then store new User profile to server and keychain
    open func newUserProfile(){
    
    }
    #endif
    
}


// MARK: per-user data structure used to manage words that we would like to filter
// constructed upon launch
/*: Dictionary contains the words that the user has historically edited out from STT result that are NOT in the to EXCLUDE_MOST_COMMON_WORD_COUNT of the most spoken words list:
 http://www.talkenglish.com/vocabulary/top-2000-vocabulary.aspx
 - Should be an efficient Dictionary data structure with:
 word string as key
 bool as value To support turning off the keyword without deleting from table.
 */
class CommonFilter: User{
    // properties (data structure lives here):
    // 1. Dictionary with top EXCLUDE_MOST_COMMON_WORD_COUNT words dictionary
    // 2. Dictionary with user's custom filtering words
    
    //creates empty dictionaries
    var ExcludedCommonWords = ["":false]
    var UserFilterWords = ["":false]
    
    // constructor:
    override init(usr: User){
        super.init(usr: usr)
        #if VER2
            importList()
        #endif
        #if VER1
            // Load dictionary 1 from file
            // create empty dictionary 2. (maybe load in a couple of tic-looking words for demo)
            
            let file = "ExcludedCommonWordsList"
            
            //Get contents of file into one string
            let ExcludedWordsString = readFromFile(filename:file)
            
            //ExcludedWordsString is subdivided into one word strings and placed into an array
            let ExcludedWordsArr = ExcludedWordsString.components(separatedBy: "\n")
            
            //Add each string in ExcludedWordsArr to the ExcludedCommonWords dictionary
            for ExcludedWord in ExcludedWordsArr{
                ExcludedCommonWords[ExcludedWord] = true
            }
        #endif
    }
    
    // funcs:
    // MARK: If its not the top EXCLUDE_MOST_COMMON_WORD_COUNT words on the most spoken list, add to dictionary.
    // Return true if succeeded or already in the list
    // Return false if failed
    open func addToList(word: String) -> Bool {
        if(ExcludedCommonWords[word] != nil && ExcludedCommonWords[word]!){
            return false
        }
        else{
            UserFilterWords[word] = true
            return true
        }
    }
    
    // MARK: Remove the word from List
    // Return true if succeeded or does not exist in list
    // Return false if failed
    open func rmFromList(word: String) -> Bool {
        if(UserFilterWords[word] != nil && UserFilterWords[word]!){
            UserFilterWords[word] = false
        }
        return true
    }
    
    // MARK: Check if the word is in the current list.
    // Return true if in list
    // Return false if not in list
    open func isOnList(word: String) -> Bool {
        if(UserFilterWords[word] != nil && UserFilterWords[word]!){
            return true
        }
        return false;
    }
    
    private func readFromFile(filename: String) -> String{
        // File location
        let fileURL = Bundle.main.path(forResource: filename, ofType: "txt")
        
        // Read from the file
        var readString = ""
        do {
            readString = try String(contentsOfFile: fileURL!, encoding: String.Encoding.utf8)
        } catch let error as NSError {
            print("Failed reading from URL:")
        }
        return readString
    }
    
    #if VER2
    // Instantiate the dictionary from locally stored database, or if there isn't one existing, request from server
    private func importList(){
    
    }
    // Deconstructor, called upon exiting app
    // Should sync any updates to the table to the Server and/or local stored file
    deinit{
    
    }
    #endif
}

// MARK: per-dictation class used to call Watson STT API and handle data
// instantiated on scenes with the red recording button
class SpeechRecog: User{
    // properties:
    #if DEBUG
    var speechPath = ""
    #endif
    var speechToText: SpeechToText
    var rawResult = ""
    var time = 0.0
    
    
    // constructor:
    override init(usr: User){
        // Watson supplied test speech recording
        #if DEBUG
        let fileURL=Bundle.main.bundleURL.appendingPathComponent("audio-file.flac")
        self.speechPath = fileURL.path
        #endif
        
        // Init STT API
        speechToText = SpeechToText(username: usr.WatsonID, password: usr.WatsonPsswrd)
        
        super.init(usr: usr)
    }
    
    
    // funcs:
    // called when red recording button is tapped
    // Result string will be returned piece-by-piece, and appended to self.result
    // feel free to modify the func to support printing to screen as result comes in
    // Otherwise call retrieve from self.rawResult
    open func recBegin(){
        var settings = RecognitionSettings(contentType: .oggOpus)
        settings.interimResults = true      // send piece-wise voice for processing ASAP
        let failure = { (error: Error) in print(error) }
        self.speechToText.recognizeMicrophone(settings: settings, failure: failure) { results in
            #if DEBUG
            // piece-wise result
            print(results.bestTranscript)
            #endif
            self.rawResult += results.bestTranscript
        }
        
    }
    
    // called when red recording button is tapped again
    open func recStop(usrProfile: User){
        self.speechToText.stopRecognizeMicrophone()
        
        // Unable to get Alamofire HTTP call to work
        //        let headers: HTTPHeaders = [
        //            "Content-Type": "audio/flac",
        //            "Transfer-Encoding": "chunked"
        //        ]
        //        Alamofire.upload(MultipartFormData:{multipartFormData in
        //            multipartFormData.append(self.speechPath, withName: "sample_speech")}, usingThreshold: UInt64, to: "https://stream.watsonplatform.net/speech-to-text/api/v1/recognize", method: .post, headers: headers, encodingCompletion: {
        //                encodingResult in
        //                switch encodingResult{
        //                case .success(let upload,_,_):
        //                    upload.responseJSON{response in
        //                        debugPrint(response)
        //                    }
        //                case .failure(let encodingError):
        //                    print(encodingError)
        //                }
        //
        //
        //        })
        //
        //
        //
        //            .authenticate(user: usrProfile.WatsonID, password: usrProfile.WatsonPsswrd)
        //            .responseJSON { response in
        //            #if DEBUG
        //            print("Request: \(String(describing: response.request))")   // original url request
        //            print("Response: \(String(describing: response.response))") // http url response
        //
        //                switch response.result{
        //                case .success:
        //                    if let json = response.result.value {
        //                        print("JSON: \(json)") // serialized json response
        //                    }
        //                    if let data = response.data, let utf8Text = String(data: data, encoding: .utf8) {
        //                        print("Data: \(utf8Text)") // original server data as UTF8 string
        //                    }
        //
        //                case .failure(let error):
        //                    print(error)
        //                }
        //
        //
        //            #endif
    }
}
    


// MARK: per-dictation class used to filter the STT result by comparing against the user's CommonFilter
class SpeechFilter:SpeechRecog {
    // properties:
    // raw result inherited from SpeechRecog
    var filteredResult = ""
    var filterTime: Float = 0.0
    
    // constructor:
    override init(usr: User){
        super.init(usr: usr)
    }
    
    // funcs:
    // MARK: Compare the SpeechRecog.result word-by-word with the CommonFilter Dictionary, and take out the match
    open func matchCommonTics(usrComFilter: CommonFilter) {
        //let rawResultTuple = getWordList(str: rawResult)
        let rawResultArr = rawResult.components(separatedBy: " ")
        
        for word in rawResultArr{
            if(!usrComFilter.isOnList(word: word)){
                filteredResult += word
                filteredResult += " "
            }
        }
        if(!filteredResult.isEmpty){
            filteredResult.removeLast() //removes extra space at end
        }
    }
    
    //return an array of the individual words in string, and the word count
    // returned words will be lemmatized (e.g., struggles -> struggle)
    /*func getWordList(str: String) -> ([String], Int){
        var wordCnt = 0;
        var wordsList: [String] = []
        // parse potentially filtered string and potentially edited string to extract their words only
        // modified based on: https://stackoverflow.com/a/31633375
        // compare words with linguistic tagger
        let tagger = NSLinguisticTagger(tagSchemes: [NSLinguisticTagSchemeLemma], options: 0)
        tagger.string = str
        var range = NSRange(location: 0, length: str.utf16.count)
        let options: NSLinguisticTagger.Options = [.omitPunctuation, .omitWhitespace]
        tagger.string=str
        range = NSRange(location: 0, length: str.utf16.count)
        tagger.enumerateTags(in: range, unit: .word, scheme: NSLinguisticTagSchemeLemma, options: options) { tag, tokenRange, _ in
            wordCnt += 1
            if let lemma = tag {
                print(lemma)
                wordsList.append(tag!)
            }
            else{
                let word = (str as NSString).substring(with: tokenRange)
                wordsList.append(word)
                #if DEBUG
                    print(word)
                #endif
            }
        }
        return (wordsList, wordCnt)
    }*/
}




// MARK: per-dictation class used to output the final results, and book-keep
// CHANGE: it is bad to call the same obj in multiple view controller (and thru inheritance in this case)
// the proper way to do it is thru
// https://stackoverflow.com/questions/29734954/how-do-you-share-data-between-view-controllers-and-other-objects-in-swift
class FinalResult:SpeechFilter{
    // properties:
    var editedResult:String?    // nil if no edits were made from super.filterResult: String
    
    // constructor:
    init(usr: User, before: String){
        super.init(usr: usr)
        super.filteredResult = before;
        #if VER1
            editedResult = before
        #endif
    }
    
    // funcs:
    // VER2: Pass result of textbox upon submission. If there are changes between filterResult and after
    open func updateIfEdited(after: String)->Bool{
        //        self.editedResult = after;
        //        // VER2: instead of just comparing lemmatized word stems, compare strings to catch any necessary filtering of e.g., strugging -> struggle
        //        let (wordsInEdited, editedWC) = getWordList(str: after)
        //        let (wordsInFiltered, filteredWC) = getWordList(str: super.filterResult)
        //
        //        var j = 0
        //        var missing: String?
        //        for (i, word) in wordsInFiltered.enumerated(){
        //            // mismatch detected
        //            if(word != wordsInEdited[j]){
        //                // determine if word(s) changed by looking forward up to 5 words until match
        ////                var tempI = 0
        //                for index in stride(from: i, through: i+5, by: 1){
        //                    wordsInEdited[index]
        //                }
        //            }
        //            else{
        //                missing = missing! + word
        //            }
        //
        //        }
        return true
    }
    
    open func getFinalResult() -> String {
        if self.editedResult != nil {
            return self.editedResult!
        }
        else{
            return super.filteredResult
        }
    }
    
    
    
}

// return an array of the individual words in string, and the word count
// returned words will be lemmatized if option == "lemma" (e.g., struggling -> struggle)
// returned words will be just words if option == "word" (e.g., struggling -> struggling)
// defaults to "word"
// TODO: fix filtering of punctuation
func getWordList(str: String, option: String = "word") -> ([String], Int){
    var wordCnt = 0;
    var wordsList: [String] = []
    let tagger: NSLinguisticTagger
    
    // parse potentially filtered string and potentially edited string to extract their words only
    // modified based on: https://stackoverflow.com/a/31633375
    // compare words with linguistic tagger
    tagger = NSLinguisticTagger(tagSchemes: [NSLinguisticTagSchemeLemma], options: 0)
    
    let range = NSRange(location: 0, length: str.utf16.count)
    let options: NSLinguisticTagger.Options = [.omitPunctuation, .omitWhitespace]
    tagger.string = str
    
    tagger.enumerateTags(in: range, unit: .word, scheme: NSLinguisticTagSchemeLemma, options: options) { tag, tokenRange, _ in
        wordCnt += 1
        if option == "lemma", let lemma = tag {
            print(lemma)
            wordsList.append(tag!)
        }
        else{
            let word = (str as NSString).substring(with: tokenRange)
            wordsList.append(word)
            #if DEBUG
                print(word)
            #endif
        }
    }
    
    return (wordsList, wordCnt)
}

