Template.application.events
  "click .new-tree-button": (e, tmpl) ->
    e.preventDefault()
    Meteor.call "newWorkspace", (error, result) ->
      FlowRouter.go("/#{result}")

Template.application.helpers
  timer: ->
    StoryClock.elapsedTime()
