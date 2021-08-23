#  Lloyds Bank Tech Test

These instruction are for downloading and running the app  `LBTechTest` .

Prepare for these step by opening the Unicorn Project in XCode.

## Download and run App

1.  https://github.com/JohnGoodstadt/memorizeBusinessAndroid 



2. Run pod install
	in folder with xcodeproj run POD command `pod install` to install all external dependancies 



3. Open workspace in XCode
	use file  `LBTechTestApp.xcworkspace`



4. Hit `Run`


## Notes

1. Performance
	1. didReceiveMemoryWarning() coded to reduce memory footprint - will automatically redownload from google when necessary
	2. Async download of data from google
	3. Alternative data in bundle for quick UI check
	

2. Readability
	1. Markup comments used on main functions
	2. Helper functions do only 1 thing.
	3. Use of swift extensions to simplify main code  see  `Extensions.swift` 


3. Maintainability
	1. Strings file for adjusting any string on 1 place
	2. Depend on interface not concrete object - see DataProvider.swift. This can easily be swopped out for, say, and Amazon backend, with no effect on the App.
	3. AppSettings - configure json settings file to effect running. e.g. changing   `readsamplesfrombundleonload` to false will load from google.
	4. Datasources are general enough to be reused by different ViewControllers, see  `ViewControllerDataSource` .
	5. Helper functions have only 1 reason to change.
	6. Libraries hold similar code for an area - see  `LibraryFilesystem`  and   `SortLibrary` .
	7. Use of Constants file - centralize constants in use see  `Constants.swift`  and  `FirebaseConstants.swift` 
	8. Use of small Global area protected by a singleton design pattern - for App scoped data.

	
4. testability
	1. Seperate entities (see `LBEntities.xcodeproj`) have their own unit tests seperate from main iOS app.
	2. iOS app has seperate set of tests.
	3. Set of json data in bundle - ready for object testing

5. Scalability
	1. Strings file system for using a completly different set of strings for another target
	2. Reading groups and items from the google database will expand to however many are required
	3. The 2 Objects (Groups and Items) are joined at load time to flexibly scale upwards.
	4. mp3s are stored, and read from 1 of 3 locations - memory, mp3 file in documents folder, from Google's DB. All 3 are automatically utilised.
	5. If any more items are added to Google's DB offline - they will appear in the app on next load.
	
6. Simplicity
	1. Only 2 model objects - items and groups (RecallItem and RecallGroup)
	2. These 2 entity level objects are included to a seperate project. These can be included into Mac App/Web App if necessary.  
	3. ViewControllers are relativly small, outsourcing processing tableview to datasources
	4. Offloading of functions to static libraries so no side effects on ivar/global data. These can be further isolated in to out-of-app entities if necessary

7. Robust
	1. Usage of  `Guard` statements to protect routines. e.g. all NetworkingFirebase functions require a valid google userid
	
8. Further changes yet to be made
	1. Expand all tests to cover all functionality.
	2. Add UI testing see  `testPerformanceExample`.
	3. Make  `LibraryFilesystem` depend on an interface - similar to  `DataProvider` 
	4. Make a ViewModel object for each ViewController to simplify ViewController testing.
	


