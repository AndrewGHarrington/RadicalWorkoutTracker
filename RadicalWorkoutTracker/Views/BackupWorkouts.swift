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
            Button("Backup Workouts") {}
                .frame(maxWidth: 250, maxHeight: 50)
                .background(Color(red: 87/255, green: 204/255, blue: 153/255))
                .clipShape(.rect(cornerRadius: 8))
                .foregroundStyle(.white)
                .font(.title3)
                .bold()
            Button("Backup Log") {}
                .frame(maxWidth: 250, maxHeight: 50)
                .background(Color(red: 56/255, green: 163/255, blue: 165/255))
                .clipShape(.rect(cornerRadius: 8))
                .foregroundStyle(.white)
                .font(.title3)
                .bold()
                .padding(.bottom, 50)
            
            Button("Import") {}
                .frame(maxWidth: 250, maxHeight: 50)
                .background(Color(red: 34/255, green: 87/255, blue: 122/255))
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
    
    func exportLogs() {
        do {
            exportURL = try DataService.compileJSONAndExportFile(logModel.entries)
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
