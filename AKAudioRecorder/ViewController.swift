//
//  ViewController.swift
//  AKAudioRecorder
//
//  Created by Aaryan Kothari on 22/04/20.
//  Copyright © 2020 Aaryan Kothari. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    var recorder = AKAudioRecorder.shared

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }


    @IBAction func record(_ sender: Any) {
       recorder.record { (success) in
            if success {
                print("success")
            }
        }
    }
    
    @IBAction func stop(_ sender: Any) {
        recorder.stopRecording()
    }
    
    @IBAction func play(_ sender: Any) {
        recorder.play { (success) in
            if success {
                print("success")
            }
        }
    }
    
}

