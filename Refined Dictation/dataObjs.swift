//
//  dataObjs.swift
//  cmpt275_team1
//
//  Created by Shawn Wang on 2017-11-02.
//  Copyright © 2017 cmpt275. All rights reserved.
//

import Foundation
import FirebaseAuth
import SpeechToTextV1
import FirebaseDatabase




let EXCLUDE_MOST_COMMON_WORD_COUNT = 50    // used in CommonFilter() class
let INIT_CONFIDENCE = 80               // used in CommonFilter() class
let THRESHOLD_CONFIDENCE = 40               // used in CommonFilter() class
let HISTORY_GO_BACK_DATE_COUNT = 15

// Pre-processors are not allowed in Swift.
// Instead, MACROs are now defined in project -> Build Setting -> Swift Compiler - Custom Flags -> Active Compilation Conditions
// This project is currently using:
//#define DEBUG
// make sure DEBUG is turned off upon release



// MARK: per-user data structure used to manage words that we would like to filter
// constructed upon launch
/*
 * New: Changed to type method (https://developer.apple.com/library/content/documentation/Swift/Conceptual/Swift_Programming_Language/Methods.html , ctrl+F for 'Type Method')
 * to effectively become a global variable
 */
/*: Dictionary contains the words that the user has historically edited out from STT result that are NOT in the to EXCLUDE_MOST_COMMON_WORD_COUNT of the most spoken words list:
 http://www.talkenglish.com/vocabulary/top-2000-vocabulary.aspx
 */
class CommonFilter{
    // properties:
    // 1. Dictionary with top EXCLUDE_MOST_COMMON_WORD_COUNT words dictionary
    // 2. Dictionary with user's custom filtering words
    
    //creates empty dictionaries
    private static var ExcludedCommonWords = [String:Bool]()    // Bool to support turning on and off words to exclude from filtering
    private static var userFilterWords = [String: Int]()    // Int to describle a confidence % level. Any word below THRESHOLD_CONFIDENCE will not be used in filtering
    private static var usrID = String()
    
    
    // funcs:
    
    // MARK: initialize ExcludedCommonWords and get userFilterWords from Firebase
    static open func InitLists(_ usr: User)
    {
        usrID = usr.uid

        // Clear to prepare for re-populate
        if (ExcludedCommonWords.count != 0) {
            ExcludedCommonWords.removeAll()
        }
        if (userFilterWords.count != 0) {
            userFilterWords.removeAll()
        }
        
        
        /* populate ExcludedCommonWords from file */
        let file = "ExcludedCommonWordsList"
        //Get contents of file into one string
        let ExcludedWordsArr = readFromFile(filename:file, firstNumLines: EXCLUDE_MOST_COMMON_WORD_COUNT)
        
        //Add each string in ExcludedWordsArr to the ExcludedCommonWords dictionary
        for ExcludedWord in ExcludedWordsArr{
            ExcludedCommonWords[ExcludedWord] = true
        }
        
        
        /* populate userFilterWords from fireabse database */
        ref.child("users").child("\(usr.uid)").child("userFilterWords").observeSingleEvent(of: .value, with: { (snapshot) in
            userFilterWords = snapshot.value as? [String : Int] ?? [:]
            }) { (error) in
                print(error.localizedDescription)
        }
        
        #if DEBUG
            //Add default words to commonfilter library
            //userFilterWords["apple"] = true
        #endif
    }

    // MARK: user added a word in editor
    // If its not the top EXCLUDE_MOST_COMMON_WORD_COUNT words on the most spoken list, add to dictionary.
    // Return true if succeeded or already in the list (and increment confidence)
    // Return false if failed
    static open func added(_ word: String) {
        if(userFilterWords[word] != nil && userFilterWords[word]! < 100){
            userFilterWords[word]! += 20
            updateFIR(word)
        }
        else{
            userFilterWords[word] = INIT_CONFIDENCE
            updateFIR(word)
        }
    }
    
    // MARK: user removed a word in editor
    static open func removed(_ word: String) {
        if(userFilterWords[word] != nil){
            userFilterWords[word]! -= 20
            updateFIR(word)
        }
    }

    // MARK: user changed a word in editor to another word
    // instead of lowering the confidence lvl by 20 like we did for removing, we lower it by 10, and increment the new word by 10
    static open func changed(from: String, to: String) {
        if(userFilterWords[from] != nil){
            userFilterWords[from]! -= 10
            updateFIR(from)
        }
        userFilterWords[to] = 10
        updateFIR(to)
    }
    
    
    // MARK: Check if the word is in the current list.
    // Return true if in list
    // Return false if not in list
    static open func shouldFilter(word: String) -> Bool {
        if(userFilterWords[word] != nil && userFilterWords[word]! > THRESHOLD_CONFIDENCE ){
            return true
        }
        return false;
    }
    
    // MARK: used to import the ExcludedCommonWordsList from file
    static internal func readFromFile(filename: String, firstNumLines: Int) -> Array<String>{
        // File location
        let fileURL = Bundle.main.path(forResource: filename, ofType: "txt")
        
        // Read from the file
        var readString = ""
        do {
            readString = try String(contentsOfFile: fileURL!, encoding: String.Encoding.utf8)
        } catch let error as NSError {
            print("Failed reading from URL: \(error)" )
        }
        let wordsArr = readString.components(separatedBy: .newlines)
        return Array(wordsArr[0..<firstNumLines])   // get subArray of first firstNumLines words
    }
    
    // MARK: Called when an entry in userFilterWords has been created/updated
    static internal func updateFIR(_ word: String){
        if userFilterWords[word] != nil {
            ref.child("users/\(usrID)/userFilterWords").updateChildValues([word:userFilterWords[word]!])
        }
    }
}


// MARK: Static class to handle searches and favourites
class RecentDictsAndFavs{
    // Only the first HISTORY_GO_BACK_DATE_COUNT are retrieved upon launch
    static var recentDictations = [(String, NSDate, Bool)]()      // query by date: https://stackoverflow.com/a/38599978
    static var favourites = [(String, NSDate, Bool)]()
    static var userID = String()
    
    // 'manual constructor' for the static class. ALWAYS call this upon initializing this class
    static open func InitLists(_ usr: User){
        userID = usr.uid
        
        // Clear to prepare for re-populate
        if (recentDictations.count != 0) {
            recentDictations.removeAll()
        }
        if (favourites.count != 0) {
            favourites.removeAll()
        }

        // get the past HISTORY_GO_BACK_DATE_COUNT dictation records
        let backupDate = Calendar.current.date(byAdding: .day, value: -HISTORY_GO_BACK_DATE_COUNT, to: Date())!
        let backupTime = Double((backupDate.timeIntervalSince1970 * 1000.0).rounded())
        // queryEndingAtValue(ServerValue.timestamp()) is implied
        ref.child("users/\(userID)/dictations").queryOrdered(byChild: "timestamp").queryStarting(atValue: backupTime).observeSingleEvent(of: .value, with: { (snapshot) in
//            let ret = snapshot.value as? NSDictionary
            // TODO: HOW THE FUCK DO YOU GET ALL THE NODES?? https://firebase.google.com/docs/database/ios/read-and-write
            let ret = snapshot.value as? [(String, String?, String?, Double, Double, TimeInterval, Bool)] ?? []
            recentDictations = ret.map {
                ($0.2 ?? ($0.1 ?? $0.0), NSDate(timeIntervalSince1970: $0.5/1000), $0.6)  // divide by 1000 to get seconds: https://stackoverflow.com/a/30244373
            }
        }) { (error) in
            print(error.localizedDescription)
        }

        // get user's favourites
        ref.child("users/\(userID)/favourtes").observeSingleEvent(of: .value, with: {(snapshot) in
            if let favDict = snapshot.value as? [String:TimeInterval]{
                favourites = favDict.map{ ($0.0, NSDate(timeIntervalSince1970: $0.1/1000), true)}
            } else {
                // no favourtes
            }
        }) { (error) in
            print(error.localizedDescription)
        }
    }
    
    
    // MARK: New Favourite conforming to recentDictations/favourites format: (phrase, dictation timestamp, Favourited)
    static open func newFav(_ entry: (phrase: String, timestampInNSDate: NSDate?, favourited: Bool?)){
        // guard
        if (entry.favourited != nil && entry.favourited == false) {
            return
        }
        
        var timestamp: Any?
        if entry.timestampInNSDate != nil {
            timestamp = NSNumber(value: entry.timestampInNSDate!.timeIntervalSince1970)
        }
        
        // insert current time as timestamp if NSDate was not provided by the func caller
        let insert = [entry.phrase: timestamp ?? ServerValue.timestamp()]
        ref.child("users/\(userID)/favourtes").updateChildValues(insert)
        
        // ensure the dictation entry in firebase set to favourited: true
        let query = ref.child("users/\(userID)/dictations").queryOrdered(byChild: "finaResult").queryEqual(toValue: entry.phrase)
        query.observeSingleEvent(of: .value, with: {(snapshot) in
            
        })
    }
    
    // called upon exiting the favourite screen. Passes in ALL the favourites that got 'unhearted'
    static open func unFav(_ entries: [(phrase: String, timestampInNSDate: NSDate?, favourited: Bool?)]){


        // ensure the dictation entry in firebase set to favourited: false


    }

    // MARK: retrieve DEFAULT_HISTORY_COUNT more dictation records
    static open func getMoreDictationHistory(){
        
    }
    
}

// MARK: per-dictation class used to call Watson STT API and handle data
// instantiated on scenes with the red recording button
class SpeechRecog{
    // properties:
//    #if DEBUG
//    var speechPath = ""
//    #endif
    var speechToText: SpeechToText
    var rawResult = ""
    var recordTime = 0.0
    
    
    // constructor:
    init(){
        // Watson supplied test speech recording
//        #if DEBUG
//        let fileURL=Bundle.main.bundleURL.appendingPathComponent("audio-file.flac")
//        self.speechPath = fileURL.path
//        #endif
        
        // Init STT API
        speechToText = SpeechToText(username: "70c6c385-6d1f-4cd1-9239-eaf59fc38a08", password: "Ph70dloSxwhe")
    }
    
    
    // funcs:
    // called when red recording button is tapped
    // Result string will be returned piece-by-piece, and appended to self.result
    open func recBegin(){
        timer.tic()
        var settings = RecognitionSettings(contentType: .oggOpus)
        settings.interimResults = true      // send piece-wise voice for processing ASAP
        var lastBestTranscript = ""
        let failure = { (error: Error) in print(error) }
        self.speechToText.recognizeMicrophone(settings: settings, failure: failure) { results in
            #if DEBUG
            // piece-wise result
            print(results.bestTranscript)
            #endif
            if results.bestTranscript.split(separator: " ").count > 1 {
                lastBestTranscript = results.bestTranscript
                #if DEBUG
                    print("New best transcript result: \(lastBestTranscript)")
                #endif
            }
            self.rawResult = lastBestTranscript
            
        }
    }
    
    // called when red recording button is tapped again
    open func recStop(){
        self.speechToText.stopRecognizeMicrophone()
        recordTime = timer.toc()
    }
}


// MARK: per-dictation class used to filter the STT result by comparing against the user's CommonFilter
class SpeechFilter {
    // properties:
    var rawResult = ""
    var filteredResult = ""
    var filterTime: Double = 0.0
    
    // constructor:
    init(_ raw: String){
        rawResult = raw
        matchCommonTics()
    }
    
    init(){
        
    }
    
    // funcs:
    // MARK: Compare the SpeechRecog.result word-by-word with the CommonFilter Dictionary, and take out the match
    open func matchCommonTics() {
        timer.tic()
        let rawResultArr = rawResult.components(separatedBy: " ")
        
        for word in rawResultArr{
            if(!CommonFilter.shouldFilter(word: word)){
                filteredResult += word
                filteredResult += " "
            }
        }
        if(!filteredResult.isEmpty){
            filteredResult.removeLast() //removes extra space at end
        }
        filterTime = timer.toc()
    }
}




// MARK: per-dictation class used to output the final results, and book-keep
class FinalResult {
    // properties:
    var rawResult: String
    var filteredResult: String? // nil if nothing filtered
    var editedResult:String?    // nil if no edits were made from super.filterResult: String
    var finalResult: String     // the first non-nil of edited -> filtered -> raw. Exists because of firebase's garbage query capabilities
    var STTTime: Double
    var filterTime: Double
    
    // constructor:
    init(raw: String, filtered: String?, edited: String?, STTT: Double, filterT: Double){
        // determine what to assign finalResult: String
        if edited == nil {
            finalResult = edited!
        }
        else if filtered != nil{
            finalResult = filtered!
        }
        else{
            finalResult = raw
        }
        
        // fill in other data
        if edited == nil {
            editedResult = edited!
        }
        if filtered != nil{
            filteredResult = filtered!
        }
        rawResult = raw
        STTTime = STTT
        filterTime = filterT
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
            if filteredResult != nil {
                return filteredResult!
            }
            else {
                return rawResult
            }
        }
        

    }
    
    // MARK: Called when this newly dictated FinalResult obj is favourited
    open func favDictation(){
        // conform to the interface of the method: (Phrase, timestamp, Favourited)
        RecentDictsAndFavs.newFav( (finalResult, nil, true) )
    }
    
    open func insertDictationToFIR(){
        let key = ref.child("users").childByAutoId().key
        let post = ["rawResult": rawResult,
                    "filteredResult": filteredResult ?? "",
                    "editedResult": editedResult ?? "",
                    "finaResult": finalResult,
                    "STTTime": STTTime,
                    "filterTime": filterTime,
                    "timestamp": ServerValue.timestamp(),    // timestamping firebase data: https://stackoverflow.com/a/30244373
                                                            // This is stored in miliseconds since EPOCH time, in UTC
                    "Favourited": false
            ] as [String : Any]
        let userID = Auth.auth().currentUser!.uid
        let childUpdates = ["/users/\(userID)/dictations/\(key)/": post]
        ref.updateChildValues(childUpdates)
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
    



// MARK: timer class for statistics
// Modified based on: https://stackoverflow.com/a/46044214
class timer {
    
    private static var ticTimestamp: Date = Date()
    
    static func tic() {
//        print("TICK.")
        ticTimestamp = Date()
    }
    
    static func toc()-> Double {
        return Date().timeIntervalSince(ticTimestamp)
    }
    
}


