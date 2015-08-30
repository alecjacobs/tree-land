FlowRouter.route '/:storyKey',
    action: (params, queryParams) ->
      if Meteor.isClient
        Session.set("collectionsLoaded", false)
        Session.set("storyKey", params.storyKey)
        Meteor.subscribe "stories", params.storyKey, ->
          Session.set("collectionsLoaded", true)
          Session.setDefault("selectedStoryId", Stories.findOne(parentId: null)?._id)

FlowRouter.route '/',
  action: ->
    Meteor.call "newWorkspace", (error, result) ->
      FlowRouter.go("/#{result}")
