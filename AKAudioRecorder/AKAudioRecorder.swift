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
    
    var isRecording : Bool = false
    var isPlaying : Bool = false
    
    var duration = CGFloat()

    
    private func InitialSetup(){
         let audioFilename = getDocumentsDirectory().appendingPathComponent("recording.m4a")
        
        do{
            try audioSession.setCategory(AVAudioSession.Category.playAndRecord, options: .defaultToSpeaker)
            audioRecorder = try AVAudioRecorder(url: audioFilename, settings: settings)
            audioRecorder.delegate = self as? AVAudioRecorderDelegate
            audioRecorder.isMeteringEnabled = true
            audioRecorder.prepareToRecord()
        } catch let audioError as NSError {
            print ("Error setting up: %@", audioError)
        }
    }
    
    func record(completion: @escaping (Bool) -> ()){
        InitialSetup()
        
        if let audioRecorder = audioRecorder{
            if !isRecording {
                do{
                    try audioSession.setActive(true)
                    
                    duration = 0
                    self.timer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(self.updateDuration), userInfo: nil, repeats: true)
                    
                    audioRecorder.record()
                    isRecording = true
                    print("recording now")
                    completion(true)
                } catch let recordingError as NSError{
                    print ("Error recording : %@", recordingError.localizedDescription)
                    completion(false)
            }
        }
    }
}
    
    func stop(){
        if audioRecorder != nil{
            audioRecorder.stop()
            audioRecorder = nil
            do {
                  try audioSession.setActive(false)
                isRecording = false
                print("Recording stopped")
              } catch {
                  print("stop()",error.localizedDescription)
              }
        }
    }
    
    
    func play(completion: @escaping (Bool) -> ()){
        if !isRecording && !isPlaying {
                let path = getDocumentsDirectory().appendingPathComponent("recording.m4a")
                       print("playing")
                       do{
                           audioPlayer = try AVAudioPlayer(contentsOf: path)
                        audioPlayer.delegate = self as? AVAudioPlayerDelegate
                           audioPlayer.play()
                        print("Recording stopped")

                        completion(true)
                       }catch{
                           print(error.localizedDescription)
                       }
        }else{
            completion(false)
            return
        }
    }
    
    func getTime() -> String {
        return duration.timeStringFormatter
    }

    
    @objc private func updateDuration() {
        if isRecording && !isPlaying{
            duration += 0.1
        //timeLabel.text = duration.timeStringFormatter
        }else{
            timer.invalidate()
        }
       }
    
    func getDocumentsDirectory() -> URL {
         let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
         return paths[0]
     }
}

extension CGFloat{
    var timeStringFormatter : String {
        let format : String?
        let minutes = Int(self) / 60 % 60
        let seconds = Int(self) % 60
        if minutes < 60 {    format = "%01i:%02i"   }
        else {    format = "%01i:%02i"    }
        return String(format: format!, minutes, seconds)
    }
}
