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
// let kViewControllerIMAVMAPResponseAdTag = "https://pubads.g.doubleclick.net/gampad/ads?sz=320x240&iu=/6390/BabyCenter&cust_params={mediainfo.ad_keys}&impl=s&gdfp_req=1&env=vp&output=vast&unviewed_position_start=1&url={document.referrer}&description_url={player.url}&correlator={timestamp}"
let kViewControllerIMAVMAPResponseAdTag = "https://a71csqxusb.execute-api.us-west-2.amazonaws.com/stable/ads"

// VMAP sample from Google just to see if that would work.
// let kViewControllerIMAVMAPResponseAdTag = "https://pubads.g.doubleclick.net/gampad/ads?sz=640x480&iu=/124319096/external/ad_rule_samples&ciu_szs=300x250&ad_rule=1&impl=s&gdfp_req=1&env=vp&output=vmap&unviewed_position_start=1&cust_params=deployment%3Ddevsite%26sample_ar%3Dpreonly&cmsid=496&vid=short_onecue&correlator="

class ViewController: UIViewController, BCOVPlaybackControllerDelegate, BCOVPUIPlayerViewDelegate, IMAWebOpenerDelegate {
    let playbackService = BCOVPlaybackService(accountId: kViewControllerAccountID, policyKey: kViewControllerPlaybackServicePolicyKey)!
    var playbackController :BCOVPlaybackController? = nil
    var playerView :BCOVPUIPlayerView? = nil
    
    @IBOutlet weak var videoContainer: UIView!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        let manager = BCOVPlayerSDKManager.shared()!
        
        /*
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
        */
        
        let imaSettings = IMASettings()
        imaSettings.ppid = kViewControllerIMAPublisherID
        imaSettings.language = kViewControllerIMALanguage
        let renderSettings = IMAAdsRenderingSettings()
        renderSettings.webOpenerPresentingController = self
        // var videoContainerView: UIView? = videoView
        let adsRequestPolicy = BCOVIMAAdsRequestPolicy(vmapAdTagUrl: kViewControllerIMAVMAPResponseAdTag)
        // var manager = BCOVPlayerSDKManager.shared()
        playbackController = manager.createIMAPlaybackController(with: imaSettings, adsRenderingSettings: renderSettings, adsRequestPolicy: adsRequestPolicy, adContainer: videoContainer, companionSlots: nil, viewStrategy: nil)
        playbackController?.delegate = self
        playbackController?.isAutoAdvance = true
        playbackController?.isAutoPlay = true
        
        // videoContainer?.addSubview((controller?.view)!)
        
        // var playbackService = BCOVPlaybackService(accountId: kViewControllerAccountID, policyKey: kViewControllerPlaybackServicePolicyKey)
        /*
        playbackService.findVideo(with: kViewControllerVideoID, parameters: nil, completion: {(_ video: BCOVVideo, _ jsonResponse: [AnyHashable: Any], _ error: Error?) -> Void in
            controller?.videos = [video]
            controller?.play()
        })
    */
        

    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        // Create and set options
        let options = BCOVPUIPlayerViewOptions()
        options.presentingViewController = self
        
        // Create and configure Control View
        let controlsView = BCOVPUIBasicControlView.withVODLayout()
        playerView = BCOVPUIPlayerView.init(playbackController: playbackController, options: options, controlsView: controlsView)!
        
        playerView?.delegate = self
        playerView?.frame = videoContainer.bounds
        playerView?.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        
        videoContainer.addSubview(playerView!)
        
        requestContentFromPlaybackService()
    }
    
    func requestContentFromPlaybackService() {
        playbackService.findVideo(withVideoID: kViewControllerVideoID, parameters: nil) {
            (video: BCOVVideo?, dict: [AnyHashable:Any]?, error: Error?) in
            if let v = video {
                self.playbackController?.setVideos([v] as NSFastEnumeration!)
                self.playbackController?.play()
                // self.playbackController.setVideos([v])
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

