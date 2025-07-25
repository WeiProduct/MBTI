//
//  AIMBTIApp.swift
//  AIMBTI
//
//  Created by weifu on 7/22/25.
//

import SwiftUI
import SwiftData

@main
struct AIMBTIApp: App {
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            TestResult.self,
            TestProgress.self,
            ChatSession.self,
            ChatMessage.self,
        ])
        
        // Create a unique URL for the app's data
        let appSupport = FileManager.default.urls(for: .applicationSupportDirectory, in: .userDomainMask).first!
        let appDirectory = appSupport.appendingPathComponent("AIMBTI", isDirectory: true)
        
        // Create directory if it doesn't exist
        try? FileManager.default.createDirectory(at: appDirectory, withIntermediateDirectories: true)
        
        let storeURL = appDirectory.appendingPathComponent("AIMBTI.store")
        let modelConfiguration = ModelConfiguration(schema: schema, url: storeURL, cloudKitDatabase: .none)

        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            // If migration fails, try to delete the old store and create a new one
            print("Failed to create ModelContainer: \(error)")
            print("Attempting to delete old store and create new one...")
            
            try? FileManager.default.removeItem(at: storeURL)
            
            do {
                return try ModelContainer(for: schema, configurations: [modelConfiguration])
            } catch {
                fatalError("Could not create ModelContainer after cleanup: \(error)")
            }
        }
    }()

    var body: some Scene {
        WindowGroup {
            MainTabView()
        }
        .modelContainer(sharedModelContainer)
    }
}
