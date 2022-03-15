//
//  ViewController.m
//  AdColonyV4VC
//
//  Copyright (c) 2016 AdColony. All rights reserved.
//

#import "ViewController.h"

#import <AdColony/AdColony.h>

#pragma mark - Constants

#define kAdColonyAppID @"appbdee68ae27024084bb334a"
#define kAdColonyZoneID @"vzf8e4e97704c4445c87504e"

#define kCurrencyBalance @"Currency_Balance"
#define kCurrencyBalanceChange @"Currency_Balance_Change"

#pragma mark - ViewController Interface

@interface ViewController () <AdColonyInterstitialDelegate>

@property (nonatomic, weak) AdColonyInterstitial *ad;

@property (nonatomic, weak) IBOutlet UIImageView *background;
@property (nonatomic, weak) IBOutlet UIButton *button;
@property (nonatomic, weak) IBOutlet UILabel *currencyLabel;
@property (nonatomic, weak) IBOutlet UILabel *statusLabel;
@property (nonatomic, weak) IBOutlet UIActivityIndicatorView *spinner;

@end


@implementation ViewController

#pragma mark - UIViewController overrides

- (void)viewDidLoad {
    [super viewDidLoad];
    
    __weak typeof(self) weakSelf = self;
    
    //Initialize AdColony on initial launch
    [AdColony configureWithAppID:kAdColonyAppID options:nil completion:^(NSArray<AdColonyZone *> * zones) {
        
        //Set the zone's reward handler
        //This implementation is designed for client-side virtual currency without a server
        //It uses NSUserDefaults for persistent client-side storage of the currency balance
        //For applications with a server, contact the server to retrieve an updated currency balance
        AdColonyZone *zone = [zones firstObject];
        zone.reward = ^(BOOL success, NSString *name, int amount) {
            __strong typeof(weakSelf) self = weakSelf;
            
            //Store the new balance and update the UI to reflect the change
            if (success) {
                NSUserDefaults* storage = [NSUserDefaults standardUserDefaults];
                
                //Get currency balance from persistent storage and update it
                NSNumber* wrappedBalance = [storage objectForKey:kCurrencyBalance];
                NSUInteger balance = wrappedBalance && [wrappedBalance isKindOfClass:[NSNumber class]] ? [wrappedBalance unsignedIntValue] : 0;
                balance += amount;
                
                //Persist the currency balance
                [storage setValue:[NSNumber numberWithUnsignedLong:balance] forKey:kCurrencyBalance];
                [storage synchronize];
                
                //Update the UI with the new balance
                [self updateCurrencyBalance];
            }
        };
        
        //If the application has been inactive for a while, our ad might have expired so let's add a check for a nil ad object
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onBecameActive) name:UIApplicationDidBecomeActiveNotification object:nil];
        
        //AdColony has finished configuring, so let's request an interstitial ad
        [self requestInterstitial];
    }];
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        [self.spinner setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleWhiteLarge];
    } else {
        [self.spinner setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleWhite];
    }
    
    [self updateCurrencyBalance];
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
    [AdColony requestInterstitialInZone:kAdColonyZoneID options:nil andDelegate:self];
}

- (void)adColonyInterstitialDidLoad:(AdColonyInterstitial *)interstitial {
    //Store a reference to the returned interstitial object
    self.ad = interstitial;
                            
    //Show the user we are ready to play a video
    [self setReadyState];
}

- (void)adColonyInterstitialExpired:(AdColonyInterstitial *)interstitial {
    self.ad = nil;
    [self setLoadingState];
    [self requestInterstitial];
}

- (void)adColonyInterstitialDidFailToLoad:(AdColonyAdRequestError *)error {
    if (error.localizedFailureReason) {
        NSLog(@"SAMPLE_APP: Request failed in zone %@ with error: %@ and failure reason: %@", error.zoneId, error.localizedDescription, error.localizedFailureReason);
    } else if (error.localizedRecoverySuggestion) {
        NSLog(@"SAMPLE_APP: Request failed in zone %@ with error: %@ and suggestion: %@", error.zoneId, error.localizedDescription, error.localizedRecoverySuggestion);
    } else {
        NSLog(@"SAMPLE_APP: Request failed in zone %@ with error: %@", error.zoneId, error.localizedDescription);
    }
}

- (void)adColonyInterstitialDidClose:(AdColonyInterstitial *)interstitial {
    self.ad = nil;
    [self setLoadingState];
    [self requestInterstitial];
}

- (IBAction)triggerVideo {
    //Display our ad to the user
    if (!self.ad.expired) {
        [self.ad showWithPresentingViewController:self];
    }
}

#pragma mark - UI

- (void)setLoadingState {
    [self.spinner setHidden:NO];
    [self.spinner startAnimating];
    [self.button setAlpha:0.];
    [UIView animateWithDuration:.5 animations:^{ self.statusLabel.alpha = 1.; } completion:nil];
}

- (void)setReadyState {
    [self.spinner stopAnimating];
    [self.spinner setHidden:YES];
    [self.statusLabel setAlpha:0.];
    [UIView animateWithDuration:1.0 animations:^{ self.button.alpha = 1.; } completion:nil];
}

- (void)updateCurrencyBalance {
    //Get currency balance from persistent storage and display it
    NSNumber* wrappedBalance = [[NSUserDefaults standardUserDefaults] objectForKey:kCurrencyBalance];
    NSUInteger balance = wrappedBalance && [wrappedBalance isKindOfClass:[NSNumber class]] ? [wrappedBalance unsignedIntValue] : 0;
    [self.currencyLabel setText:[NSString stringWithFormat:@"%lu", (unsigned long)balance]];
}

#pragma mark - Event Handlers

- (void)onBecameActive {
    //If our ad has expired, request a new interstitial
    if (!self.ad) {
        [self requestInterstitial];
    }
}

@end
