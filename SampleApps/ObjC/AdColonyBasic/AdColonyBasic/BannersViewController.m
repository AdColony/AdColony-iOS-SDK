//
//  BannersViewController.m
//  AdColonyBasic
//
//  Copyright © 2019 AdColony. All rights reserved.
//

#import "BannersViewController.h"
#import "Settings.h"

#import <AdColony/AdColony.h>


#pragma mark - BannersViewController Interface

@interface BannersViewController () <AdColonyAdViewDelegate>

@property (nonatomic, weak) AdColonyAdView *ad;

@property (nonatomic, weak) IBOutlet UIView *bannerPlacement;
@property (nonatomic, weak) IBOutlet UIActivityIndicatorView *spinner;
@property (nonatomic, weak) IBOutlet UILabel *loadingLabel;
@property (nonatomic, weak) IBOutlet UIButton *loadButton;

@end

@implementation BannersViewController

#pragma mark - UIViewController Overrides

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setLoadingState];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self requestBanner];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [self clearBanner];
}

#pragma mark - AdColony

- (void)requestBanner {
    [self setLoadingState];
    [AdColony requestAdViewInZone:kAdColonyBannerZoneID withSize:kAdColonyAdSizeBanner viewController:self andDelegate:self];
}

- (void)clearBanner {
    if (self.ad) {
        [self.ad destroy];
        self.ad = nil;
    }
}

- (void)adColonyAdViewDidLoad:(AdColonyAdView *)adView {
    [self clearBanner];
    self.ad = adView;
    CGSize placementSize = self.bannerPlacement.frame.size;
    adView.frame = CGRectMake(0, 0, placementSize.width, placementSize.height);
    [self.bannerPlacement addSubview:adView];
    [self setReadyState];
}

- (void)adColonyAdViewDidFailToLoad:(AdColonyAdRequestError *)error {
    NSLog(@"SAMPLE_APP: Banner request failed with error: %@ and suggestion: %@", [error localizedDescription], [error localizedRecoverySuggestion]);
    [self setReadyState];
}

#pragma mark - UI

- (void)setReadyState {
    self.loadingLabel.hidden = YES;
    [self.spinner stopAnimating];
    self.loadButton.hidden = NO;
    [UIView animateWithDuration:1.0 animations:^{ self.loadButton.alpha = 1.0; } completion:nil];
}

- (void)setLoadingState {
    self.loadButton.hidden = YES;
    self.loadButton.alpha = 0.0;
    self.loadingLabel.hidden = NO;
    [self.spinner startAnimating];
}

#pragma mark - Action Handlers

- (IBAction)loadBanner:(id)sender {
    [self requestBanner];
}

- (IBAction)goBack:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
