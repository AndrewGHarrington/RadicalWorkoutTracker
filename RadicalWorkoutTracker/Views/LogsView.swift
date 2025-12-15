//
//  LogsView.swift
//  RadicalWorkoutTracker
//
//  Created by Andrew Harrington on 12/15/25.
//

import SwiftUI

struct LogsView: View {
    var logModel: LogEntryModel
    
    var body: some View {
        NavigationView {
            Group {
                if logModel.entries.isEmpty {
                    Text("No entries in log")
                } else {
                    List {
                        ForEach(logModel.entries) { log in
                            VStack(alignment: .leading) {
                                Text(log.entry.name)
                                    .font(.title2)
                                    .fontWeight(.heavy)
                                
                                Text("Date")
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
    LogsView(logModel: LogEntryModel())
}
