//
//  DatabaseProtocol.swift
//  FitLevel
//
//  Created by Jacky Eng on 09/05/2020.
//  Copyright © 2020 Jacky Eng. All rights reserved.
//


import Foundation

enum DatabaseChange {
    case add
    case remove
    case update
}
enum ListenerType {
    case routine
    case workout
    case workoutstats
    case routineworkout
    case plan
    case all
}

protocol DatabaseListener: AnyObject {
    var listenerType: ListenerType {get set}
    func onRoutineChange(change: DatabaseChange, routineWorkouts: [Routine])
    func onWorkoutListChange(change: DatabaseChange, workouts: [Workout])
    func onRoutineWorkoutChange(change: DatabaseChange, workout: [CustomWorkout])
    func onPlanListChange(change: DatabaseChange, recommendedPlan: [Routine])
}
protocol DatabaseProtocol: AnyObject {
    var activeRoutine: ActiveRoutine {get}

    func cleanup()
    func addListener(listener: DatabaseListener)
    func removeListener(listener: DatabaseListener)
    func saveDraft()
    func discardDraft()
    
    //Workout
    func addWorkoutToPlan(workout: Workout, plan: Plan) -> Bool
    //create routine
    func addRoutine(routineName: String) -> Routine
    func addWorkoutToRoutine(workout: Workout, routine: Plan) -> Bool
    func addRoutineToActive(routine: Routine, active: ActiveRoutine) -> Bool
    //create plan/ saved routine
    func addPlan(planName: String) -> Plan //default plan
    func addWorkoutDate(year: Int, month: Int, day: Int)
    func getWorkoutDate(year: Int, month: Int) -> [WorkoutDate]
    func addRoutineToPlan(routine: Routine, plan: Plan) -> Bool
   //create ActiveRoutine
    func addActiveRoutine(activeroutineName: String) -> ActiveRoutine
    //create CustomWorkout
    func addCustomWorkout(set: String, repetition: String, duration: String) -> CustomWorkout
    func addWorkoutToCustomWorkout(workout: Workout, customWorkout: CustomWorkout)
    func addCustomWorkoutToRoutine(customWorkout: CustomWorkout, routine: Routine)
    func getRoutineWorkout(name: String) -> [CustomWorkout]
    //add new workout
    func addWorkout(name: String, imageURL: String?, level: Int) -> Workout
    func addEmptyRoutine() -> Routine
    //Removal
    func removeRoutinefromActive(active: ActiveRoutine, routine: Routine)
    
    //Routine

 
   
    
  
    
    
}
