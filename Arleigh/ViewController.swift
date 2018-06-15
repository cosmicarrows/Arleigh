//
//  ViewController.swift
//  Arleigh
//
//  Created by Laurence Wingo on 6/15/18.
//  Copyright © 2018 Cosmic Arrows, LLC. All rights reserved.
//

import UIKit
import CareKit

class ViewController: UIViewController {
    
    //one Care Plan Store object that lives during the life of the application in which we set it in the intializer below
    let store: OCKCarePlanStore
    
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

    override func viewDidLoad() {
        super.viewDidLoad()
        //add a single b6 vitamin intake activity to the Care Plan Store
        createb6VitaminActivity()
        createDeepBreathingActivity()
        //_clearStore()
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
    
    func createDeepBreathingActivity(){
        let deepBreathingIdentificer = "Deep Breathing"
        store.activity(forIdentifier: deepBreathingIdentificer) { (success, foundActivity, error) in
            guard success else {
                fatalError()
            }
            if let activity = foundActivity {
                print("Breathing Activity Already Found with the identifier \(activity.identifier)")
            } else {
                let startDay = DateComponents.init(year: 2018, month: 6, day: 15)
                let thriceDay = OCKCareSchedule.dailySchedule(withStartDate: startDay, occurrencesPerDay: 4)
                let deepBreathingExercise = OCKCarePlanActivity.init(identifier: "Practice Deep Breathing", groupIdentifier: nil, type: .intervention, title: "Deep Breathing Exercise", text: "4 Deep Breaths", tintColor: UIColor.green, instructions: "Take four deep breathes while counting...1...2...3...4...5...and then repeat three times", imageURL: nil, schedule: thriceDay, resultResettable: true, userInfo: nil)
                self.store.add(deepBreathingExercise, completion: { (success, error) in
                    guard success else {
                        fatalError()
                    }
                })
            }
        }
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

