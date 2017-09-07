//
//  ViewController.swift
//  VCPlaylistIOS
//
//  Created by James Rainville on 8/28/17.
//  Copyright © 2017 James Rainville. All rights reserved.
//
import UIKit

let kViewControllerPlaybackServicePolicyKey = "BCpkADawqM3dCmAPU7-jl0hHWW8097dehsjhdHYeCZVO3HbClNSwbtBpZkhuDuab141BnGkFL_xvPCif9v6Sz5A27pFUo8-qFuq42J6vzrXnLkmeLzGkQ1HzNdow2rI0qmhyPaEEhSGTPpW9"
let kViewControllerAccountID = "4517911906001"
let kViewControllerVideoID = "5269117590001"
let kViewControllerPlaylistID = "5280100152001"

let kViewControllerIMAPublisherID = "ca-pub-4202951716165137"
let kViewControllerIMALanguage = "en"
let kViewControllerIMAVMAPResponseAdTag = "https://pubads.g.doubleclick.net/gampad/ads?sz=320x240&iu=/6390/BabyCenter&cust_params={mediainfo.ad_keys}&impl=s&gdfp_req=1&env=vp&output=vast&unviewed_position_start=1&url={document.referrer}&description_url={player.url}&correlator={timestamp}"

class ViewController: UIViewController, BCOVPlaybackControllerDelegate, BCOVPUIPlayerViewDelegate, IMAWebOpenerDelegate {
    let playbackService = BCOVPlaybackService(accountId: kViewControllerAccountID, policyKey: kViewControllerPlaybackServicePolicyKey)!
    let playbackController :BCOVPlaybackController
    @IBOutlet weak var videoContainer: UIView!
    
    required init?(coder aDecoder: NSCoder) {
        
        let manager = BCOVPlayerSDKManager.shared()!
        
        let imaSettings = IMASettings()
        imaSettings.ppid = kViewControllerIMAPublisherID
        imaSettings.language = kViewControllerIMALanguage
        let renderSettings = IMAAdsRenderingSettings()
        renderSettings.webOpenerPresentingController = self
        renderSettings.webOpenerDelegate = self as IMAWebOpenerDelegate
        let adsRequestPolicy = BCOVIMAAdsRequestPolicy(vmapAdTagUrl: kViewControllerIMAVMAPResponseAdTag)

        playbackController = manager.createIMAPlaybackController(with: imaSettings, adsRenderingSettings: renderSettings, adsRequestPolicy: adsRequestPolicy, adContainer: videoContainer, companionSlots: nil, viewStrategy: nil)
        
        // playbackController = manager.createPlaybackController()
        super.init(coder: aDecoder)
        
        playbackController.analytics.account = kViewControllerAccountID
        
        playbackController.delegate = self
        playbackController.isAutoAdvance = true
        playbackController.isAutoPlay = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        // Create and set options
        let options = BCOVPUIPlayerViewOptions()
        options.presentingViewController = self
        
        // Create and configure Control View
        let controlsView = BCOVPUIBasicControlView.withVODLayout()
        let playerView = BCOVPUIPlayerView.init(playbackController: playbackController, options: options, controlsView: controlsView)!
        
        playerView.delegate = self
        playerView.frame = videoContainer.bounds
        playerView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        
        videoContainer.addSubview(playerView)
        
        requestContentFromPlaybackService()
    }
    
    func requestContentFromPlaybackService() {
        playbackService.findVideo(withVideoID: kViewControllerVideoID, parameters: nil) {
            (video: BCOVVideo?, dict: [AnyHashable:Any]?, error: Error?) in
            if let v = video {
                self.playbackController.setVideos([v] as NSFastEnumeration!)
            } else {
                print("ViewController Debug - Error retrieving video: %@", error!)
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

