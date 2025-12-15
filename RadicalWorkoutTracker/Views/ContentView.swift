//
//  ContentView.swift
//  RadicalWorkoutTracker
//
//  Created by Andrew Harrington on 12/13/25.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var model = WorkoutModel()
    @Environment(\.dismiss) var dismiss
    @State private var isAddingWorkouts = false
    @State private var selectedWorkout: Workout?
    
    var body: some View {
        NavigationView {
            List {
                ForEach(model.workouts) { workout in
                    NavigationLink {
                        ExecuteWorkoutView(workout: workout)
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
                                    
                                    Button("Delete", systemImage: "trash", role: .destructive) {}
                                    .tint(.red)
                                    .labelStyle(.iconOnly)
                                }
                            
                            ForEach(workout.exercises) { exercise in
                                Text("• \(exercise.name)")
                            }
                        }
                    }

                }
                .onDelete(perform: removeRows)
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
    
    func removeRows(at offsets: IndexSet) {
        model.workouts.remove(atOffsets: offsets)
    }
}

#Preview {
    ContentView()
}
