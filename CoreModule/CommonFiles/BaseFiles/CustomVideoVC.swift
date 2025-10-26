//
//  CustomVideoVC.swift
//  NextPeak
//
//  Created by SCT on 22/05/25.
//  Copyright © 2025 Balakrishnan Ponraj. All rights reserved.
//

import UIKit
import AVFoundation


class CustomVideoVC: UIViewController {

    var player: AVPlayer!
    var playerLayer: AVPlayerLayer!
    let videoView = UIView()
//    var VideoURL = "http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/Sintel.mp4"
    var VideoURL = ""
    
    let BackIcon = UIImageView()

    let playPauseButton = UIButton(type: .system)
    let skipBackButton = UIButton(type: .system)
    let skipForwardButton = UIButton(type: .system)

    let VedioSlider = UISlider()
    let CurrentVideoTime = UILabel()
    let TotalVideoDuration = UILabel()
    let ZoomLable = UILabel()
    let ZoomLableBackGround = UIView()
    let ScreenLockIcon = UIImageView()
    let ScreenLockBack = UIView()
    let ScreenRotateIcon = UIImageView()
    var SliderStack = UIStackView()
    
    var VolumeStack = UIStackView()
    var VolumeSlider = UISlider()
    var VolumePercent = UILabel()
    var VolumeTitle = UILabel()
    
    var BrightnessStack = UIStackView()
    var BrightnessSlider = UISlider()
    var BrightnessPercent = UILabel()
    var BrightnessTitle = UILabel()
    
    
    var isplaying = false
    var totalTime: TimeInterval = 0.0
    var currentTime: TimeInterval = 0.0
    var currentVolume: TimeInterval = 0.0
    var currentBrigtness: TimeInterval = 0.0
    var IsControlsHidden = false
    var IsVolumeisHidden = false
    var IsBrigtNessisHidden = false
    var IsLeftSideScreen = false
    
    var Animator : UIViewPropertyAnimator?


    var pinchScale: CGFloat = 1.0

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        self.setupVideoView()
        self.SetBackIcon()
        self.setupPlayer()
        self.setupPinchGesture()                   // Zoom
        self.setupPlayPauseButton()               // Play Button
        self.setupSkipButtons()                  // Add skip buttons
        self.SetVedioSlider()                   // Add SetVedioSlider buttons
        self.SetScreenLockIcon()
        self.SetScreenRotationIcon()          // Add ScreenRotation buttons
        self.SetVolumeSlider()               // Add SetVolumeSlider
        self.SetBrightnessSlider()          // Add SetBrightnessSlider buttons
        self.TouchOnScreen()
        self.HideControls(IsHide: false)
        
        self.SwipgestureInit()
        self.HideVolumeControls(IsHide: true)
        self.HideBrightnessControls(IsHide: true)

    }
    
    class func InitWithStory(videoUrl: String) -> CustomVideoVC {
        let VC : CustomVideoVC = UIStoryboard.NewStoryboard.instantiateViewController()
        VC.VideoURL = videoUrl
        return VC
    }

    func setupVideoView() {
        videoView.frame = view.bounds
        videoView.backgroundColor = .black
        videoView.isUserInteractionEnabled = true
        view.addSubview(videoView)
    }

    func setupPlayer() {
        guard let url = URL(string: self.VideoURL) else { return }
        player = AVPlayer(url: url)
        playerLayer = AVPlayerLayer(player: player)
        playerLayer.frame = videoView.bounds
        playerLayer.videoGravity = .resizeAspect
        videoView.layer.addSublayer(playerLayer)
        
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        videoView.frame = view.bounds
        playerLayer.frame = videoView.bounds
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        player.pause()
    }
    
    
//    override func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(animated)

        // ViewController is appearing
//        if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
//            appDelegate.setSemantic(IsfromCalculation: false)
//        }
//    }

    
    
}


// MARK: Back Button
extension CustomVideoVC {
    
    func SetBackIcon() {
        self.BackIcon.image = UIImage(resource: .backIcon)
        self.BackIcon.tintColor = .white
        self.BackIcon.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        self.BackIcon.clipsToBounds = true
        self.BackIcon.frame = CGRect(x: 10, y: ((self.view.frame.width)/5), width: 35, height: 35)
        self.BackIcon.autoresizingMask = [.flexibleTopMargin,
                                                  .flexibleBottomMargin,
                                                  .flexibleLeftMargin,
                                                  .flexibleRightMargin]
        self.BackIcon.isRoundCorner = true
        self.BackIcon.isUserInteractionEnabled = true
        
        self.BackIcon.addTap {
            //            self.navigationController?.popViewController(animated: true)
            AppDelegate.AppUtility.lockOrientation(UIInterfaceOrientationMask.portrait)
            
            let orientation = UIInterfaceOrientation.portrait.rawValue
            UIDevice.current.setValue(orientation, forKey: "orientation")
            self.ScreenRotateIcon.image = UIImage(systemName: "rectangle.portrait.rotate")
            self.SetZoom()
            guard let windowScene = self.view.window?.windowScene as? UIWindowScene else { return }
            windowScene.requestGeometryUpdate(.iOS(interfaceOrientations: .portrait))
            
            self.player.responds(to: #selector(getter: UIDevice.current.orientation))
            
            Shared.Instance.IsFromVideoBack = true
            
            self.dismiss(animated: true)
        }

        self.view.addSubview(BackIcon)
        
        
    }

    
}


// MARK: Play Controllor Buttons

extension CustomVideoVC{
    
    func setupPlayPauseButton() {
        // Basic button styling
        playPauseButton.setImage(UIImage(systemName: "play.fill"), for: .normal)
        playPauseButton.imageView?.frame = CGRect(x: 0, y: 0, width: 40, height: 40)
        playPauseButton.tintColor = .white
        playPauseButton.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        playPauseButton.layer.cornerRadius = 25
        playPauseButton.clipsToBounds = true
        playPauseButton.frame = CGRect(x: (view.bounds.width - 50) / 2,
                                       y: (view.bounds.height - 50) / 2,
                                       width: 50,
                                       height: 50)

        playPauseButton.addTarget(self, action: #selector(togglePlayPause), for: .touchUpInside)
        playPauseButton.autoresizingMask = [.flexibleLeftMargin, .flexibleRightMargin,
                                            .flexibleTopMargin, .flexibleBottomMargin]
        view.addSubview(playPauseButton)
    }

    @objc func togglePlayPause() {
        if player.timeControlStatus == .playing {
            player.pause()
            playPauseButton.setImage(UIImage(systemName: "play.fill"), for: .normal)
            isplaying = false
            GetDuriation()
            self.HideControls(IsHide: false)

        } else {
            player.play()
            playPauseButton.setImage(UIImage(systemName: "pause.fill"), for: .normal)
            isplaying = true
            GetDuriation()
            
        }
    }
    
    
    
    func setupSkipButtons() {
        skipBackButton.setImage(UIImage(systemName: "gobackward.10"), for: .normal)
        skipBackButton.tintColor = .white
        skipBackButton.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        skipBackButton.addTarget(self, action: #selector(skipBackward), for: .touchUpInside)
        
        let LongBackPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(LongskipBackward(_ :)))
        LongBackPressGesture.minimumPressDuration = 0.5
        skipBackButton.addGestureRecognizer(LongBackPressGesture)
        
        skipBackButton.frame = CGRect(x: (view.bounds.width - 250) / 2,
                                      y: (view.bounds.height - 35) / 2,
                                       width: 40,
                                       height: 40)
        skipBackButton.isRoundCorner = true

        skipBackButton.autoresizingMask = [.flexibleLeftMargin, .flexibleRightMargin,
                                            .flexibleTopMargin, .flexibleBottomMargin]

        view.addSubview(skipBackButton)
        
        skipForwardButton.setImage(UIImage(systemName: "goforward.10"), for: .normal)
        skipForwardButton.tintColor = .white
        skipForwardButton.backgroundColor = UIColor.black.withAlphaComponent(0.5)

        skipForwardButton.addTarget(self, action: #selector(skipForward), for: .touchUpInside)
        
        let LongPressForwardGesture = UILongPressGestureRecognizer(target: self, action: #selector(LongskipForward(_ :)))
        LongPressForwardGesture.minimumPressDuration = 0.5
        skipForwardButton.addGestureRecognizer(LongPressForwardGesture)

        skipForwardButton.frame = CGRect(x: (view.bounds.width + 150) / 2,
                                         y: (view.bounds.height - 35) / 2,
                                       width: 40,
                                       height: 40)
        skipForwardButton.isRoundCorner = true
        
        skipForwardButton.autoresizingMask = [.flexibleLeftMargin, .flexibleRightMargin,
                                            .flexibleTopMargin, .flexibleBottomMargin]

        view.addSubview(skipForwardButton)
    }

    @objc func skipBackward() {
        let currentTime = CMTimeGetSeconds(player.currentTime())
        let newTime = max(currentTime - 10.0, 0)
        player.seek(to: CMTime(seconds: newTime, preferredTimescale: 600))
    }
    
    @objc func LongskipBackward(_ gesture: UILongPressGestureRecognizer) {
        
        Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true, block: { [weak self] timer in
            let currentTime = CMTimeGetSeconds(self!.player.currentTime())
            let newTime = max(currentTime - 5.0, 0)
            self?.player.seek(to: CMTime(seconds: newTime, preferredTimescale: 600))
            
            if gesture.state != .began {
                timer.invalidate()
                return
            }
        })
        
    }

    @objc func skipForward() {
        if let duration = player.currentItem?.duration {
            let currentTime = CMTimeGetSeconds(player.currentTime())
            let videoDuration = CMTimeGetSeconds(duration)
            let newTime = min(currentTime + 10.0, videoDuration)
            player.seek(to: CMTime(seconds: newTime, preferredTimescale: 600))
        }
    }
    
    
    @objc func LongskipForward(_ gesture: UILongPressGestureRecognizer) {
        
        Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true, block: { [weak self] timer in
            let currentTime = CMTimeGetSeconds(self!.player.currentTime())
            let newTime = max(currentTime + 5.0, 0)
            self?.player.seek(to: CMTime(seconds: newTime, preferredTimescale: 600))
            
            if gesture.state != .began {
                timer.invalidate()
                return
            }
        })
        
    }


}



// MARK: Zoom Setup
extension CustomVideoVC {
    
    func ZoomLableSetup() {
//        self.ZoomLable.frame = CGRect(x: (self.view.frame.width - 50)/2,
//                                      y: (self.view.frame.height - 50)/2,
//                                      width: 80,
//                                      height: 20)
        self.ZoomLable.frame = CGRect(x: 0, y: 0, width: 80, height: 40)
        self.ZoomLable.textColor = .white
        self.ZoomLable.font = .systemFont(ofSize: 20, weight: .bold)
        self.ZoomLable.textAlignment = .center
        self.ZoomLable.autoresizingMask = [.flexibleTopMargin,
                                                     .flexibleBottomMargin,
                                                     .flexibleLeftMargin,
                                                     .flexibleRightMargin]

        
        self.ZoomLableBackGround.frame = CGRect(x: (self.view.frame.width - 70)/2,
                                                y: (self.view.frame.height - 70)/2,
                                                width: 80,
                                                height: 40)
        self.ZoomLableBackGround.backgroundColor = .black.withAlphaComponent(0.5)
        self.ZoomLableBackGround.layer.cornerRadius = 5
        
        self.ZoomLable.isUserInteractionEnabled = false
        self.ZoomLableBackGround.isUserInteractionEnabled = false
        self.ZoomLableBackGround.autoresizingMask = [.flexibleTopMargin,
                                                     .flexibleBottomMargin,
                                                     .flexibleLeftMargin,
                                                     .flexibleRightMargin]
        
        self.ZoomLable.center = self.ZoomLableBackGround.center

        
        self.view.addSubview(ZoomLableBackGround)
        self.view.addSubview(ZoomLable)

        
        self.ZoomLable.isHidden = true
        self.ZoomLableBackGround.isHidden = true

    }
    
    func setupPinchGesture() {
        let pinchGesture = UIPinchGestureRecognizer(target: self, action: #selector(handlePinch(_:)))
        videoView.addGestureRecognizer(pinchGesture)
    }

    @objc func handlePinch(_ gesture: UIPinchGestureRecognizer) {
        guard gesture.view != nil else { return }
        
        self.HideControls(IsHide: true)
        self.HideVolumeControls(IsHide: true)
        self.HideBrightnessControls(IsHide: true)
        
        if gesture.state == .changed || gesture.state == .began {
            pinchScale *= gesture.scale
            pinchScale = max(0.5, min(pinchScale, 10.0)) // Restrict zoom between 1x and 4x
            playerLayer.setAffineTransform(CGAffineTransform(scaleX: pinchScale, y: pinchScale))
            gesture.scale = 1.0
            
            self.SetZoomPercentagelable(ZoomScale: Int((self.pinchScale/1.6)*100), IsHide: false)
            
            print("gesture.scale \(Int((pinchScale/1.6)*100))%")
        }else{
            SetZoomPercentagelable(ZoomScale: Int((pinchScale/1.6)*100),IsHide: true)
        }

        
    }

    
    func SetZoomPercentagelable(ZoomScale: Int,IsHide: Bool) {
        
        self.ZoomLable.text = "\(ZoomScale)%"
        self.ZoomLable.isHidden = IsHide
        self.ZoomLableBackGround.isHidden = IsHide
                        
    }

    
    
}

// MARK: Lock Screen
extension CustomVideoVC {
    
    func SetScreenLockIcon() {
        self.ScreenLockIcon.image = UIImage(systemName: "lock.open.fill")
        self.ScreenLockIcon.tintColor = .white
        
        self.ScreenLockIcon.frame = CGRect(x: (self.ScreenLockBack.frame.width)/2, y: (self.ScreenLockBack.frame.width)/2, width: 30, height: 30)
        
        self.ScreenLockBack.frame = CGRect(x: (self.view.frame.width - 50), y: ((self.view.frame.width)/5), width: 36, height: 36)
        self.ScreenLockBack.autoresizingMask = [.flexibleTopMargin,
                                                  .flexibleBottomMargin,
                                                  .flexibleLeftMargin,
                                                  .flexibleRightMargin]
        
        self.ScreenLockBack.backgroundColor = .black.withAlphaComponent(0.5)
        
        self.ScreenLockBack.isRoundCorner = true
        self.ScreenLockBack.isUserInteractionEnabled = true

        
        let TapGesture = UITapGestureRecognizer(target: self, action: #selector(LockScreen(_:)))
        TapGesture.numberOfTapsRequired = 1
        self.ScreenLockBack.addGestureRecognizer(TapGesture)
        
        let ViewTapGesture = UITapGestureRecognizer(target: self, action: #selector(ViewLock(_:)))
        ViewTapGesture.numberOfTapsRequired = 1
        self.view.addGestureRecognizer(ViewTapGesture)

        self.view.addSubview(ScreenLockBack)
        self.ScreenLockBack.addSubview(ScreenLockIcon)
        
    }
    
    @objc func LockScreen(_ gesture: UITapGestureRecognizer) {
        
        guard ((gesture.view as? UIView) != nil) else { return }
        
        if self.ScreenLockIcon.image == UIImage(systemName: "lock.open.fill") {
            self.ScreenLockIcon.image = UIImage(systemName: "lock.fill")
            self.videoView.isUserInteractionEnabled = false
            self.HideControls(IsHide: true)
            self.HideVolumeControls(IsHide: true)
            self.HideBrightnessControls(IsHide: true)
            self.ScreenLockIcon.isHidden = false
            self.ScreenLockBack.isHidden = false
                    
        }else{
            self.ScreenLockIcon.image = UIImage(systemName: "lock.open.fill")
            self.videoView.isUserInteractionEnabled = true
            self.HideControls(IsHide: false)

        }
    }
    
    @objc func ViewLock(_ gesture: UITapGestureRecognizer) {
                
        if !self.videoView.isUserInteractionEnabled {
            self.ScreenLockIcon.isHidden = !self.ScreenLockIcon.isHidden
            self.ScreenLockBack.isHidden = !self.ScreenLockBack.isHidden
                    
        }
    }
    

    
}


// MARK: Screen Rotation
extension CustomVideoVC {
    
    func SetScreenRotationIcon() {
        
        AppDelegate.AppUtility.lockOrientation(UIInterfaceOrientationMask.all)

        self.ScreenRotateIcon.image = UIImage(systemName: "rectangle.portrait.rotate")
        self.ScreenRotateIcon.tintColor = .white
        self.ScreenRotateIcon.backgroundColor = .black.withAlphaComponent(0.5)
//        self.ScreenRotateIcon.frame = CGRect(x: (self.view.frame.width - 50), y: ((self.view.frame.width)/5), width: 40, height: 40)
        self.ScreenRotateIcon.frame = CGRect(x: view.bounds.width - 50,
                                        y: (view.bounds.height - 50) / 1.25,
                                        width: 35,
                                        height: 35)
        self.ScreenRotateIcon.autoresizingMask = [.flexibleTopMargin,
                                                  .flexibleBottomMargin,
                                                  .flexibleLeftMargin,
                                                  .flexibleRightMargin]
        self.ScreenRotateIcon.isRoundCorner = true
        self.ScreenRotateIcon.isUserInteractionEnabled = true
        
        let TapGesture = UITapGestureRecognizer(target: self, action: #selector(RotateScreen(_:)))
        TapGesture.numberOfTapsRequired = 1
        self.ScreenRotateIcon.addGestureRecognizer(TapGesture)

        self.view.addSubview(ScreenRotateIcon)
        
        
    }
    
    

    @objc func RotateScreen(_ gesture: UITapGestureRecognizer) {
        
        guard ((gesture.view as? UIImageView) != nil) else { return }
        guard let windowScene = self.view.window?.windowScene as? UIWindowScene else { return }

        if windowScene.interfaceOrientation == .portrait {
            let orientation = UIInterfaceOrientation.landscapeRight.rawValue
            UIDevice.current.setValue(orientation, forKey: "orientation")
            self.ScreenRotateIcon.image = UIImage(systemName: "rectangle.landscape.rotate")
            SetZoom()

            windowScene.requestGeometryUpdate(.iOS(interfaceOrientations: .landscape))
            
        } else {
            let orientation = UIInterfaceOrientation.portrait.rawValue
            UIDevice.current.setValue(orientation, forKey: "orientation")
            self.ScreenRotateIcon.image = UIImage(systemName: "rectangle.portrait.rotate")
            SetZoom()
            
            windowScene.requestGeometryUpdate(.iOS(interfaceOrientations: .portrait))
        }
        
        self.player.responds(to: #selector(getter: UIDevice.current.orientation))
    }
    
    func SetZoom() {
        pinchScale = 1.0
        pinchScale = max(0.5, min(pinchScale, 10.0)) // Restrict zoom between 1x and 4x
        playerLayer.setAffineTransform(CGAffineTransform(scaleX: pinchScale, y: pinchScale))

    }

    
}


// MARK: Slider Setup
extension CustomVideoVC {
    
    func SetVedioSlider() {
                
        self.VedioSlider.minimumTrackTintColor = .red
        self.VedioSlider.addTarget(self, action: #selector(audioTime), for: .valueChanged)
        self.setSliderThumbTintColor(.white, SliderName: self.VedioSlider)
        self.SetVideoDuration()
        self.ZoomLableSetup()
        
    }
    
    
    func SetVideoDuration() {
        
        self.CurrentVideoTime.text = "00:00"
        self.CurrentVideoTime.font = .systemFont(ofSize: 12)
        self.CurrentVideoTime.textColor = .white
        self.CurrentVideoTime.backgroundColor = .black.withAlphaComponent(0.5)
        self.CurrentVideoTime.isRoundCorner = true
        
        self.TotalVideoDuration.text = "00:00"
        self.TotalVideoDuration.font = .systemFont(ofSize: 12)
        self.TotalVideoDuration.textColor = .white
        self.TotalVideoDuration.backgroundColor = .black.withAlphaComponent(0.5)
        self.TotalVideoDuration.isRoundCorner = true

        self.SliderStack.axis = .horizontal
        self.SliderStack.distribution = .fillEqually
        self.SliderStack.alignment = .center
        self.SliderStack = UIStackView(arrangedSubviews: [CurrentVideoTime, VedioSlider, TotalVideoDuration])
        self.SliderStack.spacing = 10

        self.SliderStack.frame = CGRect(x: 0,
                                        y: (view.bounds.height - 50) / 1.19,
                                        width: view.bounds.width,
                                        height: 50)
        self.SliderStack.autoresizingMask = [.flexibleTopMargin,
                                             .flexibleRightMargin,
                                             .flexibleLeftMargin,
                                             .flexibleBottomMargin,
                                             .flexibleWidth]
        self.view.addSubview(self.SliderStack)
        

    }
            

    func updateProgress() {
        guard player != nil else { return }
        currentTime = player.currentItem?.currentTime().seconds ?? 0.0
    }
    
    @objc func audioTime() {
        player.pause()
        playPauseButton.setImage(UIImage(systemName: "play.fill"), for: .normal)
        isplaying = false
        self.HideControls(IsHide: false)
        
        DispatchQueue.main.asyncAfter(deadline: .now()) {
            self.updateProgress()
            self.CurrentVideoTime.text = self.timeString(time: self.currentTime)
        }
        
        let progress = self.VedioSlider.value
        let seekTime = CMTime(seconds: Double(progress), preferredTimescale: 60000)
        player.seek(to: seekTime, toleranceBefore: .zero, toleranceAfter: .zero) { [weak self] _ in
            guard let `self` = self else { return }
//            print("Player time after seeking: \(CMTimeGetSeconds(self.player.currentTime()))")
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                self.player.play()
                self.playPauseButton.setImage(UIImage(systemName: "pause.fill"), for: .normal)
                self.isplaying = true
                self.GetDuriation()
                
            }
            
        }

    }
    
    func timeString(time: TimeInterval) -> String {
        let minute = Int(time) / 60
        let seconds = Int(time) % 60
        return String(format: "%02d:%02d", minute, seconds)
    }

    
    func GetDuriation() {
        
        if let duration = player.currentItem?.asset.duration {
            let seconds = CMTimeGetSeconds(duration)

            self.SetSlider(MaxValue: Float(seconds), SliderName: self.VedioSlider)

            DispatchQueue.main.async {
                
                Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { [weak self] timer in
                    guard let self = self, let duration = self.player?.currentItem?.duration else {
                        timer.invalidate()
                        return
                    }
                    
                    self.updateProgress()
                    self.CurrentVideoTime.text = self.timeString(time: currentTime)
                    self.CurrentVideoTime.font = .systemFont(ofSize: 12)
                    
                    self.TotalVideoDuration.text = self.timeString(time: seconds)
                    self.CurrentVideoTime.font = .systemFont(ofSize: 12)

                    // Update the slider value here
                    self.Animator = UIViewPropertyAnimator(duration: 0.2, curve: .easeInOut) {
                        self.VedioSlider.value = Float(self.currentTime)
                        self.view.layoutIfNeeded()
                    }
                    self.Animator?.startAnimation()
                    if currentTime >= seconds || !self.isplaying {
                        DispatchQueue.main.async {
                            timer.invalidate()
                        }
                    }
                    
                }
            }
        }
    }

    
}



// MARK: Volume Setup
extension CustomVideoVC {
    
    func SetVolumeSlider() {
                
        self.currentVolume = UserDefaults.standard.double(forKey: "Volume")
        self.VolumeSlider.minimumTrackTintColor = .red
        self.VolumeSlider.transform = CGAffineTransform(rotationAngle: .pi * 1.5)
        
        self.SetVolumeDuration()
        self.setSliderThumbTintColor(.white, SliderName: self.VolumeSlider)
        self.SetSlider(MaxValue: 100, SliderName: self.VolumeSlider)
        
        Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { [weak self] timer in
            // Update the slider value here
            self?.Animator = UIViewPropertyAnimator(duration: 0.2, curve: .easeInOut) {
                
                self?.VolumeSlider.value = Float(self?.currentVolume ?? 0.0)
                self?.VolumePercent.text = "\(Int(self?.VolumeSlider.value ?? 0.0))%"
                self?.view.layoutIfNeeded()
            }
            self?.Animator?.startAnimation()
            
            if Float(self?.currentVolume ?? 0.0) == self?.VolumeSlider.value {
                DispatchQueue.main.async {
                    timer.invalidate()
                }
            }
            
        }

        
        self.VolumeSlider.addTarget(self, action: #selector(SetVolume), for: .valueChanged)
        
    }
    
    
    func SetVolumeDuration() {
        
        self.VolumePercent.text = "0%"
        self.VolumePercent.font = .systemFont(ofSize: 16, weight: .bold)
        self.VolumePercent.textAlignment = .center
        self.VolumePercent.textColor = .white
        
        self.VolumeTitle.text = "Volume"
        self.VolumeTitle.font = .systemFont(ofSize: 16, weight: .bold)
        self.VolumeTitle.textAlignment = .center
        self.VolumeTitle.textColor = .white
        
        NSLayoutConstraint.activate([
            self.VolumePercent.heightAnchor.constraint(equalToConstant: self.VolumePercent.intrinsicContentSize.height),
            self.VolumeTitle.heightAnchor.constraint(equalToConstant: self.VolumeTitle.intrinsicContentSize.height),
        ])
                
        self.VolumeStack = UIStackView(arrangedSubviews: [VolumePercent, VolumeSlider, VolumeTitle])
        self.VolumeStack.axis = .vertical
        self.VolumeStack.distribution = .fill
//        self.VolumeStack.backgroundColor = .yellow
        

        self.VolumeStack.frame = CGRect(x: -30,
                                        y: (view.bounds.width - 80),
                                        width: (view.bounds.width - 220),
                                        height: (view.bounds.width - 170))
        self.VolumeStack.autoresizingMask = [.flexibleTopMargin,
                                             .flexibleRightMargin,
                                             .flexibleBottomMargin]
        self.view.addSubview(self.VolumeStack)
        

    }
    
    
    @objc func SetVolume() {
        self.VolumePercent.text = "\(Int(self.VolumeSlider.value))%"
        self.player.volume = Float(self.VolumeSlider.value)
        self.currentVolume = TimeInterval(Int(self.VolumeSlider.value))
        UserDefaults.standard.set(Int(self.VolumeSlider.value), forKey: "Volume")

    }
    

    
}


// MARK: Brigthness Setup
extension CustomVideoVC {
    
    func SetBrightnessSlider() {
                
        self.currentBrigtness = UIScreen.main.brightness * 100
        
        self.BrightnessSlider.minimumTrackTintColor = .red
        self.BrightnessSlider.transform = CGAffineTransform(rotationAngle: .pi * 1.5)
        
        self.SetBrightnessDuration()
        self.setSliderThumbTintColor(.white, SliderName: self.BrightnessSlider)
        self.SetSlider(MaxValue: 100, SliderName: self.BrightnessSlider)
        
        
        Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { [weak self] timer in
            // Update the slider value here
            self?.Animator = UIViewPropertyAnimator(duration: 0.2, curve: .easeInOut) {
                
                self?.BrightnessSlider.value = Float(self?.currentBrigtness ?? 0.0)
                self?.BrightnessPercent.text = "\(Int(self?.BrightnessSlider.value ?? 0.0))%"
                self?.view.layoutIfNeeded()
            }
            self?.Animator?.startAnimation()
            
            if Float(self?.currentBrigtness ?? 0.0) == self?.BrightnessSlider.value {
                DispatchQueue.main.async {
                    timer.invalidate()
                }
            }
            
        }

        self.BrightnessSlider.addTarget(self, action: #selector(SetBrightness), for: .valueChanged)
        
    }
    
    
    func SetBrightnessDuration() {
        
        self.BrightnessPercent.text = "0%"
        self.BrightnessPercent.font = .systemFont(ofSize: 16, weight: .bold)
        self.BrightnessPercent.textAlignment = .center
        self.BrightnessPercent.textColor = .white
        
        self.BrightnessTitle.text = "Brightness"
        self.BrightnessTitle.font = .systemFont(ofSize: 16, weight: .bold)
        self.BrightnessTitle.textAlignment = .center
        self.BrightnessTitle.textColor = .white
                
        NSLayoutConstraint.activate([
            self.BrightnessPercent.heightAnchor.constraint(equalToConstant: self.BrightnessPercent.intrinsicContentSize.height),
            self.BrightnessTitle.heightAnchor.constraint(equalToConstant: self.BrightnessTitle.intrinsicContentSize.height),
        ])

        self.BrightnessStack = UIStackView(arrangedSubviews: [BrightnessPercent, BrightnessSlider, BrightnessTitle])
        self.BrightnessStack.axis = .vertical
        self.BrightnessStack.distribution = .fill
//        self.BrightnessStack.backgroundColor = .yellow

        self.BrightnessStack.frame = CGRect(x: view.bounds.width - 150,
                                        y: (view.bounds.width - 80),
                                        width: (view.bounds.width - 220),
                                        height: (view.bounds.width - 170))
        self.BrightnessStack.autoresizingMask = [.flexibleTopMargin,
                                                 .flexibleLeftMargin,
                                                 .flexibleBottomMargin]
        self.view.addSubview(self.BrightnessStack)
        

    }

    @objc func SetBrightness() {
        self.BrightnessPercent.text = "\(Int(self.BrightnessSlider.value))%"
        self.currentBrigtness = TimeInterval(Int(self.BrightnessSlider.value))
        UIScreen.main.brightness = CGFloat(Float(self.BrightnessSlider.value)/100)
                                     
    }

    
}

// MARK: Swip Gesture Setup
extension CustomVideoVC {
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {

        let touch = touches.first
        if let location = touch?.location(in: self.view) {
        
            let halfScreenWidth = UIScreen.main.bounds.width / 2
            if location.x < halfScreenWidth {
                self.IsLeftSideScreen = true
            } else {
                self.IsLeftSideScreen = false
            }
        }
    }

    
    func SwipgestureInit() {
        
        self.videoView.isUserInteractionEnabled = true
        let BrigtnesSwipUPGesture = UISwipeGestureRecognizer(target: self, action: #selector(BrigtnessSwip(_:)))
        BrigtnesSwipUPGesture.direction = .up
        self.videoView.addGestureRecognizer(BrigtnesSwipUPGesture)
        
        self.videoView.isUserInteractionEnabled = true
        let BrigtnesDownSwipGesture = UISwipeGestureRecognizer(target: self, action: #selector(BrigtnessSwip(_:)))
        BrigtnesDownSwipGesture.direction = .down
        self.videoView.addGestureRecognizer(BrigtnesDownSwipGesture)
        
    }
        
        
    @objc func BrigtnessSwip(_ gesture: UISwipeGestureRecognizer) {
        
        guard self.isplaying else { return }

        self.HideControls(IsHide: true)
        
        if !self.IsLeftSideScreen {
            self.HideVolumeControls(IsHide: false)
            self.HideBrightnessControls(IsHide: true)

            if gesture.direction == .up {
                ChangeVolume(IsIncrease: true, gesture)
            }else if gesture.direction == .down{
                self.HideVolumeControls(IsHide: false)
            }

        }else {
            self.HideVolumeControls(IsHide: true)
            self.HideBrightnessControls(IsHide: false)

            if gesture.direction == .up {
                ChangeBrigtness(IsIncrease: true)
            }else if gesture.direction == .down {
                ChangeBrigtness(IsIncrease: false)
            }

        }
        
    }
    
  func ChangeVolume(IsIncrease: Bool,_ gesture: UISwipeGestureRecognizer) {
      
//      if IsIncrease {
//          self.currentVolume += 10.0
//      }else {
//          self.currentVolume -= 10.0
//      }

      
      Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { [weak self] timer in
          // Update the slider value here
          self?.Animator = UIViewPropertyAnimator(duration: 0.2, curve: .easeInOut) {
              
              self?.VolumeSlider.value = Float(self?.currentVolume ?? 0.0)
              self?.VolumePercent.text = "\(Int(self?.VolumeSlider.value ?? 0.0))%"
              self?.view.layoutIfNeeded()
          }
          self?.Animator?.startAnimation()
          
          if Float(self?.currentVolume ?? 0.0) == self?.VolumeSlider.value {
              DispatchQueue.main.async {
                  timer.invalidate()
              }
          }
          
      }
      
      
      self.VolumePercent.text = "\(Int(self.VolumeSlider.value))%"
      self.player.volume = Float(self.VolumeSlider.value)
      UserDefaults.standard.set(Int(self.VolumeSlider.value), forKey: "Volume")

    }
    
    
  func ChangeBrigtness(IsIncrease: Bool) {
      
//      if IsIncrease {
//          self.currentBrigtness += 10.0
//      }else {
//          self.currentBrigtness -= 10.0
//      }
      
      Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { [weak self] timer in
          // Update the slider value here
          self?.Animator = UIViewPropertyAnimator(duration: 0.2, curve: .easeInOut) {
              
              self?.BrightnessSlider.value = Float(self?.currentBrigtness ?? 0.0)
              self?.BrightnessPercent.text = "\(Int(self?.BrightnessSlider.value ?? 0.0))%"
              self?.view.layoutIfNeeded()
          }
          self?.Animator?.startAnimation()
          
          if Float(self?.currentBrigtness ?? 0.0) == self?.BrightnessSlider.value {
              DispatchQueue.main.async {
                  timer.invalidate()
              }
          }
          
      }
      
      
      self.BrightnessPercent.text = "\(Int(self.BrightnessSlider.value))%"
      UIScreen.main.brightness = CGFloat(Float(self.BrightnessSlider.value)/100)

    }

    
    
    func TouchOnScreen() {
        self.videoView.isUserInteractionEnabled = true
        let TapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTouch(_:)))
        TapGesture.numberOfTapsRequired = 1
        self.videoView.addGestureRecognizer(TapGesture)
    }
    
    @objc func handleTouch(_ gesture: UITapGestureRecognizer) {
        
        guard gesture.view != nil else { return }
        
        guard self.isplaying else {
            self.HideControls(IsHide: false)
            return
        }
        
        self.HideControls(IsHide: !self.IsControlsHidden)
        
        self.HideVolumeControls(IsHide: true)
        self.HideBrightnessControls(IsHide: true)
        
    }


    
}

// MARK: Common Func
extension CustomVideoVC {
    
    func HideControls(IsHide: Bool) {
        self.IsControlsHidden = IsHide
        self.BackIcon.isHidden = IsHide
        self.playPauseButton.isHidden = IsHide
        self.skipBackButton.isHidden = IsHide
        self.skipForwardButton.isHidden = IsHide
        
        self.VedioSlider.isHidden = IsHide
        self.CurrentVideoTime.isHidden = IsHide
        self.TotalVideoDuration.isHidden = IsHide
        self.ScreenRotateIcon.isHidden = IsHide
        self.SliderStack.isHidden = IsHide
        self.ScreenLockIcon.isHidden = IsHide
        self.ScreenLockBack.isHidden = IsHide
                
    }
    
    
    func HideVolumeControls(IsHide: Bool) {
        self.IsVolumeisHidden = IsHide
        self.VolumeStack.isHidden = IsHide
        self.VolumeSlider.isHidden = IsHide
        self.VolumePercent.isHidden = IsHide
        self.VolumeTitle.isHidden = IsHide
        
    }
    
    func HideBrightnessControls(IsHide: Bool) {
        self.IsBrigtNessisHidden = IsHide
        self.BrightnessStack.isHidden = IsHide
        self.BrightnessSlider.isHidden = IsHide
        self.BrightnessPercent.isHidden = IsHide
        self.BrightnessTitle.isHidden = IsHide
        
    }
    
    func SetSlider(MaxValue: Float, SliderName: UISlider) {
        DispatchQueue.main.async {
            SliderName.maximumValue = MaxValue
            SliderName.minimumValue = 0
            SliderName.isContinuous = true
        }

    }

    
    func setSliderThumbTintColor(_ color: UIColor, SliderName: UISlider) {
        let circleImage = makeCircleWith(size: CGSize(width: 15, height: 15),
                                         backgroundColor: color)
        SliderName.setThumbImage(circleImage, for: .normal)
        SliderName.setThumbImage(circleImage, for: .highlighted)
        
    }

    
    fileprivate func makeCircleWith(size: CGSize, backgroundColor: UIColor) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(size, false, 0.0)
        let context = UIGraphicsGetCurrentContext()
        context?.setFillColor(backgroundColor.cgColor)
        context?.setStrokeColor(UIColor.clear.cgColor)
        let bounds = CGRect(origin: .zero, size: size)
        context?.addEllipse(in: bounds)
        context?.drawPath(using: .fill)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }

}



extension AVAsset {
    func generateThumbnail(at time: CMTime, completion: @escaping (UIImage?) -> Void) {
        // Perform heavy lifting on a background thread to avoid blocking the UI
        DispatchQueue.global(qos: .userInitiated).async {
            let imageGenerator = AVAssetImageGenerator(asset: self)
            
            // This is crucial for correct orientation of the thumbnail.
            // Without it, your thumbnail might appear sideways.
            imageGenerator.appliesPreferredTrackTransform = true
            
            // Set a maximum size for the generated image to optimize performance and memory usage.
            // You can adjust this as needed for your UI.
//            imageGenerator.maximumSize = CGSize(width: 300, height: 300) // Example size
            
            do {
                let cgImage = try imageGenerator.copyCGImage(at: time, actualTime: nil)
                let thumbnail = UIImage(cgImage: cgImage)
                
                // Return to the main queue to update UI elements
                DispatchQueue.main.async {
                    completion(thumbnail)
                }
            } catch {
                print("Error generating thumbnail: \(error.localizedDescription)")
                DispatchQueue.main.async {
                    completion(nil)
                }
            }
        }
    }
    
    // An alternative simpler function to get a thumbnail from the beginning
    func generateThumbnailFromStart(completion: @escaping (UIImage?) -> Void) {
        // You can specify the time you want the thumbnail from.
        // CMTime(seconds: 0.0, preferredTimescale: 600) means 0 seconds into the video.
        // preferredTimescale is for precision; 600 is a common value.
        let time = CMTime(seconds: 0.0, preferredTimescale: 600)
        generateThumbnail(at: time, completion: completion)
    }
}

// How to use it:
func getVideoThumbnail(from videoURL: URL, completion: @escaping (UIImage?) -> Void) {
    let asset = AVAsset(url: videoURL)
    
    // Example 1: Get thumbnail from the very beginning
    asset.generateThumbnailFromStart { image in
        completion(image)
    }
    
    // Example 2: Get thumbnail from a specific time (e.g., 5 seconds in)
    // let time = CMTime(seconds: 5.0, preferredTimescale: 600)
    // asset.generateThumbnail(at: time) { image in
    //     completion(image)
    // }
}
