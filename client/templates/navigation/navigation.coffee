Template.navigation.helpers
  connectionState: ->
    if Meteor.status().connected
      "connected"
    else
      "offline"
