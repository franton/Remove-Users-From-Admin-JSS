# Remove-Users-From-Admin-JSS

Takes the output from a Casper extension attribute as a "whitelist" then removes all other users from the admin group.

1) Create a Casper Extension Attribute called "Admin Users"

2) Enter the AD usernames you want to have local admin rights on that computer Make sure they're separated by a space.

3) Set the script to run as part of your logout policies.

4) Also make sure you have an api access user that has read only access to the JSS. Add that username / password to the script.

5) Test!

This is a prototype at present and is made available for your use at your own risk. It's also meant to work in tandem with my Add-Users-To-Admin-JSS script.

Please test on a non production environment!
