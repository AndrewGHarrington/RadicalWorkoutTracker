//
//  DataService.swift
//  RadicalWorkoutTracker
//
//  Created by Andrew Harrington on 12/13/25.
//

import Foundation

struct DataService {
    static func getTempData() -> [Workout] {
        let pathString = Bundle.main.path(forResource: "data", ofType: "json")
        
        if let path = pathString {
            let url = URL(filePath: path)
            
            do {
                let data = try Data(contentsOf: url)
                
                let decoder = JSONDecoder()
                
                do {
                    let workouts = try decoder.decode([Workout].self, from: data)
                    
                    for workout in workouts {
                        workout.id = UUID()
                    }
                    
                    return workouts
                } catch {
                    print(error)
                }
            } catch {
                print(error)
            }
        }
        
        return [Workout]()
    }
}
