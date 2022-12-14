# flutter_chat_app

A new Flutter project.

## Introduction

This is the frontend client of flutter chat application built using flutter/dart.

This project is in two parts with front-end and back-end having separate repositories.
* Frontend Project - [flutter_chat_app](https://github.com/Clumsynite/flutter_chat_app)
* Backend Project - [flutter-chat-api](https://github.com/Clumsynite/flutter-chat-api)

You will need both these projects to run this app locally.


## Installation


### Clone
Clone this project using 

```
git clone https://github.com/Clumsynite/flutter_chat_app
```


### Install 
```
flutter pub get
```

installs all dependencies used in the project.

### Flutter Doctor

Run `flutter doctor` just to make sure there are no issues with your flutter configuration. So that you can run this app without any hassle.


### Locally running the App

Before running the flutter app you will need to clone and initialise the backend 
project. That project handle all the REST API and Socket related operations.


### env.dart

You need to create a file named `env.dart` inside `/lib/config/` directory and paste the below keys to get your app running.


```dart
  String uri = 'http://<URI>:<PORT>'; // this will be your local ip and port where you will run `flutter-chat-api`
  String tokenKey = "x-auth-token"; // string which should match your api's token key
  String socketIdKey = "socketId"; // common string everywhere to store socketId
```

### flutter run

```
flutter run
```
Run the flutter app.

This app was built and tested for **android** so, running it on an emulator or mobile device would be better than web/linux/ios.


## Screenshots

### Auth Screen

Sign up and Sign in Sections
![Auth Screen](/screenshots//auth_screen.png)

### Friends List

This screen shows you a list of friends. Clicking on that Friend opens the messaging screen.

![Friends Screen](/screenshots//friends_screen.png)

### Contatcs

This screen shows you a list of all the people signed up on this app. You have an option to add them to your friend list or remove them from your friend list.

You can only message or view online presence of contacts who are your friends.

![Contacts Screen](/screenshots//contacts_screen.png)

### Profile

This is a basic profile screen.

The first text box shows you the user's full name.

The second text box shows you the user's email address.

You have an option to update these details.

![Profile Screen](/screenshots//profile_screen.png)

### Update Profile Details

After you click Edit Details on profile screen you can see this form enabled, which allows you to update your details.

![Update Profile Details](/screenshots//update_profile_details.png)

### Change Password

There is an option to change password below user details form on Profile Screen.

A new form with password related input fields is visible after you click Change Password.

![Change Password](/screenshots//change_password.png)


## Videos



### Friend Request and User Presence
https://user-images.githubusercontent.com/65499068/181581566-77e87cae-63c4-427e-ab45-4ca1ddcfff50.mp4

[Link to Video](/videos//friend_request-and-user_presence.mp4)



### Real Time Message


https://user-images.githubusercontent.com/65499068/181581634-eec7eb32-36df-4e7d-af0c-ada24e9004fe.mp4


[Link to Video](/videos//realtime_messaging.mp4)



## FEATURES TILL NOW
  ### AUTH
    * sign up
    * sign in
    * reject login if user is already active on a different client
  ### CONTACTS
    * view contacts
    * send friend request
    * cancel friend request
    * accept friend request
    * remove friend
  ### MESSAGES
    * view messages from a friend
    * send message
    * receive message
    * delete
    * delete all
  ### REALTIME
    * typing
    * unread count
    * messages
    * online
    * friend request
    * friend list
    * user offline if app is closed or user logs out
  ### PROFILE
    * update profile details
    * change password


## TODO FEAUTRES
  
  ### MESSAGES
    * pagination, view messages as you scroll up
    * read status
  ### GENERAL
    * notification for unread messages
  ## PROFILE
    * update profile picture
    * delete user 
      * user will be removed from friend contacts
      * user will be in friend list with an option to remove friend
      * messages to user will be disabled
