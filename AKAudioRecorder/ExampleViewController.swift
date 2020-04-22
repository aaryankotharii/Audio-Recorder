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
    
    var recorder = AKAudioRecorder.shared
    
    override func viewDidLoad() {
        tableView.dataSource = self
        tableView.delegate = self
        super.viewDidLoad()
        setCircle()
        // Do any additional setup after loading the view.
    }
    
    @IBAction func playstopButton(_ sender: UIButton) {
        if recorder.isRecording{
            animate(isRecording: true)
            recorder.stopRecording()
            playButton.titleLabel?.text = "Stop"
            tableView.reloadData()
            print(recorder.getRecordings)
        } else{
            animate(isRecording: false)
            recorder.record()
            playButton.titleLabel?.text = "Record"
        }
    }

}
extension ExampleViewController: UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return recorder.getRecordings.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .subtitle
            , reuseIdentifier: "cell")
         
        let recording = recorder.getRecordings[indexPath.row]
        
        cell.detailTextLabel?.text = String(recording)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let name = recorder.getRecordings[indexPath.row]
        recorder.play(name: name)
    }
}


