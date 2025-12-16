//
//  ExecuteWorkoutView.swift
//  RadicalWorkoutTracker
//
//  Created by Andrew Harrington on 12/14/25.
//

import SwiftUI

struct ExecuteWorkoutView: View {
    var model: WorkoutModel
    var workout: Workout
    var logModel: LogEntryModel
    
    // just used for cancel to throw away any changes to workout
    @State private var workoutCopy = Workout()
    
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        VStack {
            List(workout.exercises) { exercise in
                Section("\(exercise.name): \(exercise.startReps) - \(exercise.targetReps) reps") {
                    ExecuteWorkoutRowView(workout: workout, exercise: exercise)
                }
            }
        }
        .navigationTitle(workout.name)
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .confirmationAction) {
                Button("Save", role: .confirm) {
                    // MARK: Save workout
                    workout.dateCompleted = Date.now
                    
                    let newLog = LogEntry(entry: workout)
                    logModel.entries.append(newLog)
                    
                    workout.hasBeenLogged = true
                    
                    if let index = model.workouts.firstIndex(where: { $0.id == workout.id }) {
                        model.workouts[index] = workout
                    }
                    
                    dismiss()
                }
                
            }
            
            ToolbarItem(placement: .cancellationAction) {
                Button("Cancel", role: .cancel) {
                    if let index = model.workouts.firstIndex(where: { $0.id == workout.id }) {
                        model.workouts[index] = workoutCopy
                    }
                    
                    dismiss()
                }
            }
        }
        .onAppear {
            workoutCopy.id = UUID()
            workoutCopy.name = workout.name
            workoutCopy.exercises = [Exercise]()
            workoutCopy.hasBeenLogged = workout.hasBeenLogged
            
            for i in 0..<workout.exercises.count {
                let exercise = Exercise()
                exercise.id = UUID()
                exercise.name = workout.exercises[i].name
                exercise.sets = workout.exercises[i].sets
                exercise.startReps = workout.exercises[i].startReps
                exercise.targetReps = workout.exercises[i].targetReps
                exercise.progressionSteps = workout.exercises[i].progressionSteps
                exercise.notes = workout.exercises[i].notes
                exercise.exerciseSets = [ExerciseSet]()
                
                for j in 0..<workout.exercises[i].exerciseSets.count {
                    let exerciseSet = ExerciseSet()
                    exerciseSet.id = UUID()
                    exerciseSet.reps = workout.exercises[i].exerciseSets[j].reps
                    exerciseSet.weight = workout.exercises[i].exerciseSets[j].weight
                    exerciseSet.isComplete = false
                    
                    exercise.exerciseSets.append(exerciseSet)
                    
                    workout.exercises[i].exerciseSets[j].isComplete = false
                }
                
                workoutCopy.exercises.append(exercise)
            }
        }
    }
}

#Preview {
    let model = WorkoutModel()
    ExecuteWorkoutView(model: model, workout: model.workouts[0], logModel: LogEntryModel())
}
