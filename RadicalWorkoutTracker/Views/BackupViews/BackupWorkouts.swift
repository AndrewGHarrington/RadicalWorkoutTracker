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
    @State private var isShowingImporter = false
    @State private var fileName = ""
    @State private var didFinishImport = false
    @State private var alertTitle = "Workout Imported"
    @State private var backupType = BackupType.workout
    
    
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
                backupType = .workout
                isShowingImporter.toggle()
            }
                .frame(maxWidth: 250, maxHeight: 50)
                .background(Color(red: 34/255, green: 87/255, blue: 122/255))
                .clipShape(.rect(cornerRadius: 8))
                .foregroundStyle(.white)
                .font(.title3)
                .bold()
            Button("Import Log") {
                backupType = .log
                isShowingImporter.toggle()
            }
                .frame(maxWidth: 250, maxHeight: 50)
                .background(Color(red: 1/255, green: 42/255, blue: 74/255))
                .clipShape(.rect(cornerRadius: 8))
                .foregroundStyle(.white)
                .font(.title3)
                .bold()
        }
        .alert(alertTitle, isPresented: $didFinishImport, actions: {
            Button("OK", role: .close) {}
        })
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
        .fileImporter(
            isPresented: $isShowingImporter,
            allowedContentTypes: [.json],
            allowsMultipleSelection: false
        ) { result in
            handleImport(result, backupType: backupType)
        }
    }
    
    private func handleImport(_ result: Result<[URL], Error>, backupType: BackupType) {
        do {
            guard let url = try result.get().first else { return }
            
            // Required when accessing files outside your sandbox
            guard url.startAccessingSecurityScopedResource() else {
                throw NSError(domain: "PermissionError", code: 1)
            }
            defer { url.stopAccessingSecurityScopedResource() }
            
            do {
                let data = try Data(contentsOf: url)
                let decoder = JSONDecoder()
                decoder.dateDecodingStrategy = .iso8601
                let workouts = try decoder.decode([Workout].self, from: data)
                
                for workout in workouts {
                    workout.id = UUID()
                    
                    for exercise in workout.exercises {
                        exercise.id = UUID()
                        
                        for exerciseSet in exercise.exerciseSets {
                            exerciseSet.id = UUID()
                        }
                    }
                }
                
                errorMessage = nil
                
                if backupType == .workout {
                    workoutModel.workouts = workouts
                    alertTitle = "Workout Imported"
                } else {
                    let workouts = DataService.getTempData(backupType: .log)
                    var entries = [LogEntry]()
                    
                    for workout in workouts {
                        let logEntry = LogEntry(entry: workout)
                        entries.append(logEntry)
                    }
                    
                    logModel.entries = entries
                    
                    alertTitle = "Log Imported"
                }
                
                didFinishImport.toggle()
                
            } catch {
                print(error)
            }
        } catch {
            errorMessage = error.localizedDescription
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
        .environmentObject(WorkoutModel())
        .environmentObject(LogEntryModel())
}
