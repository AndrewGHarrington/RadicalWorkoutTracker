//
//  LogEntry.swift
//  RadicalWorkoutTracker
//
//  Created by Andrew Harrington on 12/14/25.
//

import Foundation

struct LogEntry: Identifiable, Codable {
    var id = UUID()
    var entry = Workout()
}
