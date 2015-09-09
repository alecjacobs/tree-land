Template.navigation.helpers
  connectionState: ->
    if Meteor.status().connected
      "connected"
    else
      "offline"
  exportLink: ->
    Meteor.absoluteUrl("export/#{Session.get("storyKey")}.md")
