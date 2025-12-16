//
//  LogEntryDetailView.swift
//  RadicalWorkoutTracker
//
//  Created by Andrew Harrington on 12/15/25.
//

import SwiftUI

struct LogEntryDetailView: View {
    var entry: LogEntry
    @State private var workout = Workout()
    
    var body: some View {
        VStack {
            Text(entry.entry.dateCompleted.formatted(date: .long, time: .shortened))
            
            List(workout.exercises) { exercise in
                
                Section("\(exercise.name): \(exercise.startReps) - \(exercise.targetReps) reps") {
                    Text("Notes: \(exercise.notes)")
                    
                    ForEach(exercise.exerciseSets) { exerciseSet in
                        if exerciseSet.isComplete {
                            Text("\(exerciseSet.reps) x \(exerciseSet.weight.formatted())")
                        }
                    }
                }
            }
        }
        .navigationTitle(entry.entry.name)
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            workout = entry.entry
        }
    }
}

#Preview {
    LogEntryDetailView(entry: LogEntry())
}
