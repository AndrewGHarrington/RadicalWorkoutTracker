//
//  EditWorkoutView.swift
//  RadicalWorkoutTracker
//
//  Created by Andrew Harrington on 12/13/25.
//

import SwiftUI

struct EditWorkoutView: View {
    var model: WorkoutModel
    var workout: Workout?
    @State private var workoutName = "Workout 1"
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationView {
            Form {
                TextField("Add workout", text: $workoutName)
                    .font(.title).bold()
            }
            .navigationTitle("Add Workout")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save", role: .confirm) {
                        if workout == nil {
                            let newWorkout = Workout()
                            newWorkout.name = workoutName
                            model.workouts.append(newWorkout)
                        } else {
                            if let index = model.workouts.firstIndex(where: { $0.id == workout?.id }) {
                                workout!.name = workoutName
                                model.workouts[index] = workout!
                            }
                        }
                        
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel", role: .cancel) { dismiss() }
                }
            }
        }
        .onAppear {
            if workout != nil {
                workoutName = workout!.name
            }
        }
    }
}

#Preview {
    let model = WorkoutModel()
    EditWorkoutView(model: model)
}
