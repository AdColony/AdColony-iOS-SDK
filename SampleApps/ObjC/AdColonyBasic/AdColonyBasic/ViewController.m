//
//  ViewController.m
//  AdColonyBasic
//
//  Copyright (c) 2016 AdColony. All rights reserved.
//

#import "ViewController.h"

#import <AdColony/AdColony.h>

#pragma mark - Constants

#define kAdColonyAppID @"appbdee68ae27024084bb334a"
#define kAdColonyZoneID @"vzf8fb4670a60e4a139d01b5"

#pragma mark - ViewController Interface

@interface ViewController ()
@property (nonatomic, strong) AdColonyInterstitial *ad;
@property (weak, nonatomic) IBOutlet UIButton *launchButton;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *spinner;
@property (weak, nonatomic) IBOutlet UILabel *loadingLabel;
@end


@implementation ViewController

#pragma mark - UIViewController Overrides

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //Configure AdColony as soon as the app starts
    [AdColony configureWithAppID:kAdColonyAppID zoneIDs:@[kAdColonyZoneID] options:nil completion:^(NSArray<AdColonyZone *> * zones) {
        
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
    __weak ViewController *weakSelf = self;
    [AdColony requestInterstitialInZone:kAdColonyZoneID options:nil
     
        //Handler for successful ad requests
        success:^(AdColonyInterstitial *ad) {
            
            //Once the ad has finished, set the loading state and request a new interstitial
            ad.close = ^{
                weakSelf.ad = nil;
                
                [weakSelf setLoadingState];
                [weakSelf requestInterstitial];
            };
            
            //Interstitials can expire, so we need to handle that event also
            ad.expire = ^{
                weakSelf.ad = nil;
                
                [weakSelf setLoadingState];
                [weakSelf requestInterstitial];
            };
            
            //Store a reference to the returned interstitial object
            weakSelf.ad = ad;
            
            //Show the user we are ready to play a video
            [weakSelf setReadyState];
        }
     
        //Handler for failed ad requests
        failure:^(AdColonyAdRequestError *error) {
            NSLog(@"SAMPLE_APP: Request failed with error: %@ and suggestion: %@", [error localizedDescription], [error localizedRecoverySuggestion]);
        }
     ];
}

- (IBAction)launchInterstitial:(id)sender {
    //Display our ad to the user
    if (!self.ad.expired) {
        [self.ad showWithPresentingViewController:self];
    }
}

#pragma mark - UI

- (void)setLoadingState {
    self.launchButton.hidden = YES;
    self.launchButton.alpha = 0.0;
    self.loadingLabel.hidden = NO;
    [self.spinner startAnimating];
}

-(void)setReadyState {
    self.loadingLabel.hidden = YES;
    self.launchButton.hidden = NO;
    [self.spinner stopAnimating];
    [UIView animateWithDuration:1.0 animations:^{ self.launchButton.alpha = 1.; } completion:nil];
}

#pragma mark - Event Handlers

-(void)onBecameActive {
    //If our ad has expired, request a new interstitial
    if (!self.ad) {
        [self requestInterstitial];
    }
}
@end
