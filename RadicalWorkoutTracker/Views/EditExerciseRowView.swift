//
//  EditExerciseRowView.swift
//  RadicalWorkoutTracker
//
//  Created by Andrew Harrington on 12/14/25.
//

import SwiftUI

struct EditExerciseRowView: View {
    var exercise: Exercise
    @State private var newExercises = [Exercise]()
    @State private var exerciseName = ""
    @State private var sets = 0
    @State private var startReps = 0
    @State private var targetReps = 0
    @State private var progressionSteps = 0.0
    @State private var notes = ""
    
    let onDelete: () -> Void
    
    var body: some View {
        VStack(alignment: .leading) {
            // MARK: Exercise name
            TextField("Exercise name", text: $exerciseName)
                .fontWeight(.bold)
                .onChange(of: exerciseName) { oldValue, newValue in
                    exercise.name = exerciseName
                }
            
            Divider()
            
            // MARK: Number of sets
            HStack {
                Text("Number of sets")
                Spacer()
                TextField("Number of sets", value: $sets, format: .number)
                    .multilineTextAlignment(.center)
                    .frame(maxWidth: 70, minHeight: 40)
                    .background(.gray)
                    .clipShape(.rect(cornerRadius: 5))
                    .font(.system(size: 24)).bold()
                    .onChange(of: sets) { oldValue, newValue in
                        exercise.sets = sets
                    }
            }
            
            Divider()
            
            // MARK: Number of starting reps
            HStack {
                Text("Number of starting reps")
                Spacer()
                TextField("Number of starting reps", value: $startReps, format: .number)
                    .multilineTextAlignment(.center)
                    .frame(maxWidth: 70, minHeight: 40)
                    .background(.gray)
                    .clipShape(.rect(cornerRadius: 5))
                    .font(.system(size: 24)).bold()
                    .onChange(of: startReps) { oldValue, newValue in
                        exercise.startReps = startReps
                        
                        for exerciseSet in exercise.exerciseSets {
                            exerciseSet.reps = exercise.startReps
                        }
                    }
            }
            
            Divider()
            
            // MARK: Number of target reps
            HStack {
                Text("Number of target reps")
                Spacer()
                TextField("Number of target reps", value: $targetReps, format: .number)
                    .multilineTextAlignment(.center)
                    .frame(maxWidth: 70, minHeight: 40)
                    .background(.gray)
                    .clipShape(.rect(cornerRadius: 5))
                    .font(.system(size: 24)).bold()
                    .onChange(of: targetReps) { oldValue, newValue in
                        exercise.targetReps = targetReps
                    }
            }
            
            Divider()
            
            // MARK: Progression steps
            HStack {
                Text("Progression steps")
                Spacer()
                TextField("Progression steps", value: $progressionSteps, format: .number)
                    .multilineTextAlignment(.center)
                    .frame(maxWidth: 70, minHeight: 40)
                    .background(.gray)
                    .clipShape(.rect(cornerRadius: 5))
                    .font(.system(size: 24)).bold()
                    .onChange(of: progressionSteps) { oldValue, newValue in
                        exercise.progressionSteps = progressionSteps
                    }
            }
            
            Divider()
            
            // MARK: Exercise notes
            TextField("Exercise notes", text: $notes)
                .onChange(of: notes) { oldValue, newValue in
                    exercise.notes = notes
                }
            
            Divider()
            
            // MARK: Delete exercise button
            HStack {
                Spacer()
                Button("Delete exercise", role: .destructive) {
                    // Delete exercise
                    onDelete()
                }
                .buttonStyle(.borderless)
                
                Spacer()
            }
            .padding(.top, 5)
        }
        .onAppear {
            // updates all state vars with exercise data when view appears
            exerciseName = exercise.name
            sets = exercise.sets
            startReps = exercise.startReps
            targetReps = exercise.targetReps
            progressionSteps = exercise.progressionSteps
            notes = exercise.notes
        }
    }
}

#Preview {
    EditExerciseRowView(exercise: Exercise(), onDelete: {})
}
