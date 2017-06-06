//
//  AppDelegate.swift
//  VOLA
//
//  Created by Bruno Henriques on 31/05/2017.
//  Copyright © 2017 Systers-Opensource. All rights reserved.
//

import UIKit
import FBSDKCoreKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {

        // Facebook setup
        FBSDKApplicationDelegate.sharedInstance().application(application, didFinishLaunchingWithOptions: launchOptions)

        // Google Sign In setup
        var configError: NSError?
        GGLContext.sharedInstance().configureWithError(&configError)
        assert(configError == nil, "Error configuring Google services: \(configError)")

        GIDSignIn.sharedInstance().delegate = self

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

        guard let sourceApplication = options[UIApplicationOpenURLOptionsKey.sourceApplication] as? String,
            let annotation = options[UIApplicationOpenURLOptionsKey.annotation] else {
                return false
        }

        let fbOpened = FBSDKApplicationDelegate.sharedInstance().application(app,
                open: url, sourceApplication: sourceApplication, annotation: annotation)
        let googleOpened = GIDSignIn.sharedInstance().handle(url,
                sourceApplication: sourceApplication, annotation: annotation)

        return (fbOpened || googleOpened)
    }
}

extension AppDelegate: GIDSignInDelegate {
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        guard let _ = error else {
            DataManager.shared.logIn(user: UserModel(googleUser: user))
            return
        }
    }

    func sign(_ signIn: GIDSignIn!, didDisconnectWith user: GIDGoogleUser!, withError error: Error!) {
        // required
    }
}
