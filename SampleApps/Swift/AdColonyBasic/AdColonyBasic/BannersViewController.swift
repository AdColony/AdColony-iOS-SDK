//
//  BannersViewController.swift
//  AdColonyBasic
//
//  Copyright © 2019 AdColony. All rights reserved.
//

import UIKit

class BannersViewController: UIViewController, AdColonyAdViewDelegate {

    @IBOutlet weak var loadButton: UIButton!
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    @IBOutlet weak var loadingLabel: UILabel!
    @IBOutlet weak var bannerPlacement: UIView!
    
    weak var ad: AdColonyAdView? = nil
    
    //=============================================
    // MARK:- UIViewController Overrides
    //=============================================
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setLoadingState()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.requestBanner()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        self.clearBanner()
    }
    
    //=============================================
    // MARK:- AdColony
    //=============================================
    
    func requestBanner() {
        self.setLoadingState()
        AdColony.requestAdView(inZone: Constants.adColonyBannerZoneID, with: kAdColonyAdSizeBanner, viewController: self, andDelegate: self)
    }
    
    func adColonyAdViewDidLoad(_ adView: AdColonyAdView) {
        self.clearBanner()
        self.ad = adView
        let placementSize = self.bannerPlacement.frame.size;
        adView.frame = CGRect(x: 0, y: 0, width: placementSize.width, height: placementSize.height)
        self.bannerPlacement.addSubview(adView)
        self.setReadyState()
    }
    
    func adColonyAdViewDidFail(toLoad error: AdColonyAdRequestError) {
        print("SAMPLE_APP: Banner request failed with error: \(error.localizedDescription) and suggestion: \(error.localizedRecoverySuggestion!)")
        self.setReadyState()
    }
    
    func clearBanner() {
        if let adView = self.ad {
            adView.destroy()
            self.ad = nil
        }
    }
    
    //=============================================
    // MARK:- UI
    //=============================================
    
    func setLoadingState() {
        self.spinner.startAnimating()
        self.loadingLabel.isHidden = false
        self.loadButton.alpha = 0
        self.loadButton.isHidden = true
    }
    
    func setReadyState() {
        self.spinner.stopAnimating()
        self.loadingLabel.isHidden = true
        self.loadButton.isHidden = false
        UIView.animate(withDuration: 1) {
            self.loadButton.alpha = 1
        }
    }
    
    @IBAction func loadBanner() {
        self.requestBanner()
    }

    @IBAction func goBack() {
        self.dismiss(animated: true, completion: nil)
    }

}
