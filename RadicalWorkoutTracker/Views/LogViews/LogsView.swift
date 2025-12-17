//
//  LogsView.swift
//  RadicalWorkoutTracker
//
//  Created by Andrew Harrington on 12/15/25.
//

import SwiftUI
import UniformTypeIdentifiers

struct JSONDocument: FileDocument {
    static var readableContentTypes: [UTType] { [.json] }
    
    let fileURL: URL
    
    init(fileURL: URL) {
        self.fileURL = fileURL
    }
    
    init(configuration: ReadConfiguration) throws {
        throw CocoaError(.fileReadUnsupportedScheme)
    }
    
    func fileWrapper(configuration: WriteConfiguration) throws -> FileWrapper {
        return try FileWrapper(url: fileURL)
    }
}



struct LogsView: View {
    @EnvironmentObject var logModel: LogEntryModel
    @State private var exportURL: URL?
    @State private var isExporting = false
    @State private var errorMessage: String?
    
    var body: some View {
        NavigationView {
            VStack {
                if logModel.entries.isEmpty {
                    Text("No entries in log")
                } else {
                    List {
                        ForEach(logModel.entries) { entry in
                            NavigationLink {
                                LogEntryDetailView(entry: entry)
                            } label: {
                                VStack(alignment: .leading) {
                                    Text(entry.entry.name)
                                        .font(.title2)
                                        .fontWeight(.heavy)
                                    
                                    Text(entry.entry.dateCompleted.formatted(date: .long, time: .shortened))
                                        .font(.system(size: 14))
                                        .foregroundStyle(Color(red: 0.8, green: 0.8, blue: 0.8))
                                    
                                }
                            }
                        }
                        .onDelete(perform: removeRow)
                    }
                }
            }
            .navigationTitle("Log")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Export logs", systemImage: "square.and.arrow.up") {
                        // MARK: Export logs
                        exportLogs()
                    }
                    .labelStyle(.iconOnly)
                }
            }
            .fileExporter(
                isPresented: $isExporting,
                document: exportURL.map { JSONDocument(fileURL: $0) },
                contentType: .json,
                defaultFilename: "workout_log_backup"
            ) { result in
                if case let .failure(error) = result {
                    errorMessage = error.localizedDescription
                }
            }
        }
    }
    
    func exportLogs() {
        var workouts = [Workout]()
        
        for entry in logModel.entries {
            workouts.append(entry.entry)
        }
        
        do {
            exportURL = try DataService.compileJSONAndExportFile(workouts, backupType: .log)
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
    LogsView()
        .environmentObject(LogEntryModel())
}
