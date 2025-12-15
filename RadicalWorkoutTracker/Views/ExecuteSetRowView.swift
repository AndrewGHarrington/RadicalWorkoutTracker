//
//  ExecuteSetRowView.swift
//  RadicalWorkoutTracker
//
//  Created by Andrew Harrington on 12/14/25.
//

import SwiftUI

struct ExecuteSetRowView: View {
    var exercise: Exercise
    var index: Int
    @State private var completedReps = 0
    @State private var weight = 0.0
    @State private var progressionSteps = 0.0
    @State private var isComplete = false
    
    var body: some View {
        HStack {
            Button("\(index + 1)") {
                exercise.exerciseSets[index].isComplete.toggle()
                isComplete.toggle()
            }
            .font(.system(size: 50))
            .fontWeight(.black)
            .tint(isComplete ? .green : .black)
            .buttonStyle(.borderless)
            
            Spacer()
            
            VStack {
                TextField("", value: $completedReps, format: .number)
                    .multilineTextAlignment(.center)
                    .accessibilityLabel("Completed reps")
                Stepper("Completed Reps", value: $completedReps, in: 0...10000)
                    .labelsHidden()
                    .onChange(of: completedReps) { oldValue, newValue in
                        exercise.exerciseSets[index].reps = completedReps
                    }
            }
            
            Spacer()
            
            VStack {
                TextField("", value: $weight, format: .number)
                    .multilineTextAlignment(.center)
                    .accessibilityLabel("Weight")
                Stepper("Weight Reps", value: $weight, in: 0...10000, step: progressionSteps)
                    .labelsHidden()
                    .onChange(of: weight) { oldValue, newValue in
                        exercise.exerciseSets[index].weight = weight
                    }
            }
        }
        .onAppear {
            completedReps = exercise.startReps
            weight = exercise.exerciseSets[index].weight
            progressionSteps = exercise.progressionSteps
            isComplete = exercise.exerciseSets[index].isComplete
        }
    }
}

#Preview {
    let model = WorkoutModel()
    ExecuteSetRowView(exercise: model.workouts[0].exercises[0], index: 0)
}
