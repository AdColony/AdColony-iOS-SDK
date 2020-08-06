//
//  AppDelegate.swift
//  AdColonyBasic
//
//  Copyright (c) 2016 AdColony. All rights reserved.
//

import UIKit
import StoreKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    private func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: Any]?) -> Bool {
        if #available(iOS 11.3, *) {
            SKAdNetwork.registerAppForAdNetworkAttribution()
        }
        return true
    }
    
}
