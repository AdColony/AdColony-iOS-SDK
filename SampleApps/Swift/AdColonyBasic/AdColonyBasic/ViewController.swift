//
//  ViewController.swift
//  AdColonyBasic
//
//  Copyright (c) 2016 AdColony. All rights reserved.
//

import UIKit
import Foundation

class ViewController: UIViewController, AdColonyInterstitialDelegate {
    
    @IBOutlet weak var bannersButton: UIButton!
    @IBOutlet weak var launchButton: UIButton!
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    @IBOutlet weak var loadingLabel: UILabel!
    
    var ad: AdColonyInterstitial?
    
    
    //=============================================
    // MARK:- UIViewController Overrides
    //=============================================
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.bannersButton.alpha = 0
        self.bannersButton.isHidden = true
        
        //Configure AdColony once
        AdColony.configure(withAppID: Constants.adColonyAppID, zoneIDs: [Constants.adColonyInterstitialZoneID, Constants.adColonyBannerZoneID], options: nil) { (zones) in
            
            //AdColony has finished configuring, so let's request an interstitial ad
            self.requestInterstitial()
            
            //If the application has been inactive for a while, our ad might have expired so let's add a check for a nil ad object
            NotificationCenter.default.addObserver(forName: UIApplication.didBecomeActiveNotification,
                                                   object: nil,
                                                   queue: OperationQueue.main,
                                                   using: { notification in
                                                        //If our ad has expired, request a new interstitial
                                                        if (self.ad == nil) {
                                                            self.requestInterstitial()
                                                        }
                                                    })
            
            self.bannersButton.isHidden = false
            UIView.animate(withDuration: 1) {
                self.bannersButton.alpha = 1
            }
        }
        
        //Show the user that we are currently loading videos
        self.setLoadingState()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return UIStatusBarStyle.lightContent
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return UIInterfaceOrientationMask.all
    }
    
    override var shouldAutorotate: Bool {
        return true
    }
    
    
    //=============================================
    // MARK:- AdColony
    //=============================================
    
    func requestInterstitial() {
        self.setLoadingState()
        
        //Request an interstitial ad from AdColony
        AdColony.requestInterstitial(inZone: Constants.adColonyInterstitialZoneID, options: nil, andDelegate: self)
    }
    
    func adColonyInterstitialDidLoad(_ interstitial: AdColonyInterstitial) {
        //Store a reference to the returned interstitial object
        self.ad = interstitial
        
        //Show the user we are ready to play a video
        self.setReadyState()
    }
    
    func adColonyInterstitialDidFail(toLoad error: AdColonyAdRequestError) {
        if let reason = error.localizedFailureReason {
            print("SAMPLE_APP: Interstitial request failed in zone \(error.zoneId) with error: \(error.localizedDescription) and failure reason: \(reason)")
        } else if let recoverySuggestion = error.localizedRecoverySuggestion {
            print("SAMPLE_APP: Interstitial request failed in zone \(error.zoneId) with error: \(error.localizedDescription) and recovery suggestion: \(recoverySuggestion)")
        } else {
            print("SAMPLE_APP: Interstitial request failed in zone \(error.zoneId) with error: \(error.localizedDescription)")
        }
    }
    
    func adColonyInterstitialExpired(_ interstitial: AdColonyInterstitial) {
        self.ad = nil
        self.requestInterstitial()
    }
    
    func adColonyInterstitialDidClose(_ interstitial: AdColonyInterstitial) {
        self.ad = nil
        self.requestInterstitial()
    }
    
    @IBAction func launchInterstitial(_ sender: AnyObject) {
        //Display our ad to the user
        if let ad = self.ad {
            if (!ad.expired) {
                ad.show(withPresenting: self)
            }
        }
    }
    
    
    //=============================================
    // MARK:- UI
    //=============================================

    func setLoadingState() {
        self.launchButton.isHidden = true
        self.launchButton.alpha = 0.0
        self.loadingLabel.isHidden = false
        self.spinner.startAnimating()
    }
    
    func setReadyState() {
        self.loadingLabel.isHidden = true
        self.launchButton.isHidden = false
        self.spinner.stopAnimating()
        
        UIView.animate(withDuration: 1.0) {
            self.launchButton.alpha = 1.0
        }
    }
    
}
