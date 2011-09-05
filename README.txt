HyvesApiLibrary

Copyright (c) 2011 Hyves

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and
associated documentation files (the "Software"), to deal in the Software without restriction, including
without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the
following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial
portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT 
LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO
EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER
IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR
THE USE OR OTHER DEALINGS IN THE SOFTWARE.

=============================================================================================================

HyvesApiExample demonstrates the use of HyvesApiLibrary in an iOS project.
For more information on the Hyves API, see: http://www.hyves-developers.nl/documentation/data-api/home

In the example, the library is used a static library, and its sources are included in the example as an Xcode subproject.

==========================================================
To compile the example, do the following:
==========================================================

- Download the HyvesApiLibrary sources from GitHub: https://github.com/serieuxchat/HyvesApiLibrary.

- In order to compile the library you will also need to download the sources of TouchJSON (for more information, see the README file included with HyvesApiLibrary sources).

- Download the HyvesApiExample sources from GitHub: https://github.com/serieuxchat/HyvesApiExample.

- To compile the example project together with the library, Xcode should be told where the library sources are located:
  In Xcode, do the following:
  - Navigate to XCode -> Preferences -> Locations
  - Under "Derived Data" click "Advanced"
  - For "Build Location" choose "Location Specified by Targets" (from the drop-down list).
  - Click "Done"
  - Navigate to XCode -> Preferences -> Source Trees (in XCode 4.2 it's XCode -> Preferences -> Locations -> Source Trees)
    - Add an environment variable HYVES_API_LIB_DIR and specify the absolute path to the HyvesApiLibrary sources
       (e.g. /Users/mike/projects/HyvesApiLibrary )
  
  - In order to connect to Hyves you need to obtain a valid consumer ID/secret pair. You can do this at http://www.hyves.nl/developer/

  - Once you have a valid consumer ID and secret, you should put them into the code in the method
    application:didFinishLaunchingWithOptions: (HyvesApiExampleAppDelegate.m)
   
    You will get a compiler warning if you don't do it.

  - Build and run the project.

NOTE: Currently the project is set up in such a way that the library is NOT automatically rebuilt if its sources are modified.
    You will need to use the "Clean" option to force the library to be regenerated whenever you have modified its sources.
    This is due to a limitation in the way Xcode generates paths for the built products when "Build" or "Archive" is used to build the final app executable.
    
==========================================================
Short Description of the Example
==========================================================

The example demonstrates the following functional areas of the library:

- Authorization and de-authorization (login/logout).
- Defining custom API handlers.





