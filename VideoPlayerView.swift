//
//  VideoPlayerView.swift
//  MyYouTube
//
//  Created by Elf on 01.08.17.
//  Copyright © 2017 Elf. All rights reserved.
//

import UIKit
import AVFoundation

class VideoPlayerView: UIView {
    var player: AVPlayer?
    
    let activityIndicatorView: UIActivityIndicatorView = {
        let aiv = UIActivityIndicatorView(activityIndicatorStyle: .whiteLarge)
        aiv.translatesAutoresizingMaskIntoConstraints = false
        aiv.startAnimating()
        return aiv
    }()
    
    let controlContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(white: 0, alpha: 1)
        return view
    }()
    
    let pausePlayButton: UIButton = {
        let btn = UIButton(type: .custom)
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.addTarget(self, action: #selector(handlePausePlay), for: .touchUpInside)
        btn.setBackgroundImage(#imageLiteral(resourceName: "pause"), for: .normal)
        btn.isHidden = true
        return btn
    }()
    
    var isPlaying = false
    
    func handlePausePlay() {
        if isPlaying {
            player?.pause()
            pausePlayButton.setBackgroundImage(#imageLiteral(resourceName: "play"), for: .normal)
        } else {
            player?.play()
            pausePlayButton.setBackgroundImage(#imageLiteral(resourceName: "pause"), for: .normal)
        }
        
        isPlaying = !isPlaying
    }
    
    let videoDurationLabel: UILabel = {
        let label = UILabel()
        label.text = "00:00"
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.boldSystemFont(ofSize: 13)
        return label
    }()
    
    let videoProgressLabel: UILabel = {
        let label = UILabel()
        label.text = "00:00"
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.boldSystemFont(ofSize: 13)
        return label
    }()
    
    lazy var videoSlider: UISlider = {
        let slider = UISlider()
        slider.translatesAutoresizingMaskIntoConstraints = false
        slider.minimumTrackTintColor = .red
        slider.maximumTrackTintColor = .white
        slider.setThumbImage(#imageLiteral(resourceName: "slider_thumb"), for: .normal)
        
        slider.addTarget(self, action: #selector(handleSliderChange), for: .valueChanged)
        return slider
    }()
    
    func handleSliderChange() {
        if let duration = player?.currentItem?.duration {
            let totalSeconds = CMTimeGetSeconds(duration)
            let value = Float64(videoSlider.value) * totalSeconds
            
            let seekTime = CMTime(value: CMTimeValue(value), timescale: 1)
            player?.seek(to: seekTime, completionHandler: {(completedSeek) in })
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .black
        setupPlayerView()
        setupGradientLayer()
        
        controlContainerView.frame = frame
        addSubview(controlContainerView)
        addSubview(activityIndicatorView)
        
        activityIndicatorView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        activityIndicatorView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        
        controlContainerView.addSubview(pausePlayButton)
        pausePlayButton.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        pausePlayButton.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        pausePlayButton.widthAnchor.constraint(equalToConstant: 50).isActive = true
        pausePlayButton.heightAnchor.constraint(equalToConstant: 50).isActive = true

        controlContainerView.addSubview(videoProgressLabel)
        videoProgressLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: 8).isActive = true
        videoProgressLabel.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        videoProgressLabel.widthAnchor.constraint(equalToConstant: 50).isActive = true
        videoProgressLabel.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        controlContainerView.addSubview(videoDurationLabel)
        videoDurationLabel.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        videoDurationLabel.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        videoDurationLabel.widthAnchor.constraint(equalToConstant: 50).isActive = true
        videoDurationLabel.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        controlContainerView.addSubview(videoSlider)
        videoSlider.rightAnchor.constraint(equalTo: videoDurationLabel.leftAnchor, constant: -8).isActive = true
        videoSlider.leftAnchor.constraint(equalTo: videoProgressLabel.rightAnchor, constant: -4).isActive = true
        videoSlider.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        videoSlider.heightAnchor.constraint(equalToConstant: 30).isActive = true
        videoSlider.centerYAnchor.constraint(equalTo: videoDurationLabel.centerYAnchor).isActive = true

        videoProgressLabel.centerYAnchor.constraint(equalTo: videoSlider.centerYAnchor).isActive = true
    }
    
    private func setupPlayerView() {
        let urlString = "https://firebasestorage.googleapis.com/v0/b/gameofchats-762ca.appspot.com/o/message_movies%2F12323439-9729-4941-BA07-2BAE970967C7.mov?alt=media&token=3e37a093-3bc8-410f-84d3-38332af9c726"
        if let url = URL(string: urlString) {
            player = AVPlayer(url: url)
            let playerLayer = AVPlayerLayer(player: player)
            self.layer.addSublayer(playerLayer)
            playerLayer.frame = self.frame
            
            player?.addObserver(self, forKeyPath: "currentItem.loadedTimeRanges", options: .new, context: nil)
            
            let interval = CMTime(value: 1, timescale: 2)
            player?.addPeriodicTimeObserver(forInterval: interval, queue: DispatchQueue.main, using: { (progressTime) in
                let seconds = CMTimeGetSeconds(progressTime)
                let secondsStr = String(format: "%02d", Int(seconds) % 60)
                let minutesStr = String(format: "%02d:", Int(seconds / 60))
                
                self.videoProgressLabel.text = minutesStr + secondsStr
                
                if let duration = self.player?.currentItem?.duration {
                    let durationSeconds = CMTimeGetSeconds(duration)
                    self.videoSlider.value = Float(seconds / durationSeconds)
                }
            })
            
            player?.play()
        }
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        // Video end loading and start playing
        if keyPath == "currentItem.loadedTimeRanges" {
            activityIndicatorView.stopAnimating()
            controlContainerView.backgroundColor = .clear
            pausePlayButton.isHidden = false
            isPlaying = true
            
            if let duration = player?.currentItem?.duration {
                let seconds = CMTimeGetSeconds(duration)
                let secondsStr = String(format: "%02d", Int(seconds) % 60)
                let minutesStr = String(format: "%02d:", Int(seconds / 60))
                videoDurationLabel.text = minutesStr + secondsStr
            }
        }
    }
    
    private func setupGradientLayer() {
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = bounds
        
        gradientLayer.colors = [UIColor.clear.cgColor, UIColor.black.cgColor]
        gradientLayer.locations = [0.7, 1.1]
        controlContainerView.layer.addSublayer(gradientLayer)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
