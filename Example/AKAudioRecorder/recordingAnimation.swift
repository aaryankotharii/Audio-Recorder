//
//  recordingAnimation.swift
//  AKAudioRecorder
//
//  Created by Aaryan Kothari on 22/04/20.
//  Copyright © 2020 Aaryan Kothari. All rights reserved.
//

import Foundation
import UIKit

extension ExampleViewController{
    func animate(isRecording : Bool){
        if isRecording{
        self.playButton.layer.cornerRadius = 4
        UIView.animate(withDuration: 0.1) {
            self.playButton.transform = CGAffineTransform(scaleX: 2, y: 2)
            self.playButton.layer.cornerRadius = 15
        }
        }
        else{
            UIView.animate(withDuration: 0.1) {
                self.playButton.transform = .identity
                self.playButton.layer.cornerRadius = 4
            }
        }
    }
    
    func setCircle(){
       self.playButton.transform = CGAffineTransform(scaleX: 2, y: 2)
        self.playButton.layer.cornerRadius = 15
    }
    
    func setTimer(){
        self.timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateDuration), userInfo: nil, repeats: true)
    }

    @objc func updateDuration() {
        if recorder.isRecording && !recorder.isPlaying{
            duration += 1
            self.timeLabel.alpha = 1
            self.timeLabel.text = duration.timeStringFormatter
        }else{
            timer.invalidate()
            self.timeLabel.alpha = 0
            self.timeLabel.text = "0:00"
        }
    }
}

extension UIView {

@IBInspectable
var cornerRadius: CGFloat {
    get {
        return layer.cornerRadius
    }
    set {
        layer.cornerRadius = newValue
    }
}

@IBInspectable
var borderWidth: CGFloat {
    get {
        return layer.borderWidth
    }
    set {
        layer.borderWidth = newValue
    }
}

@IBInspectable
var borderColor: UIColor? {
    get {
        if let color = layer.borderColor {
            return UIColor(cgColor: color)
        }
        return nil
    }
    set {
        if let color = newValue {
            layer.borderColor = color.cgColor
        } else {
            layer.borderColor = nil
        }
    }
}
}

extension UIViewController {
    // Function for tap gesture
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    // Calling dismiss selector actions
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}
