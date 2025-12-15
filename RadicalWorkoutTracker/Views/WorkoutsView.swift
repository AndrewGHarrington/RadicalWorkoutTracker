//
//  WorkoutsView.swift
//  RadicalWorkoutTracker
//
//  Created by Andrew Harrington on 12/13/25.
//

import SwiftUI

struct WorkoutsView: View {
    @ObservedObject var model = WorkoutModel()
    var logModel: LogEntryModel
    @Environment(\.dismiss) var dismiss
    @State private var isAddingWorkouts = false
    @State private var selectedWorkout: Workout?
    
    var body: some View {
        NavigationView {
            Group {
                if model.workouts.isEmpty {
                    Button("Add workout") {
                        isAddingWorkouts.toggle()
                    }
                        .padding(.horizontal, 50)
                        .padding(.vertical, 10)
                        .background(.mint)
                        .foregroundStyle(.white)
                        .font(.system(size: 20))
                        .bold()
                        .clipShape(.rect(cornerRadius: 5))
                        .shadow(color: Color(red: 0, green: 0, blue: 0, opacity: 0.2), radius: 5, y: 5)
                } else {
                    List {
                        ForEach(model.workouts) { workout in
                            NavigationLink {
                                ExecuteWorkoutView(model: model, workout: workout, logModel: logModel)
                            } label: {
                                VStack(alignment: .leading) {
                                    Text(workout.name)
                                        .font(.system(size: 28))
                                        .fontWeight(.bold)
                                        .swipeActions(edge: .trailing) {
                                            Button {
                                                selectedWorkout = workout
                                            } label: {
                                                Label("Edit", systemImage: "pencil")
                                                    .tint(.yellow)
                                                    .labelStyle(.iconOnly)
                                            }
                                            
                                            Button("Delete", systemImage: "trash", role: .destructive) {
                                                if let index = model.workouts.firstIndex(where: { $0.id == workout.id }) {
                                                    model.workouts.remove(at: index)
                                                }
                                            }
                                            .tint(.red)
                                            .labelStyle(.iconOnly)
                                        }
                                    
                                    ForEach(workout.exercises) { exercise in
                                        Text("• \(exercise.name)")
                                    }
                                }
                            }

                        }
                    }
                }
            }
            .navigationTitle("Workouts")
            .toolbar {
                Button("Add", systemImage: "plus") {
                    isAddingWorkouts.toggle()
                }
            }
            .sheet(isPresented: $isAddingWorkouts) {
                EditWorkoutView(model: model)
            }
            .sheet(item: $selectedWorkout) { workout in
                EditWorkoutView(model: model, workout: workout)
            }
        }
    }
}

#Preview {
    WorkoutsView(logModel: LogEntryModel())
}
