//
//  CoreDataSyncApp.swift
//  CoreDataSync
//

import SwiftUI

@main
struct CoreDataSyncApp: App {
    private let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
