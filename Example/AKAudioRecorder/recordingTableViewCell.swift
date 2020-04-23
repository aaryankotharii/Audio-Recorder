//
//  recordingTableViewCell.swift
//  AKAudioRecorder
//
//  Created by Aaryan Kothari on 22/04/20.
//  Copyright © 2020 Aaryan Kothari. All rights reserved.
//

import UIKit

class recordingTableViewCell: UITableViewCell {

    //MARK:- Cell Outlets
    @IBOutlet var recordingName: UITextField!
    @IBOutlet var fileName: UILabel!
    @IBOutlet var slider : UISlider!
    
    //MARK:- Variables
    var displayLink = CADisplayLink()
    var recorder = AKAudioRecorder.shared
   
    override func awakeFromNib() {
        super.awakeFromNib()
        slider.setThumbImage(#imageLiteral(resourceName: "slider"), for: .normal) ///   SET SLIDER ITHUMB IMAGE
    }

    
    //MARK:- SET CELL HIGHLIGHT COLOR
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        if selected {
            contentView.backgroundColor = UIColor(named: "tableView-highlight")
        } else {
            contentView.backgroundColor = .systemBackground
        }

    }
    
    //MARK:- UPDATE SLIDER
    @objc func updateSliderProgress(){
        
         var progress = recorder.getCurrentTime() / Double(recorder.duration) /// progress 0 -> 1
        
         if recorder.isPlaying == false || progress == .infinity {
             displayLink.invalidate()
             progress = 0.0
         }
        slider.value = Float(progress)  /// Slider value is equal to progress
     }
     
    //MARK:- Run Time Loop for slider
     func playSlider(){
        if recorder.isPlaying{
            displayLink = CADisplayLink(target: self, selector: #selector(self.updateSliderProgress))
            self.displayLink.add(to: RunLoop.current, forMode: RunLoop.Mode.default)
         }
     }
}
