//
//  ExecuteWorkoutView.swift
//  RadicalWorkoutTracker
//
//  Created by Andrew Harrington on 12/14/25.
//

import SwiftUI

struct ExecuteWorkoutView: View {
    @EnvironmentObject var model: WorkoutModel
    @EnvironmentObject var logModel: LogEntryModel
    var workout: Workout
    @State private var isCancelling = false
    @State private var isSaving = false
    
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
                    isSaving.toggle()
                }
                
            }
            
            ToolbarItem(placement: .cancellationAction) {
                Button("Cancel", role: .cancel) {
                    isCancelling.toggle()
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
        .alert("Cancel workout?", isPresented: $isCancelling) {
            Button("No", role: .cancel) {}
            Button("Yes", role: .confirm) {
                if let index = model.workouts.firstIndex(where: { $0.id == workout.id }) {
                    model.workouts[index] = workoutCopy
                    dismiss()
                }
            }
        } message: {
            Text("This session won't be saved in your log.")
        }
        .alert("Finish workout?", isPresented: $isSaving) {
            Button("No", role: .cancel) {}
            Button("Yes", role: .confirm) {
                workout.dateCompleted = Date.now
                
                let newLog = LogEntry(entry: workout)
                logModel.entries.append(newLog)
                
                workout.hasBeenLogged = true
                
                if let index = model.workouts.firstIndex(where: { $0.id == workout.id }) {
                    model.workouts[index] = workout
                }
                
                dismiss()
            }
        } message: {
            Text("This will save this session to your log.")
        }
    }
}

#Preview {
    ExecuteWorkoutView(workout: Workout())
        .environmentObject(WorkoutModel())
        .environmentObject(LogEntryModel())
}
