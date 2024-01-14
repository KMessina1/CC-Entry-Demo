/*--------------------------------------------------------------------------------------------------------------------------
    File: CC_Entry_DemoApp.swift
  Author: Kevin Messina
 Created: 1/12/24
Modified:
 
©2024 Creative App Solutions, LLC. - All Rights Reserved.
----------------------------------------------------------------------------------------------------------------------------
NOTES:
--------------------------------------------------------------------------------------------------------------------------*/

import SwiftUI

@main
struct CC_Entry_DemoApp: App {
    @Environment(\.scenePhase) var scenePhase

    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .onChange(of: scenePhase) { oldPhaseState, newPhaseState in
            switch newPhaseState {
                case .active:
                    print("App became active.")
                case .background:
                    print("App went to background.")
                case .inactive:
                    print("App became Inactive.")
                @unknown default:
                    print("Something new and uncaught from Apple.")
            }
        }    }
}
