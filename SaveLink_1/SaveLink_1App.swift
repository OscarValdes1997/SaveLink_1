//
//  SaveLink_1App.swift
//  SaveLink_1
//
//  Created by Oscar Valdes on 25/06/23.
//

import SwiftUI
import FirebaseCore

class AppDelegate: NSObject, UIApplicationDelegate {
  func application(_ application: UIApplication,
                   didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
    FirebaseApp.configure()
    return true
  }
}
@main
struct SaveLink_1App: App {
    
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    
    @StateObject var authenticationViewModel = AuthenticationViewModel()
    
    var body: some Scene {
        WindowGroup {
            if let _ = authenticationViewModel.user{
                HomeView(authenticationViewModel: authenticationViewModel)
            }else{
                ContentView(authenticationViewModel: authenticationViewModel)
            }
        }
    }
}
