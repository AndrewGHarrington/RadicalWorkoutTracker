//
//  ExerciseSet.swift
//  RadicalWorkoutTracker
//
//  Created by Andrew Harrington on 12/14/25.
//

import Foundation

class ExerciseSet: Identifiable, Codable {
    var id: UUID? = UUID()
    var reps = 0
    var weight = 0.0
    var isComplete = false
}
