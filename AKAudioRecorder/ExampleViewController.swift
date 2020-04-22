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

        // Do any additional setup after loading the view.
    }
}


extension ExampleViewController: UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return recorder.getRecordings.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")
        
        let recording = recorder.getRecordings[indexPath.row]
        
        cell?.detailTextLabel?.text = String(recording)
        
        return cell!
    }
}


