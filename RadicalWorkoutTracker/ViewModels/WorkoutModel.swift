//
//  WorkoutModel.swift
//  RadicalWorkoutTracker
//
//  Created by Andrew Harrington on 12/13/25.
//

import Foundation
internal import Combine

class WorkoutModel: ObservableObject {
    private let workoutKey = "Workouts"
    
    @Published var workouts = [Workout]() {
        didSet {
            if let encoded = try? JSONEncoder().encode(workouts) {
                UserDefaults.standard.set(encoded, forKey: workoutKey)
            }
        }
    }
    
    init() {
        if let savedWorkouts = UserDefaults.standard.data(forKey: workoutKey) {
            if let decodedWorkouts = try? JSONDecoder().decode([Workout].self, from: savedWorkouts) {
                self.workouts = decodedWorkouts
                
                return
            }
        }
        
        self.workouts = []
    }
}
