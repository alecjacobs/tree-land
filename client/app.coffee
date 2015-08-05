Accounts.ui.config
  passwordSignupFields: "USERNAME_ONLY"

Template.application.helpers
  stories: ->
    Stories.find({})
  noStories: ->
    Stories.find({}).count() == 0
