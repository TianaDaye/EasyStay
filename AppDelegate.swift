//
//  AppDelegate.swift
//  EasyStay
//
//  Created by Tiana Daye (RIT Student) on 12/12/24.
//

import UIKit
import Firebase

class AppDelegate: UIResponder, UIApplicationDelegate {
    // Override this function to initialize Firebase when the app starts
    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        // Initialize Firebase
        FirebaseApp.configure()
        
        return true
    }
}

