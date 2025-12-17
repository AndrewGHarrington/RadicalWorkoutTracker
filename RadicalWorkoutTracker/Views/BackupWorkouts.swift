//
//  BackupWorkouts.swift
//  RadicalWorkoutTracker
//
//  Created by Andrew Harrington on 12/16/25.
//

import SwiftUI
import UniformTypeIdentifiers

struct BackupWorkouts: View {
    @EnvironmentObject var workoutModel: WorkoutModel
    @EnvironmentObject var logModel: LogEntryModel
    @State private var exportURL: URL?
    @State private var isExporting = false
    @State private var errorMessage: String?
    @State private var fileName = ""
    
    var body: some View {
        VStack {
            Button("Backup Workouts") {
                fileName = "workouts_backup"
                export(workoutModel.workouts, backupType: .workout)
            }
                .frame(maxWidth: 250, maxHeight: 50)
                .background(Color(red: 87/255, green: 204/255, blue: 153/255))
                .clipShape(.rect(cornerRadius: 8))
                .foregroundStyle(.white)
                .font(.title3)
                .bold()
            Button("Backup Log") {
                var workouts = [Workout]()
                
                for entry in logModel.entries {
                    workouts.append(entry.entry)
                }
                
                fileName = "log_backup"
                export(workouts, backupType: .log)
            }
                .frame(maxWidth: 250, maxHeight: 50)
                .background(Color(red: 56/255, green: 163/255, blue: 165/255))
                .clipShape(.rect(cornerRadius: 8))
                .foregroundStyle(.white)
                .font(.title3)
                .bold()
                .padding(.bottom, 50)
            
            Button("Import Workouts") {
                let workouts = DataService.getTempData(backupType: .workout)
                workoutModel.workouts = workouts
            }
                .frame(maxWidth: 250, maxHeight: 50)
                .background(Color(red: 34/255, green: 87/255, blue: 122/255))
                .clipShape(.rect(cornerRadius: 8))
                .foregroundStyle(.white)
                .font(.title3)
                .bold()
            Button("Import Log") {
                let workouts = DataService.getTempData(backupType: .log)
                var entries = [LogEntry]()
                
                for workout in workouts {
                    let logEntry = LogEntry(entry: workout)
                    entries.append(logEntry)
                }
                
                logModel.entries = entries
            }
                .frame(maxWidth: 250, maxHeight: 50)
                .background(Color(red: 1/255, green: 42/255, blue: 74/255))
                .clipShape(.rect(cornerRadius: 8))
                .foregroundStyle(.white)
                .font(.title3)
                .bold()
        }
        .fileExporter(
            isPresented: $isExporting,
            document: exportURL.map { JSONDocument(fileURL: $0) },
            contentType: .json,
            defaultFilename: fileName
        ) { result in
            if case let .failure(error) = result {
                errorMessage = error.localizedDescription
            }
        }
    }
    
    func export(_ workouts: [Workout], backupType: BackupType) {
        do {
            exportURL = try DataService.compileJSONAndExportFile(workouts, backupType: backupType)
            isExporting = true
        } catch {
            errorMessage = error.localizedDescription
        }
    }
    
    func removeRow(_ offsets: IndexSet) {
        logModel.entries.remove(atOffsets: offsets)
    }
}

#Preview {
    BackupWorkouts()
        .environmentObject(LogEntryModel())
}
