//
//  ViewController.swift
//  AKAudioRecorder
//
//  Created by Aaryan Kothari on 22/04/20.
//  Copyright © 2020 Aaryan Kothari. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }


    @IBAction func record(_ sender: Any) {
        AKAudioRecorder.shared.record { (success) in
            if success {
                print("success")
            }
        }
    }
    
    @IBAction func stop(_ sender: Any) {
        AKAudioRecorder.shared.stop()
    }
    @IBAction func play(_ sender: Any) {
        AKAudioRecorder.shared.play { (success) in
            if success {
                print("success")
            }
        }
        
    }
}

