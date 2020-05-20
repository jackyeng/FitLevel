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
    case routineworkout
    case plan
    case all
}

protocol DatabaseListener: AnyObject {
    var listenerType: ListenerType {get set}
    func onRoutineChange(change: DatabaseChange, routineWorkouts: [Routine])
    func onWorkoutListChange(change: DatabaseChange, workouts: [Workout])
    func onRoutineWorkoutChange(change: DatabaseChange, workouts: [CustomWorkout])
   
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
    func addPlan(planName: String) //default plan
    func addRoutineToPlan()
   //create ActiveRoutine
    func addActiveRoutine(activeroutineName: String) -> ActiveRoutine
    //create CustomWorkout
    func addCustomWorkout(set: String, repetition: String) -> CustomWorkout
    func addWorkoutToCustomWorkout(workout: Workout, customWorkout: CustomWorkout)
    func addCustomWorkoutToRoutine(customWorkout: CustomWorkout, routine: Routine)
    func getRoutineWorkout(name: String) -> [CustomWorkout]
    //add new workout
    func addWorkout(name: String, imageURL: String?) -> Workout
    //Plan
    
    //Routine
    
    
    /*/Drink
    func addDrink(drinkName: String) -> Drink
    
    //Cocktail
    func addEmptyCocktail() -> Cocktail
    func addCocktail(name: String, instructions: String) -> Cocktail
    func removeCocktailFromDrink(cocktail: Cocktail, drink: Drink)
    func addCocktailToDrink(cocktail: Cocktail,drink:Drink) -> Bool
    func displayCocktail(cocktail: Cocktail) -> Cocktail
   
    
    //Ingredient
    func addIngredient(name: String) -> Ingredient
    func addNewIngredient(name: String)
    
    //Ingredient Measurement
    func addIngredientMeasurement(cocktail: Cocktail, name: String, quantity: String?)
    func deleteIngredientMeasurement(ingredientmeasurement: IngredientMeasurement)
    func removeIngredientMeasurementFromCocktail(cocktail: Cocktail, ingredientmeasurements: IngredientMeasurement)
    */
 
   
    
  
    
    
}
