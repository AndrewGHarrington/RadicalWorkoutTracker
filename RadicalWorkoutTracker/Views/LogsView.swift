//
//  LogsView.swift
//  RadicalWorkoutTracker
//
//  Created by Andrew Harrington on 12/15/25.
//

import SwiftUI

struct LogsView: View {
    @EnvironmentObject var logModel: LogEntryModel
    
    var body: some View {
        NavigationView {
            VStack {
                if logModel.entries.isEmpty {
                    Text("No entries in log")
                } else {
                    List {
                        ForEach(logModel.entries) { entry in
                            NavigationLink {
                                LogEntryDetailView(entry: entry)
                            } label: {
                                VStack(alignment: .leading) {
                                    Text(entry.entry.name)
                                        .font(.title2)
                                        .fontWeight(.heavy)
                                    
                                    Text(entry.entry.dateCompleted.formatted(date: .long, time: .shortened))
                                        .font(.system(size: 14))
                                        .foregroundStyle(Color(red: 0.8, green: 0.8, blue: 0.8))
                                    
                                }
                            }
                        }
                        .onDelete(perform: removeRow)
                    }
                }
            }
                .navigationTitle("Log")
        }
    }
    
    func removeRow(_ offsets: IndexSet) {
        logModel.entries.remove(atOffsets: offsets)
    }
}

#Preview {
    LogsView()
}
