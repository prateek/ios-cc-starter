1. We wanna make sure that we don't have the #if-defs if we don't need them.
2. We wanna ensure that we're using only SwiftUI, no UI Kit.
3. Maybe we should keep the template sort of already generated in a subfolder and just rename it and so on instead of generating it from scratch.
4. There seems to be some kind of issue with the makefile that we're generating locally vs in the root of the folder here vs the template directory. They should be separate. They're not right now.
5. We need to ensure that we have instructions for how to build, how to install, how to run the app itself.
6. We wanna make sure that we also have instructions telling Claude.md to do all of those things.
7. We wanna ensure that obviously we do TDD etc.
8. Maybe we want to add a note about the quiet mode vs the verbose mode for xcodebuild xcrun etc.
9. We want to ensure that we write all the logs to the right location. Even in the build instructions and so on. Whatever we're doing, it would be a good idea to just put all of this into the same log file, which will make things easier. 
10. I think we need to ensure that the build, the CI for this repo is working.
