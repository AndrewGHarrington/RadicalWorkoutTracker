//
//  DataService.swift
//  RadicalWorkoutTracker
//
//  Created by Andrew Harrington on 12/13/25.
//

import Foundation

struct DataService {
    static func getTempData() -> [Workout] {
        guard let url = Bundle.main.url(forResource: "workout_log_backup", withExtension: "json") else {
            return [Workout]()
        }
        
        do {
            let data = try Data(contentsOf: url)
            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = .iso8601
            let workouts = try decoder.decode([Workout].self, from: data)
            
            for workout in workouts {
                workout.id = UUID()
                
                for exercise in workout.exercises {
                    exercise.id = UUID()
                    
                    for exerciseSet in exercise.exerciseSets {
                        exerciseSet.id = UUID()
                    }
                }
            }
            
            return workouts
        } catch {
            print(error)
        }
        
        return [Workout]()
    }
    
    static func compileJSONAndExportFile(_ logEntries: [LogEntry]) throws -> URL {
        var workouts = [Workout]()
        
        for entry in logEntries {
            workouts.append(entry.entry)
        }
        
        var json = "[\n"
        
        for workout in workouts {
            var workoutJSON = "\t{\n"
            
            workoutJSON += "\t\t\"name\": \"\(workout.name)\",\n"
            workoutJSON += "\t\t\"exercises\": [\n"
            
            for exercise in workout.exercises {
                workoutJSON += "\t\t\t{\n"
                workoutJSON += "\t\t\t\t\"name\": \"\(exercise.name)\",\n"
                workoutJSON += "\t\t\t\t\"sets\": \(exercise.sets),\n"
                workoutJSON += "\t\t\t\t\"startReps\": \(exercise.startReps),\n"
                workoutJSON += "\t\t\t\t\"targetReps\": \(exercise.targetReps),\n"
                workoutJSON += "\t\t\t\t\"progressionSteps\": \(exercise.progressionSteps),\n"
                workoutJSON += "\t\t\t\t\"notes\": \"\(jsonEscaped(exercise.notes))\",\n"
                workoutJSON += "\t\t\t\t\"exerciseSets\": [\n"
                
                for exerciseSet in exercise.exerciseSets {
                    workoutJSON += "\t\t\t\t\t{\n"
                    workoutJSON += "\t\t\t\t\t\t\"reps\": \(exerciseSet.reps),\n"
                    workoutJSON += "\t\t\t\t\t\t\"weight\": \(exerciseSet.weight),\n"
                    workoutJSON += "\t\t\t\t\t\t\"isComplete\": \(exerciseSet.isComplete)\n"
                    
                    if exerciseSet.id == exercise.exerciseSets.last?.id {
                        workoutJSON += "\t\t\t\t\t}\n"
                    } else {
                        workoutJSON += "\t\t\t\t\t},\n"
                    }
                }
                
                workoutJSON += "\t\t\t\t]\n"
                
                if exercise.id == workout.exercises.last?.id {
                    workoutJSON += "\t\t\t}\n"
                } else {
                    workoutJSON += "\t\t\t},\n"
                }
            }
            
            workoutJSON += "\t\t],\n"
            
            workoutJSON += "\t\t\"hasBeenLogged\": \(workout.hasBeenLogged),\n"
            
            let formatter = ISO8601DateFormatter()
            formatter.formatOptions = [.withInternetDateTime]
            
            let date = formatter.string(from: workout.dateCompleted)
            
            workoutJSON += "\t\t\"dateCompleted\": \"\(date)\"\n"
            
            if workout.id == workouts.last?.id {
                workoutJSON += "\t}\n"
            } else {
                workoutJSON += "\t},\n"
            }
            
            json += workoutJSON
        }
        
        json += "]"
        
        print(json)
        
        // Write to temp file
        let tempURL = FileManager.default.temporaryDirectory
            .appendingPathComponent("workout_log_backup.json")
        
        try json.write(to: tempURL, atomically: true, encoding: .utf8)
        
        return tempURL
    }
    
    static func jsonEscaped(_ string: String) -> String {
        var s = string
        s = s.replacingOccurrences(of: "\\", with: "\\\\")
        s = s.replacingOccurrences(of: "\"", with: "\\\"")
        s = s.replacingOccurrences(of: "\n", with: "\\n")
        s = s.replacingOccurrences(of: "\r", with: "\\r")
        s = s.replacingOccurrences(of: "\t", with: "\\t")
        return s
    }
}
