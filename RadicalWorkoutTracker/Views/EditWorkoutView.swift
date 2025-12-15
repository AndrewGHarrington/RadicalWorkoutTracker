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
    @State private var exerciseName = ""
    @State private var exercises = [Exercise]()
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationView {
            VStack(alignment: .leading, spacing: 20) {
                HStack {
                    Button {
                        // append exercise to exercises
                        if exerciseName != "" {
                            let newExercise = Exercise()
                            newExercise.name = exerciseName
                            exercises.append(newExercise)
                            exerciseName = ""
                        }
                    } label: {
                        Image(systemName: "plus.square")
                    }
                    .accessibilityLabel("Add exercise")
                    
                    TextField("Exercise name", text: $exerciseName)
                }
                
                Divider()
                
                TextField("Edit workout name", text: $workoutName)
                    .font(.system(size: 20)).bold()
                
                ScrollViewReader { proxy in
                    List {
                        ForEach(exercises) { exercise in
                            Section {
                                EditExerciseRowView(exercise: exercise) {
                                    if let index = exercises.firstIndex(where: { $0.id == exercise.id }) {
                                        exercises.remove(at: index)
                                    }
                                }
                                .id(exercise.id)
                            }
                        }
                    }
                    .onChange(of: exercises.count) {
                        guard let lastId = exercises.last?.id else { return }
                        
                        withAnimation {
                            proxy.scrollTo(lastId, anchor: .bottom)
                        }
                    }
                }
                
                Spacer()
            }
            .padding()
            .navigationTitle("Edit Workout")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save", role: .confirm) {
                        if workout == nil {
                            let newWorkout = Workout()
                            newWorkout.name = workoutName
                            newWorkout.exercises = exercises
                            
                            // create exercise set, update its reps base on exercise
                            // append to exercise's exerciseSets property
                            for exercise in exercises {
                                for _ in 0..<exercise.sets {
                                    let exerciseSet = ExerciseSet()
                                    exerciseSet.reps = exercise.startReps
                                    
                                    exercise.exerciseSets.append(exerciseSet)
                                }
                            }
                            
                            model.workouts.append(newWorkout)
                        } else {
                            if let index = model.workouts.firstIndex(where: { $0.id == workout?.id }) {
                                workout!.name = workoutName
                                model.workouts[index] = workout!
                                model.workouts[index].exercises = exercises
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
                exercises = workout!.exercises
            }
        }
    }
}

#Preview {
    let model = WorkoutModel()
    EditWorkoutView(model: model)
}
