//
//  Workout.swift
//  RadicalWorkoutTracker
//
//  Created by Andrew Harrington on 12/13/25.
//

import Foundation

class Workout: Identifiable, Codable {
    var id: UUID? = UUID()
    var name = ""
    var exercises = [Exercise]()
}
