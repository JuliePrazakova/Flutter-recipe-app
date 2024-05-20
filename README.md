# Device-Agnostic Design Course Project II

## Recipe app
### Description
This recipe application simplifies cooking by providing a variety of recipes at your fingertips. Easily explore different cuisines, find ingredients, and follow simple steps to create delicious meals. With user-friendly features like search and categories, cooking has never been easier. Perfect for your school project!

### 3 challenges during the development
1. Smooth Scrolling: Implementing smooth scrolling proved to be quite challenging.
2. Navigation: Initially, not every page was designed as a separate screen, causing difficulties with navigation later on. This required significant adjustments.
3. Favorite Functionality: Integrating the favorite feature was initially problematic, especially in conjunction with smooth scrolling. Debugging this without error messages in the console was particularly tough.

### 3 key learning moments from working on the project
1. Responsivity: Learning to handle different screen sizes and optimize UI design for responsiveness.
2. Firebase Initialization: Exploring and mastering the initialization process for Firebase services was both challenging and rewarding.
3. Provider Implementation: Deepening understanding of state management with Provider and its integration with databases was a significant learning milestone.

### List of dependencies and their versions
#### dependencies:
  flutter:
    sdk: flutter
  infinite_scroll_pagination: ^4.0.0
  cupertino_icons: ^1.0.2
  flutter_riverpod: ^2.4.0
  riverpod: ^2.4.0
  firebase_core: ^2.27.0
  cloud_firestore: ^4.15.8
  firebase_auth: ^4.17.8

#### dev_dependencies:
  flutter_test:
    sdk: flutter
  flutter_lints: ^3.0.2

###  DB schema:
#### categories; 
- id(String) - auto ID 
- name(String)
- image(String)

#### recipes:
- id(String) - auto ID
- name(String)
- categoryID(String)
- fav(List<String>) - List of userIDs that liked the recipe
- image(String)
- ingredients(List<String>)
- steps(List<String>)
- userId(String) - author

