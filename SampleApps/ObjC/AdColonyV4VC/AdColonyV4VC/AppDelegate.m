//
//  AppDelegate.m
//  AdColonyV4VC
//
//  Copyright (c) 2016 AdColony. All rights reserved.
//

#import "AppDelegate.h"

#import <AdColony/AdColony.h>
#import <StoreKit/StoreKit.h>

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    if (@available(iOS 11.3, *)) {
        [SKAdNetwork registerAppForAdNetworkAttribution];
    }
    return YES;
}

@end
