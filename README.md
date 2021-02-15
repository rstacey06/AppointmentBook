# AppointmentBook

A Ruby on Rails app for keeping track of appointments, clients and locations.

# Features

* Keep track of appointments with multiple clients in multiple locations.
* Reschedule or cancel appointments
* Add Clients and Locations and track appointments by client and location.
* Keep track of income earned from clients and/or locations.


# Facebook Login

In order to get the Facebook Login working correctly, you'll need to complete the following steps:

Create an application in the Facebook Developer Console and go to the settings part of the Dashboard (skip quick setup)
At the top of the Basic tab, you'll see the name of the app, the API version, the App ID, and the App Secret. You'll want to add the App ID and the App Secret to the .env file in your project, like so... In the root of your project, run nano .env, and add the following:
FACEBOOK_KEY="App ID here"
FACEBOOK_SECRET="App Secret here"


Press CTRL + O to save, hit return to save the file as .env, press CTRL + X to exit nano. 3. Drop into your rails console to make sure you've got them hooked up: run ENV["FACEBOOK_KEY"] and you should see your App ID NOTE: If this isn't working, make sure that you have the gem 'dotenv-rails, groups: [:development, :test] in your Gemfile beneath gem rails. 4. Before making any commits: Make sure you that you have .env in your .gitignore file. 5. Click on the Advanced Tab and scroll down to the section labeled Client OAuth Settings and find the filed labeled Valid OAuth Redirect URLs. You'll want to add http://localhost:3000/users/auth/facebook/callback.

Now you should be able to run rails server and test out the app.

# Usage
* Sign up for an account
* Click the "+ New" button at the top of the page
* Fill in the form on the left to create your first client and appointment (i.e. Fill in Top field with "My first client", and the bottom field with "My first location")
* Click the Create Appointment Button
* Your new appointment should appear on your calendar.
* To Reschedule your appointment, click on the appointment in your calendar and you'll be taken to the edit appointment form. Make your changes and submit the form to change your appointment.
* Click on the Clients link in the top navigation menu and you should see a list of your clients ("My first client" should be at the top). Click on the edit button below the client's name to add contact information.
* In the right hand column there is a button to add a new appointment with "My first client".
* Click on the Locations link in the top navigation menu and you'll see a list of your locations ("My first location" should be at the top). Click on the edit button below the location's name to add an address.
* In the right hand column there is a button to add a new appointment at "My first location".
