
README
-----------
DIFFERENCE FROM INITIAL DESIGN
-------------------------------------------
//Did not implement filtering workout by muscle group
//Changed Gyroscope technology to Gesture technology
//Replaced Web API Services with Firebase User Authentication as the workout contents are stored locally and does not need API.

LIMITATION
--------------
//Couldn't implement ChildManageObject
//Couldn't implement reordering of the tableviewcell to allow users to reorder their workouts. 
//Constraints issue in HomeScreenViewController and WorkoutRoutineViewController due to too many components.

DESIGN CHOICES
----------------------
GENERAL
//Hide tab bar during workout to prevent inconsistency
//Only increases level if user complete workout on time to discourage user from skipping workout

OBJECTS
//2 layers of objects (Workout & CustomWorkout) to allow users to customize their workout by making changes to CustomWorkout Object without affecting the original Workout object.

WORKING OUT
//Added a video tutorial as per feedback allows user to perform the workout
//Added audio notification as per feedback allows user to focus on their workout
//Added a warm up period for user to prepare for next workout




