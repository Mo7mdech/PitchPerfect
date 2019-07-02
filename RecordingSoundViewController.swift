//
//  PitchPerfect
//  ViewController
//  Created by Mohammed Jarad on 3/13/19.
//  Copyright © 2019 Jarad. All rights reserved.
//

import UIKit
import AVFoundation

class RecordingSoundViewController: UIViewController, AVAudioRecorderDelegate {
    @IBOutlet weak var recordButton: UIButton!
    @IBOutlet weak var stopRecordingButton: UIButton!
    @IBOutlet weak var recordLabel: UILabel!
    
    var audioRecorder: AVAudioRecorder!
    
    enum RecordingState{
        case recording, notRecording
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("App is appearing")
        configureUI(.notRecording)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func recordAudio(_ sender: Any) {
        configureUI(.recording)
        
        let dirPath = NSSearchPathForDirectoriesInDomains(.documentDirectory,.userDomainMask, true)[0] as String
        let recordingName = "recordedVoice.wav"
        let pathArray = [dirPath, recordingName]
        let filePath = URL(string: pathArray.joined(separator: "/"))
        print(filePath!)
        
        let session = AVAudioSession.sharedInstance()
        try! session.setCategory(AVAudioSessionCategoryPlayAndRecord, with:AVAudioSessionCategoryOptions.defaultToSpeaker)
        
        try! audioRecorder = AVAudioRecorder(url: filePath!, settings: [:])
        audioRecorder.delegate = self
        audioRecorder.isMeteringEnabled = true
        audioRecorder.prepareToRecord()
        audioRecorder.record()
    }
    
    @IBAction func stopRecording(_ sender: Any) {
        print("stopped")
//        recordLabel.text = "Tab to Record"
//        stopRecordingButton.isEnabled = false
//        recordButton.isEnabled = true
        configureUI(.notRecording)
        
        audioRecorder.stop()
        let audioSession = AVAudioSession.sharedInstance()
        try! audioSession.setActive(false)
    }
    
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        if flag{
            print("finished Recording")
            performSegue(withIdentifier: "stopRecording", sender: audioRecorder.url)
        }
        else{
            print("Recording Failed")
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "stopRecording"{
            let playSoundVC = segue.destination as! PlaySoundViewController
            let recordAudioURL = sender as! URL
            playSoundVC.recordedAudioURL = recordAudioURL
            
        }
    }
    
    func configureUI(_ recordState: RecordingState) {
        switch(recordState) {
        case .recording:
            recordLabel.text = "Recording..."
            stopRecordingButton.isEnabled = true
            recordButton.isEnabled = false
        case .notRecording:
            recordLabel.text = "Tab to Record"
            stopRecordingButton.isEnabled = false
            recordButton.isEnabled = true
        }
    }

}
