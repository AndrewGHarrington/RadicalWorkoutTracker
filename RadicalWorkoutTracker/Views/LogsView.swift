//
//  LogsView.swift
//  RadicalWorkoutTracker
//
//  Created by Andrew Harrington on 12/15/25.
//

import SwiftUI
import UniformTypeIdentifiers

struct JSONFile: FileDocument {

    static var readableContentTypes: [UTType] { [.json] }

    var url: URL?

    init(url: URL?) {
        self.url = url
    }

    init(configuration: ReadConfiguration) throws {
        // Not needed for export
    }

    func fileWrapper(configuration: WriteConfiguration) throws -> FileWrapper {
        guard let url,
              let data = try? Data(contentsOf: url) else {
            throw CocoaError(.fileNoSuchFile)
        }

        return FileWrapper(regularFileWithContents: data)
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
                        do {
                            exportURL = try WorkoutExporter.exportToJSON()
                            isExporting = true
                        } catch {
                            errorMessage = error.localizedDescription
                        }
                    }
                    .labelStyle(.iconOnly)
                }
            }
            .fileExporter(
                isPresented: $isExporting,
                document: JSONFile(url: exportURL),
                contentType: .json,
                defaultFilename: "workouts_backup"
            ) { result in
                if case .failure(let error) = result {
                    errorMessage = error.localizedDescription
                }
            }
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
