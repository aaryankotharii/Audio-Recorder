//
//  AKAudioRecorder.swift
//  AKAudioRecorder
//
//  Created by Aaryan Kothari on 22/04/20.
//  Copyright © 2020 Aaryan Kothari. All rights reserved.
//

import Foundation
import AVFoundation


class AKAudioRecorder: NSObject {
    
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
    var recordingName : String?
    var numberOfLoops : Int?
    var rate : Float?
    
    private var myRecordings = [String]()
    
    private var fileName : String?
    
    private func InitialSetup(){
        fileName = NSUUID().uuidString
        let audioFilename = getDocumentsDirectory().appendingPathComponent((recordingName?.appending(".m4a") ?? fileName!.appending(".m4a")))
        myRecordings.append(recordingName ?? fileName!)
        do{
            try audioSession.setCategory(AVAudioSession.Category.playAndRecord, options: .defaultToSpeaker)
            audioRecorder = try AVAudioRecorder(url: audioFilename, settings: settings)
            audioRecorder.delegate = self
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
    
    func stopRecording(completion: (() -> Void)? = nil){
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
            if let fileName = fileName {
             let path = getDocumentsDirectory().appendingPathComponent(fileName+".m4a")
                       print("playing")
                       do{
                        audioPlayer = try AVAudioPlayer(contentsOf: path)
                        (rate == nil) ? (audioPlayer.enableRate = false) : (audioPlayer.enableRate = true)
                        audioPlayer.rate = rate ?? 1.0
                        audioPlayer.delegate = self
                        audioPlayer.numberOfLoops = numberOfLoops ?? 0
                        audioPlayer.play()
                        print("Recording stopped")
                        completion(true)
                       }catch{
                           print(error.localizedDescription)
                        }}else{
                        completion(false)
                        print("no file exists")
            }
        }else{
            completion(false)
            return
        }
    }
    
    func play(name:String) {
        
        let fileName = name + ".m4a"
        
        let path = getDocumentsDirectory().appendingPathComponent(fileName)
        
        if FileManager.default.fileExists(atPath: path.path) && !isRecording && !isPlaying {
            
            do {
                audioPlayer = try AVAudioPlayer(contentsOf: path)
                audioPlayer.delegate = self
                audioPlayer.play()
            } catch {
                print("play(with name:), ",error.localizedDescription)
            }
        } else {
            return
            print("File Does not Exist")
        }
    }
    
    func stopPlaying(){
        audioPlayer.stop()
        isPlaying = false
    }
    
    func restartPlayer(){
        audioPlayer.stop()
        audioPlayer.currentTime = 0
        audioPlayer.play()
        isPlaying = true
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


extension AKAudioRecorder : AVAudioRecorderDelegate{
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        isRecording = false
        timer.invalidate()
        
        switch flag {
        case true:
                print("record finish")
        case false:
            print("record erorr")
        }
            }
    func audioRecorderEncodeErrorDidOccur(_ recorder: AVAudioRecorder, error: Error?) {
        isRecording = false
        print(error?.localizedDescription ?? "Error occured while encoding recorder")
    }
}

extension AKAudioRecorder: AVAudioPlayerDelegate{
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        isPlaying = false
        print("playing finish")
    }
    
    func audioPlayerDecodeErrorDidOccur(_ player: AVAudioPlayer, error: Error?) {
        isPlaying = false
         print(error?.localizedDescription ?? "Error occured while encoding player")
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
