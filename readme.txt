Please view the LICENSE or License.txt files in subfolders for detailed licenses.
Here is just a simple license overview:
  /res: CC0 License (Public Domain)
  /src: New BSD License
  /external/helper_classes_as3: MIT License
  /external/box2d_as3_v210: zlib License
  /external/box2dflash: zlib License
  /external/box2dex: zlib License

-----------

Prerequisited SDKS:
1. Java SDK or JRE
2. Ant
3. Flex SDK 3.5.0 (doesn't test on newer versions)

-----------

Under the project top fodler, create a "local.properties.Windows" file 
for Windows OS or a "local.properties.Linux" file for other OSes. 
Then add a line "Path.FlexSDK=<Path-To-Flex_SDK>" in this file. For example:

   Path.FlexSDK=D:/sdks/flex_sdk_3.5.0

-----------

Run "ant release-editor" to create a release editor file in ##release folder.
Run "ant debug-editor" to create a release editor file in #output-editor folder.
