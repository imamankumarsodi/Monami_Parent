//
//  PlayAudioVC.swift
//  Monami
//
//  Created by abc on 05/01/19.
//  Copyright © 2019 mobulous. All rights reserved.
//

import UIKit
import AVFoundation
import SwiftSiriWaveformView
import MediaPlayer

class PlayAudioVC: UIViewController {
    
    //MARK: - Outlets
    @IBOutlet weak var lblRecordingTime: UILabel!
    @IBOutlet weak var audioView: SwiftSiriWaveformView!
    @IBOutlet weak var btnPlayRef: UIButton!
    //MARK: - Variables
    
    var audioURLString = String()
    var audioUrl: URL!
    var isPlaying = false
    var player:AVPlayer?
    var timer:Timer?
    var timerCount:Timer?
    var change:CGFloat = 0.01
    let macroObj = MacrosForAll.sharedInstanceMacro
    //******* Variables for lableTimer
    var durationString = String()
    var count = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        initialSetup()
        // Do any additional setup after loading the view.
    }
    
    
    //MARK: - Actions, Gestures
    
    //TODO: Actions
    @IBAction func play_recording(_ sender: Any)
    {
        playAudioFromAPI()
    }
    @IBAction func btnBackTapped(_ sender: Any)
    {
        stopAudioPlaying()
    }
    //TODO: Gestures
    @objc internal func refreshAudioView(_:Timer) {
        if self.audioView.amplitude <= self.audioView.idleAmplitude || self.audioView.amplitude > 1.0 {
            self.change *= -1.0
        }
        // Simply set the amplitude to whatever you need and the view will update itself.
        self.audioView.amplitude += self.change
    }
    @objc func stopAudioPlayer(_ notification: Notification){
        stopAudioPlaying()
    }
    
}

//MARK: - Extension Methods
extension PlayAudioVC{
    func initialSetup(){
        NotificationCenter.default.addObserver(self,selector:#selector(PlayAudioVC.stopAudioPlayer(_:)),name:NSNotification.Name(rawValue: "STOPAUDIOPLAYER"),object: nil)
        if audioURLString != ""{
            audioUrl = NSURL(string: audioURLString) as! URL
            if audioUrl != nil{
                let asset = AVAsset(url: audioUrl)
                let duration = asset.duration
                let durationTime = CMTimeGetSeconds(duration)
                let count = Int(ceil(durationTime))
                if count<10{
                    durationString = "00:0\(count)"
                    lblRecordingTime.text = durationString
                }else{
                    durationString = "00:\(count)"
                    lblRecordingTime.text = durationString
                }
            }
        }
    }
    func stopAudioPlaying(){
        if(isPlaying)
        {
            player!.pause()
            timerCount?.invalidate()
            timerCount = nil
            timer?.invalidate()
            timer = nil
            btnPlayRef.setImage(#imageLiteral(resourceName: "pause"), for: .normal)
            isPlaying = false
            audioView.amplitude = 0.0
            lblRecordingTime.text = durationString
        }
        self.navigationController?.popViewController(animated: true)
    }
    func playAudioFromAPI(){
        if audioURLString != ""{
            if(isPlaying)
            {
                player!.pause()
                timerCount?.invalidate()
                timerCount = nil
                timer?.invalidate()
                timer = nil
                btnPlayRef.setImage(#imageLiteral(resourceName: "pause"), for: .normal)
                btnPlayRef.setTitle(" tap to play".localized(), for: .normal)
                isPlaying = false
                audioView.amplitude = 0.0
                lblRecordingTime.text = durationString
            }
            else
            {
                if audioUrl != nil
                {
                    let playerItem:AVPlayerItem = AVPlayerItem(url: audioUrl!)
                    player = AVPlayer(playerItem: playerItem)
                    player!.play()
                    let asset = AVAsset(url: audioUrl)
                    let duration = asset.duration
                    let durationTime = CMTimeGetSeconds(duration)
                    count = Int(ceil(durationTime))
                    countDownTimer()
                    timer = Timer.scheduledTimer(timeInterval: 0.009, target: self, selector: #selector(self.refreshAudioView(_:)), userInfo: nil, repeats: true)
                    btnPlayRef.setImage(#imageLiteral(resourceName: "playAudio"),for: .normal)
                    btnPlayRef.setTitle(" tap to stop".localized(), for: .normal)
                    isPlaying = true
                }
                else
                {
                    _ = SweetAlert().showAlert(macroObj.appName, subTitle: MacrosForAll.VALIDMESSAGE.AudioMissing.rawValue.localized(), style: AlertStyle.error)
                }
            }
            
        }else{
            _ = SweetAlert().showAlert(macroObj.appName, subTitle: MacrosForAll.VALIDMESSAGE.AudioMissing.rawValue.localized(), style: AlertStyle.error)
        }
    }
    
    //TODO: COUNTER FOR WAVE AND AUDIO TIME
    func countDownTimer(){
        timerCount = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(self.update), userInfo: nil, repeats: true)
    }
    @objc func update() {
        if(count > 0) {
            count = count - 1
            if count<10{
                lblRecordingTime.text = "00:0\(count)"
            }else{
                lblRecordingTime.text = "00:\(count)"
            }
        }
        else{
            timerCount?.invalidate()
            timerCount = nil
            timer?.invalidate()
            timer = nil
            lblRecordingTime.text = durationString
            btnPlayRef.setImage(#imageLiteral(resourceName: "pause"),for: .normal)
            btnPlayRef.setTitle(" tap to play".localized(), for: .normal)
            audioView.amplitude = 0.0
            isPlaying = false
        }
    }
}
 
