Assignment 2
===================
This is a native iOS implementation of the Assignment 2.

## App Architecture

### Project Dependencies

- [OSReflectionKit](https://github.com/iAOS/OSReflectionKit): Used for handling serialization/deserialization of models from JSON and NSDictionaries.
- [FMDB](https://github.com/ccgus/fmdb): Used for handling SQLite.
- [IDMPhotoBrowser](https://github.com/ideaismobile/IDMPhotoBrowser): Only used to display the product photo. This library has the following dependencies:
  - [SVProgressHUD](https://github.com/samvermette/SVProgressHUD)
  - [AFNetworking](https://github.com/AFNetworking/AFNetworking)
  - [DACircularProgress](https://github.com/danielamitay/DACircularProgress)

I also used some other libraries and helper classes that I had created before, which are in the `Assignment2/Classes/Util/` folder.

### Some Assumptions

- I was not concerned about styling the UI. As far as I understood, the main goal was to handle different types of data and persist this data into a SQLite database.

- There are 2 persisted models in this app: Product and Color.
- The product photo is stored as a photo name in the database. The actual image is read from the Assets catalog.
- Since SQLite has no Decimal data type, prices are stored in the database as integers (8 Bytes each) and converted to `NSDecimal` when loaded.
- The `NSDictionary` attribute was stored as string in the database and converted to `NSDictionary` when loaded.
- The `id` attribute was renamed to `identifier` in order to not conflict with the Object-C type `id`.
- The `description` attribute was renamed to `productDescription` in order to not conflict with the NSObject's method `-description`.
- A product can have many colors.
- A color belongs to a product.
- A color stores the color name and an ARGB integer representing a 32 bit color.
