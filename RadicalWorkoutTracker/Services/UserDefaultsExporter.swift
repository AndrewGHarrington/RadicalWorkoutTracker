//
//  UserDefaultsExporter.swift
//  RadicalWorkoutTracker
//
//  Created by Andrew Harrington on 12/15/25.
//

import Foundation

enum WorkoutExporter {

    static func exportToJSON() throws -> URL {
        let workouts = loadWorkouts()

        let encoder = JSONEncoder()
        encoder.outputFormatting = [.prettyPrinted, .sortedKeys]
        //encoder.dateEncodingStrategy = .iso8601

        let data = try encoder.encode(workouts)

        let tempURL = FileManager.default.temporaryDirectory
            .appendingPathComponent("workouts_backup.json")

        try data.write(to: tempURL, options: [.atomic])

        return tempURL
    }
}

func loadWorkouts() -> [LogEntry] {
    let logsKey = "Logs"
    
    if let savedEntries = UserDefaults.standard.data(forKey: logsKey) {
        if let decodedEntries = try? JSONDecoder().decode([LogEntry].self, from: savedEntries) {
            return decodedEntries
        }
    }
    
    return []
}
