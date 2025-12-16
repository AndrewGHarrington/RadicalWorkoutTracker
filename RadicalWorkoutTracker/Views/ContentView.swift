//
//  ContentView.swift
//  RadicalWorkoutTracker
//
//  Created by Andrew Harrington on 12/13/25.
//

import SwiftUI

struct ContentView: View {
    @StateObject var logModel = LogEntryModel()
    
    var body: some View {
        TabView {
            WorkoutsView()
                .tabItem {
                    VStack {
                        Image(systemName: "flame")
                        Text("Workouts")
                    }
                }
            
            LogsView()
                .tabItem {
                    VStack {
                        Image(systemName: "chart.bar.fill")
                        Text("Log")
                    }
                }
        }
        .environmentObject(logModel)
    }
}

#Preview {
    ContentView()
}
