//
//  ExecuteWorkoutRowView.swift
//  RadicalWorkoutTracker
//
//  Created by Andrew Harrington on 12/14/25.
//

import SwiftUI

struct ExecuteWorkoutRowView: View {
    var workout: Workout
    var exercise: Exercise
    @State private var notes = ""
    @State private var startReps = 0
    @State private var progressionSteps = 0.0
    @State private var weight = 0.0
    
    var body: some View {
        VStack(alignment: .leading) {
            // MARK: Exercise notes
            TextField("Exercise notes", text: $notes)
                .onChange(of: notes) { oldValue, newValue in
                    exercise.notes = notes
                }
            
            Divider()
            
            ForEach(0..<exercise.exerciseSets.count) { index in
                ExecuteSetRowView(workout: workout, exercise: exercise, index: index)
                
                if index < exercise.exerciseSets.count - 1 {
                    Divider()
                }
            }
        }
        .onAppear {
            // updates all state vars with exercise data when view appears
            notes = exercise.notes
            startReps = exercise.startReps
            progressionSteps = exercise.progressionSteps
        }
    }
}

#Preview {
    let model = WorkoutModel()
    ExecuteWorkoutRowView(workout: Workout(), exercise: model.workouts[0].exercises[0])
}
