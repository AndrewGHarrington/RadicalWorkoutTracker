//
//  DataService.swift
//  RadicalWorkoutTracker
//
//  Created by Andrew Harrington on 12/13/25.
//

import Foundation

struct DataService {
    static func getTempData() -> [Workout] {
        guard let url = Bundle.main.url(forResource: "data", withExtension: "json") else {
            return [Workout]()
        }
        
        do {
            let data = try Data(contentsOf: url)
            let decoder = JSONDecoder()
            let workouts = try decoder.decode([Workout].self, from: data)
            
            for workout in workouts {
                workout.id = UUID()
                
                for exercise in workout.exercises {
                    exercise.id = UUID()
                }
            }
            
            return workouts
        } catch {
            print(error)
        }
        
        return [Workout]()
    }
}
