//
//  Exercise.swift
//  RadicalWorkoutTracker
//
//  Created by Andrew Harrington on 12/14/25.
//

import Foundation

class Exercise: Identifiable, Codable {
    var id: UUID? = UUID()
    var name = ""
    var sets = 3
    var startReps = 6
    var targetReps = 8
    var progressionSteps = 2.5
    var notes = ""
    var exerciseSets = [ExerciseSet]()
}
