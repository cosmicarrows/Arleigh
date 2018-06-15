//
//  ViewController.swift
//  Arleigh
//
//  Created by Laurence Wingo on 6/15/18.
//  Copyright © 2018 Cosmic Arrows, LLC. All rights reserved.
//

import UIKit
import CareKit
import AVFoundation

class ViewController: UIViewController {
    
    //one Care Plan Store object that lives during the life of the application in which we set it in the intializer below
    let store: OCKCarePlanStore
    let speechSynthesizer = AVSpeechSynthesizer()
    
    required init?(coder aDecoder: NSCoder) {
        //1
        let fileManager = FileManager.default
        let documentDirectory = fileManager.urls(for: .documentDirectory, in: .userDomainMask).last
        let storeURL = documentDirectory?.appendingPathComponent("NostalgiaCareKitStore")
        if !fileManager.fileExists(atPath: (storeURL?.path)!) {
            try! fileManager.createDirectory(atPath: (storeURL?.path)!, withIntermediateDirectories: true, attributes: nil)
        }
        store = OCKCarePlanStore.init(persistenceDirectoryURL: storeURL!)
        super.init(coder: aDecoder)
        
    }
    
    func speakTerms() -> String {
        let terms = "Arleigh uses push notifications as a way to increase as well as decrease dopamine and or cortisol levels of research participants.  During spike periods, we ask users to complete intervention tasks or assessments in order to measure your symptoms.  Each intervention and assessment is designated by color, based on the time it will take to complete the assessment or level of difficulty.  The application will use Apple’s ResearchKit and CareKit frameworks in an effort to collaborate with Universities such as Georgia State University, Emory University, MIT, and Sage Bio-networks.  The features of the application will be that it utilizes Core Motion, HealthKit, and Core Location frameworks to keep track of your physical activity, breathing, blood pressure, medicine intake, and dieting patterns. You may receive local and remote push notifications alerting you of required tasks to improve your overall health.  Your patient Care Card using Apple’s CareKit framework will list intervention steps to regulate your choices for a desired outcome.  The arching motivator of Arleigh, is offering you the opportunity remain in control of your choices while also monitoring your data for enhanced safety.  Upon your request, we can transmit data to your physician using Arleigh.  We will securely share your care card with your physician or transmit the data securely upon arriving at the hospital.  This can be done at the bluetooth i-beacon station to receive further direct and immediate care."
        return terms
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        //add a single b6 vitamin intake activity to the Care Plan Store
        createb6VitaminActivity()
        //_clearStore()
        
        let speechUtterance = AVSpeechUtterance.init(string: speakTerms())
        speechUtterance.voice = AVSpeechSynthesisVoice.init(identifier: "com.apple.ttsbundle.siri_female_en-GB_compact")
        speechUtterance.rate = 0.4
        speechSynthesizer.speak(speechUtterance)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func showCareCard(_ sender: UIButton) {
        let careCardViewController = OCKCareCardViewController.init(carePlanStore: store)
        //present the view controller modally
        self.navigationController?.pushViewController(careCardViewController, animated: true)
    }
    
    
    
    //adding an intervention activity
    func createb6VitaminActivity(){
        //each activity has a unique identifer
        let b6VitaminIdentifier = "B6 Vitamin Intake Activity"
        store.activity(forIdentifier: b6VitaminIdentifier) { (success, foundActivity, error) in
            guard success else {
                fatalError("*** An error occurred \(String(describing: error?.localizedDescription)) ***")
            }
            if let activity = foundActivity {
                //if activity already exists
                print("Activity found - \(activity.identifier)")
            } else {
                let startDay = DateComponents.init(year: 2018, month: 3, day: 15)
                let thriceDay = OCKCareSchedule.dailySchedule(withStartDate: startDay, occurrencesPerDay: 3)
                let b6Vitaminmedication = OCKCarePlanActivity.init(identifier: b6VitaminIdentifier, groupIdentifier: nil, type: .intervention, title: "Vegan B6 Vitamin Intake", text: "Chewables", tintColor: nil, instructions: "Take Nature's Farm B6 Vitamin three times a day.  This should make you feel more alert.  It is not recommended to drive with this medication.  For any severe side effects, please contact your physician.", imageURL: nil, schedule: thriceDay, resultResettable: true, userInfo: nil)
                self.store.add(b6Vitaminmedication, completion: { (success, error) in
                    guard success else {
                        fatalError("*** An error occurred \(String(describing: error?.localizedDescription)) ***")
                    }
                })
            }
        }
        
    }
    
    private func _clearStore() {
        print("*** CLEANING STORE DEBUG ONLY ****")
        
        let deleteGroup = DispatchGroup()
        let store = self.store
        
        deleteGroup.enter()
        store.activities { (success, activities, errorOrNil) in
            
            guard success else {
                // Perform proper error handling here...
                fatalError(errorOrNil!.localizedDescription)
            }
            
            for activity in activities {
                
                deleteGroup.enter()
                store.remove(activity) { (success, error) -> Void in
                    
                    print("Removing \(activity)")
                    guard success else {
                        fatalError("*** An error occurred: \(error!.localizedDescription)")
                    }
                    print("Removed: \(activity)")
                    deleteGroup.leave()
                }
            }
            
            deleteGroup.leave()
        }
    }
    
}

