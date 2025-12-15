//
//  ContentView.swift
//  RadicalWorkoutTracker
//
//  Created by Andrew Harrington on 12/13/25.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var logModel = LogEntryModel()
    
    var body: some View {
        TabView {
            WorkoutsView(logModel: logModel)
                .tabItem {
                    VStack {
                        Image(systemName: "flame")
                        Text("Workouts")
                    }
                }
            
            LogsView(logModel: logModel)
                .tabItem {
                    VStack {
                        Image(systemName: "chart.bar.fill")
                        Text("Log")
                    }
                }
        }
    }
}

#Preview {
    ContentView()
}
