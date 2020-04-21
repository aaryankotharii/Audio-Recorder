//
//  AKAudioRecorder.swift
//  AKAudioRecorder
//
//  Created by Aaryan Kothari on 22/04/20.
//  Copyright © 2020 Aaryan Kothari. All rights reserved.
//

import Foundation
import AVFoundation


class AKAudioRecorder {
    
    static let shared = AKAudioRecorder()
    
    //MARK:- Variables
    private var audioSession : AVAudioSession = AVAudioSession.sharedInstance()
    private var audioRecorder : AVAudioRecorder!
    private var audioPlayer : AVAudioPlayer = AVAudioPlayer()
    
    private var settings =   [  AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
                                AVSampleRateKey: 12000,
                                AVNumberOfChannelsKey: 1,
                                AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue ]
    
    fileprivate var timer: Timer!
    
    private func InitialSetup(){
         let audioFilename = getDocumentsDirectory().appendingPathComponent("recording.m4a")
        
        do{
            try audioSession.setCategory(AVAudioSession.Category.playAndRecord, options: .defaultToSpeaker)
            audioRecorder = try AVAudioRecorder(url: audioFilename, settings: settings)
            audioRecorder.delegate = self as? AVAudioRecorderDelegate
            audioRecorder.isMeteringEnabled = true
            audioRecorder.prepareToRecord()
        } catch let audioError as NSError {
            print ("Error signing out: %@", audioError)
        }
    }
    
    func getDocumentsDirectory() -> URL {
         let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
         return paths[0]
     }
}
