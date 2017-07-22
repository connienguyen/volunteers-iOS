//
//  AppDelegate.swift
//  VOLA
//
//  Created by Bruno Henriques on 31/05/2017.
//  Copyright © 2017 Systers-Opensource. All rights reserved.
//

import UIKit
import FBSDKCoreKit
import GoogleMaps
import Firebase

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {

        // Facebook setup
        FBSDKApplicationDelegate.sharedInstance().application(application, didFinishLaunchingWithOptions: launchOptions)

        // Google Sign In setup: Configure Google services and set AppDelegate as a
        // delegate for GIDSignIn
        var configError: NSError?
        GGLContext.sharedInstance().configureWithError(&configError)
        assert(configError == nil, "Error configuring Google services: \(configError)")
        GIDSignIn.sharedInstance().delegate = self

        // Set up Google Maps API
        do {
            let googleMapsKey = try SecretKeyManager.shared.value(for: .googleMaps)
            GMSServices.provideAPIKey(googleMapsKey)
        } catch {
            Logger.error(error)
        }
        FIRApp.configure()

        DataManager.shared.loadUserIfExists()
        ThemeManager.shared.apply()
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        ReachabilityManager.shared.stopMonitoring()
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        ReachabilityManager.shared.startMonitoring()
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
    }

    func applicationWillTerminate(_ application: UIApplication) {
    }

    func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {

        guard let sourceApplication = options[UIApplicationOpenURLOptionsKey.sourceApplication] as? String else {
            return false
        }

        let annotation = options[UIApplicationOpenURLOptionsKey.annotation]
        let fbOpened = FBSDKApplicationDelegate.sharedInstance().application(app,
                open: url, sourceApplication: sourceApplication, annotation: annotation)
        let googleOpened = GIDSignIn.sharedInstance().handle(url,
                sourceApplication: sourceApplication, annotation: annotation)

        return (fbOpened || googleOpened)
    }
}

extension AppDelegate: GIDSignInDelegate {
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        guard error == nil else {
            Logger.error(error?.localizedDescription ?? VLError.invalidGoogleUser.localizedDescription)
            return
        }

        let notificationData: [String: Any] = [DictKeys.user.rawValue: user]
        NotificationCenter.default.post(name: NotificationName.googleDidSignIn, object: nil, userInfo: notificationData)
    }

    func sign(_ signIn: GIDSignIn!, didDisconnectWith user: GIDGoogleUser!, withError error: Error!) {
        // TODO - func is required to confirm to GIDSignInDelegate
    }
}
