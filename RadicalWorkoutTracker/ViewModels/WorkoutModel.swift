//
//  WorkoutModel.swift
//  RadicalWorkoutTracker
//
//  Created by Andrew Harrington on 12/13/25.
//

import Foundation
internal import Combine

class WorkoutModel: ObservableObject {
    @Published var workouts = [Workout]()
    
    init() {
        self.workouts = DataService.getTempData()
    }
}
