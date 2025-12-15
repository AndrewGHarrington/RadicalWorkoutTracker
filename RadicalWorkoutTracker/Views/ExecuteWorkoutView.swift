//
//  ExecuteWorkoutView.swift
//  RadicalWorkoutTracker
//
//  Created by Andrew Harrington on 12/14/25.
//

import SwiftUI

struct ExecuteWorkoutView: View {
    var workout: Workout
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        VStack {
            List(workout.exercises) { exercise in
                Section("\(exercise.name): \(exercise.startReps) - \(exercise.targetReps) reps") {
                    ExecuteWorkoutRowView(exercise: exercise)
                }
            }
        }
        .navigationTitle(workout.name)
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .confirmationAction) {
                Button("Save", role: .confirm) {
                    // TODO: Save workout
                    dismiss()
                }
                
            }
            
            ToolbarItem(placement: .cancellationAction) {
                Button("Cancel", role: .cancel) { dismiss() }
            }
        }
    }
}

#Preview {
    let model = WorkoutModel()
    ExecuteWorkoutView(workout: model.workouts[0])
}
