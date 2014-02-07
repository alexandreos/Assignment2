Assignment 2
===================
This is a native iOS implementation of the Assignment 2.

## How To Install

- Install Xcode (https://itunes.apple.com/br/app/xcode/id497799835?l=en&mt=12)
- Clone this repo on your mac using Xcode or any other git client you like.

### Install Cocoapods

From the terminal, run the commands:

````
sudo gem install cocoapods
pod setup
````

From the project's folder (Example: cd ~/Projects/iOS/assignment2):

````
pod install
````

If you already had Cocoapods installed and got an error tying to run `pod install`, try to re-clone the Cocoapds repository:

````
pod repo remove master
pod setup
````
[Click here for more info about this Cocoapods issue](http://blog.cocoapods.org/Repairing-Our-Broken-Specs-Repository/)

After this initial setup, open the `Assignment2.xcworkspace` file and you are good to go :)

## App Architecture

### Project Dependencies

- [OSReflectionKit](https://github.com/iAOS/OSReflectionKit): Used for handling serialization/deserialization of models from JSON and NSDictionaries.
- [FMDB](https://github.com/ccgus/fmdb): Used for handling SQLite.
- [IDMPhotoBrowser](https://github.com/ideaismobile/IDMPhotoBrowser): Only used to display the product photo.

I also used some other libraries and helper classes that I had created before, which are in the `Classes/Util/` folder.

### Some Assumptions

- I was not concerned about styling the UI. As far as I understood, the main goal was to handle different types of data and persist this data into a SQLite database.

- There are 2 persisted models in this app: Product and Color.
- The product photo is stored as a photo name in the database. The actual image is read from the Assets catalog.
- A product can have many colors.
- A color stores the color name and an ARGB integer representing a 32 bit color.
