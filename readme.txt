Please view the LICENSE or License.txt files in subfolders for detailed licenses.
Here is just a simple license overview:
  /res: CC0 License (Public Domain)
  /src: New BSD License
  /external/helper_classes_as3: MIT License
  /external/box2d_as3_v210: zlib License
  /external/box2dflash: zlib License
  /external/box2dex: zlib License
  /external/adobe: Mozilla Public License Version 1.1

-----------

Prerequisited SDKS:
1. JRE (or JDK)
2. Apache Ant
3. Flex SDK 4.6

-----------

Under the project top folder, please create a "local.properties.Windows" file 
for Windows OS or a "local.properties.Linux" file for other OSes. 
Then add a line "Path.FlexSDK=<Path-To-Flex_SDK>" in this file. For example:

   Path.FlexSDK=D:/sdks/flex_sdk_4.6

-----------

Run "ant release-editor" to create a release editor file in ##release folder.
Run "ant debug-editor" to create a debug editor file in #output-editor folder.
