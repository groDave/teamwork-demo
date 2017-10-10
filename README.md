# TEAMWORK DEMO

A simple app utilizing the teamwork.com api.

## Setup

This demo app uses CocoaPods so make sure to open the .xcworkspace file rather than the .xcodeproj file.
If you do not have CocoaPods installed on your machine - it's very easy to install. Just open a terminal and run:

```
sudo gem install cocoapods
```

This will install CocoaPods. If the app cannot find the pods it comes with, open a terminal and navigate to the project directory. Run:

```
pod install
```

This will download all the pods specified in the projects Podfile. You should now be good to go!

## The App

The app has a simple login screen where the user can input his/her own teamwork api key, or the demo api key by tapping the "Demo API Key" button.
Once logged in, a user will see the main screen of the app - a list of their projects. Tapping on a project will bring the user to the Project detail view, where they can see all the tasks associated with that project.

## Questions

Any questions don't hesitate to contact me: davehannan90@gmail.com