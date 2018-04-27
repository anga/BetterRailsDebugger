## 0.2.1
* Fixed backtrace generation
## 0.2.0
* Generate backtrace information for every object creation
## 0.1.1
* Created the bases of ruby code analyzer (Ruby parser and ruby processor)
* Created basic ruby parser extension/module system to allow other developers creates his owns extensions 
(still not integrated with front end)
* Created basic code of ContextDefiner extension as part of extension core
* Created basic documentation about how to make your own extension and about ContextDefiner usage
## 0.1.0
* Renamed `BetterRailsDebugger::MemoryAnalyzer` to `BetterRailsDebugger::Analyzer`
* Group Instance view now display a summary about memory
* Notice to the user about big files
* Notice to the user about classes that consume big amounts of memory
* Some code refactoring
## 0.0.3
* Removed rouge dependency
* List file with more allocations
* List files with more memory consumption
* Do not track our-self in memory tracker
* Code refactoring
## 0.0.2
* Added sort and filter option inside object instance view
## 0.0.1
* Initial publish