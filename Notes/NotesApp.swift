//
//  NotesApp.swift
//  Notes
//
//  Created by Алексей Колыченков on 12.03.2025.
//

import SwiftUI
import SwiftfulRouting

@main
struct NotesApp: App {
    
    var body: some Scene {
        WindowGroup {
            RouterView { router in
                NotesListView(vm: NotesListViewModel(router: router))
                    .preferredColorScheme(.dark)
            }
        }
    }
}
