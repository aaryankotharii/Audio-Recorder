//
//  ExampleViewController.swift
//  AKAudioRecorder
//
//  Created by Aaryan Kothari on 22/04/20.
//  Copyright © 2020 Aaryan Kothari. All rights reserved.
//

import UIKit

class ExampleViewController: UIViewController {
    
    //MARK:- Outlets
    @IBOutlet var tableView: UITableView!
    @IBOutlet var playButton: UIButton!
    @IBOutlet var timeLabel: UILabel!
    
    //MARK:- Variables
    var recorder = AKAudioRecorder.shared
    var displayLink = CADisplayLink()
    var duration : CGFloat = 0.0
    var timer : Timer!
    
    
    //MARK:- ViewDidLoad + Initial Setup
    override func viewDidLoad() {
        super.viewDidLoad()
        initialSetup()
    }
    
    func initialSetup(){
        tableView.dataSource = self
        tableView.delegate = self
        tableView.contentInset.top = 30
        setCircle()
        dismissKeyboard()
    }
    
    //MARK:- Play / Stop Recording
    @IBAction func playstopButton(_ sender: UIButton) {
        if recorder.isRecording{
            animate(isRecording: true)
            recorder.stopRecording()
            tableView.reloadData()
        } else{
            animate(isRecording: false)
            recorder.record()
            setTimer()
        }
    }
}


//MARK:- UITableView Delegate Methods
extension ExampleViewController: UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return recorder.getRecordings.count          //Number of Cells
    }
    
    //MARK:- Set Cell
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! recordingTableViewCell
         
        let recording = recorder.getRecordings[indexPath.row]      // FileName
        let name = "New Recording " + String(indexPath.row + 1)    // New Recording 1,2,3...
        cell.recordingName.text = name
        cell.fileName.text =  "FileName :- \(recording)"
        cell.slider.isHidden = true                                 // hide slider
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let name = recorder.getRecordings[indexPath.row]    // FileName
        recorder.play(name: name)                           //Play
        let cell = tableView.cellForRow(at: indexPath) as! recordingTableViewCell
        cell.slider.isHidden = false                        //Show slider
        cell.playSlider()
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as! recordingTableViewCell
        cell.slider.isHidden = true                         //hide slider
    }
  
    //MARK:- Delete Recording
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let name = recorder.getRecordings[indexPath.row]
            recorder.deleteRecording(name: name)
            tableView.deleteRows(at: [indexPath], with: .fade)
            debugLog("Deleted Recording")
            print(recorder.getRecordings)
        }
    }
    
    //MARK:- Row Height
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 88
    }
}


