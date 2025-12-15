//
//  LogEntryModel.swift
//  RadicalWorkoutTracker
//
//  Created by Andrew Harrington on 12/14/25.
//

import Foundation
internal import Combine

class LogEntryModel: ObservableObject {
    private let logsKey = "Logs"
    
    @Published var entries = [LogEntry]() {
        didSet {
            if let encoded = try? JSONEncoder().encode(entries) {
                UserDefaults.standard.set(encoded, forKey: logsKey)
            }
        }
    }
    
    init() {
        if let savedEntries = UserDefaults.standard.data(forKey: logsKey) {
            if let decodedEntries = try? JSONDecoder().decode([LogEntry].self, from: savedEntries) {
                self.entries = decodedEntries
                
                return
            }
        }
        
        self.entries = []
    }
}
