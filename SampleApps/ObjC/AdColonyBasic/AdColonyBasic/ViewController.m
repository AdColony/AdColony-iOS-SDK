//
//  ViewController.m
//  AdColonyBasic
//
//  Copyright (c) 2016 AdColony. All rights reserved.
//

#import "ViewController.h"
#import "Settings.h"

#import <AdColony/AdColony.h>


#pragma mark - ViewController Interface

@interface ViewController () <AdColonyInterstitialDelegate>

@property (nonatomic, weak) AdColonyInterstitial *ad;

@property (nonatomic, weak) IBOutlet UIImageView *background;
@property (nonatomic, weak) IBOutlet UIButton *launchButton;
@property (nonatomic, weak) IBOutlet UIActivityIndicatorView *spinner;
@property (nonatomic, weak) IBOutlet UILabel *loadingLabel;
@property (nonatomic, weak) IBOutlet UIButton *bannersButton;

@end


@implementation ViewController

#pragma mark - UIViewController Overrides

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.bannersButton.alpha = 0.0;
    self.bannersButton.hidden = YES;
    
    //Configure AdColony as soon as the app starts
    [AdColony configureWithAppID:kAdColonyAppID options:nil completion:^(NSArray<AdColonyZone *> * zones) {
        self.bannersButton.hidden = NO;
        [UIView animateWithDuration:1.0 animations:^{
            self.bannersButton.alpha = 1.0;
        }];
        
        //AdColony has finished configuring, so let's request an interstitial ad
        [self requestInterstitial];
        
        //If the application has been inactive for a while, our ad might have expired so let's add a check for a nil ad object
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onBecameActive) name:UIApplicationDidBecomeActiveNotification object:nil];
    }];
    
    //Show the user that we are currently loading videos
    [self setLoadingState];
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskAll;
}

- (BOOL)shouldAutorotate {
    return YES;
}

#pragma mark - AdColony

- (void)requestInterstitial {
    //Request an interstitial ad from AdColony
    [AdColony requestInterstitialInZone:kAdColonyInterstitialZoneID options:nil andDelegate:self];
}

- (IBAction)launchInterstitial:(id)sender {
    //Display our ad to the user
    if (!self.ad.expired) {
        [self.ad showWithPresentingViewController:self];
    }
}

- (void)adColonyInterstitialDidLoad:(AdColonyInterstitial *)interstitial {
    //Store a reference to the returned interstitial object
    self.ad = interstitial;
    
    //Show the user we are ready to play a video
    [self setReadyState];
}

- (void)adColonyInterstitialExpired:(AdColonyInterstitial *)interstitial  {
    self.ad = nil;
    
    [self setLoadingState];
    [self requestInterstitial];
}

- (void)adColonyInterstitialDidFailToLoad:(AdColonyAdRequestError *)error {
    if (error.localizedFailureReason) {
        NSLog(@"SAMPLE_APP: Interstitial request failed in zone %@ with error: %@ and failure reason: %@", error.zoneId, error.localizedDescription, error.localizedFailureReason);
    } else if (error.localizedRecoverySuggestion) {
        NSLog(@"SAMPLE_APP: Interstitial request failed in zone %@ with error: %@ and suggestion: %@", error.zoneId, error.localizedDescription, error.localizedRecoverySuggestion);
    } else {
        NSLog(@"SAMPLE_APP: Interstitial request failed in zone %@ with error: %@", error.zoneId, error.localizedDescription);
    }
}

- (void)adColonyInterstitialDidClose:(AdColonyInterstitial *)interstitial {
    [self setLoadingState];
    [self requestInterstitial];
}

#pragma mark - UI

- (void)setLoadingState {
    self.launchButton.hidden = YES;
    self.launchButton.alpha = 0.0;
    self.loadingLabel.hidden = NO;
    [self.spinner startAnimating];
}

- (void)setReadyState {
    self.loadingLabel.hidden = YES;
    self.launchButton.hidden = NO;
    [self.spinner stopAnimating];
    [UIView animateWithDuration:1.0 animations:^{ self.launchButton.alpha = 1.; } completion:nil];
}

#pragma mark - Event Handlers

- (void)onBecameActive {
    //If our ad has expired, request a new interstitial
    if (!self.ad) {
        [self requestInterstitial];
    }
}

@end
