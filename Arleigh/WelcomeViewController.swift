//
//  WelcomeViewController.swift
//  Arleigh
//
//  Created by Laurence Wingo on 6/15/18.
//  Copyright © 2018 Cosmic Arrows, LLC. All rights reserved.
//

import UIKit
import AVFoundation

class WelcomeViewController: UIViewController {

    @IBOutlet var audioSegmentControl: UISegmentedControl!
    @IBOutlet var welcomeToArleighButton: UIButton!
    let speechSynthesizer = AVSpeechSynthesizer()
    
    func speakTerms() -> String{
        let terms = "Hello!  Meet Arleigh!  Arleigh was created using open education resources on iOS frameworks, neuroscience, and psychology.  Our wishes are to provide you with enhanced day to day care.  We need to synchronize with your physician's Care Card.  Eventually, you will be able to speak to Arleigh using your own voice.  Can we begin downloading your care card by tapping Hello Arleigh?"
        return terms
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        welcomeToArleighButton.layer.cornerRadius = 10
        audioSegmentControl.backgroundColor = welcomeToArleighButton.backgroundColor
        audioSegmentControl.isHidden = true
        welcomeToArleighButton.backgroundColor = view.backgroundColor
        welcomeToArleighButton.alpha = 0.8
        
        //view animation code
        let delay = 4.2 // time in seconds
        Timer.scheduledTimer(timeInterval: delay, target: self, selector: #selector(animatedViewBackground), userInfo: nil, repeats: true)
        //end of view animation code

        let speechUtterance = AVSpeechUtterance.init(string: speakTerms())
        speechUtterance.voice = AVSpeechSynthesisVoice.init(identifier: "com.apple.ttsbundle.siri_female_en-GB_compact")
        speechUtterance.rate = 0.4
        speechSynthesizer.speak(speechUtterance)
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func welcomeButtonTapped(_ sender: UIButton) {
        let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "showCareCard") as! ViewController
        
        self.navigationController?.pushViewController(vc, animated: true)
        //present(vc, animated: true, completion: nil)
        
    }
    
    @IBAction func audioSegmentControlTapped(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            sender.setTitle("Playing Audio", forSegmentAt: 0)
            sender.setTitle("Mute Audio", forSegmentAt: 1)
            speechSynthesizer.continueSpeaking()
        case 1:
            sender.setTitle("Unmute Audio", forSegmentAt: 0)
            sender.setTitle("Audio Muted", forSegmentAt: 1)
            speechSynthesizer.pauseSpeaking(at: AVSpeechBoundary.immediate)
        default:
            break
        }
        
    }
    
    func generateRandomColor() -> UIColor {
        let hue : CGFloat = CGFloat(arc4random() % 256) / 256 // use 256 to get full range from 0.0 to 1.0
        let saturation : CGFloat = CGFloat(arc4random() % 128) / 256 + 0.5 // from 0.5 to 1.0 to stay away from white
        let brightness : CGFloat = CGFloat(arc4random() % 128) / 256 + 1.0 // from 0.5 to 1.0 to stay away from black
        
        return UIColor(hue: hue, saturation: saturation, brightness: brightness, alpha: 1)
    }
    
    @objc func animatedViewBackground(){
        UIView.animateKeyframes(withDuration: 4.0, delay: 0.0, options: .allowUserInteraction, animations: {
            self.view.backgroundColor = self.generateRandomColor()
            //self.welcomeToArleighButton.backgroundColor = self.generateRandomColor()
        }, completion: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        //hide the navigation bar on this view contoller
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        //show the navigation bar on other view controllers
        self.navigationController?.setNavigationBarHidden(false, animated: true)
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
