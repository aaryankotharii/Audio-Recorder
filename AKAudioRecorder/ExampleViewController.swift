//
//  ExampleViewController.swift
//  AKAudioRecorder
//
//  Created by Aaryan Kothari on 22/04/20.
//  Copyright © 2020 Aaryan Kothari. All rights reserved.
//

import UIKit

class ExampleViewController: UIViewController {
    
    @IBOutlet var tableView: UITableView!
    @IBOutlet var playButton: UIButton!
    @IBOutlet var timeLabel: UILabel!
    
    var recorder = AKAudioRecorder.shared
    var displayLink = CADisplayLink()
    var duration : CGFloat = 0.0
    var timer : Timer!
    
    override func viewDidLoad() {
        tableView.dataSource = self
        tableView.delegate = self
        super.viewDidLoad()
        setCircle()
    }
    
    @IBAction func playstopButton(_ sender: UIButton) {
        if recorder.isRecording{
            animate(isRecording: true)
            recorder.stopRecording()
            tableView.reloadData()
            print(recorder.getRecordings)
        } else{
            animate(isRecording: false)
            recorder.record()
            setTimer()
            print(recorder.getTime())
        }
    }
}

extension ExampleViewController: UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return recorder.getRecordings.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! recordingTableViewCell
         
        let recording = recorder.getRecordings[indexPath.row]
        let name = "New Recording " + String(indexPath.row + 1)
        cell.recordingName.text = name
        cell.fileName.text = String(recording)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let name = recorder.getRecordings[indexPath.row]
        recorder.play(name: name)
        let cell = tableView.cellForRow(at: indexPath) as! recordingTableViewCell
        cell.slider.isHidden = false
        cell.playSlider()
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as! recordingTableViewCell
        cell.slider.isHidden = true
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 88
    }
}


