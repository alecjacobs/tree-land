FlowRouter.route '/:storyKey',
    action: (params, queryParams) ->
      if Meteor.isClient
        Session.set("collectionsLoading", true)
        Session.set("storyKey", params.storyKey)
        GAnalytics.pageview("/#{params.storyKey}")
        Tracker.autorun ->
          Meteor.subscribe "stories", Session.get("storyKey"), ->
            Session.set("collectionsLoading", false)
            Session.setDefault("selectedStoryId", Stories.findOne(parentId: null)?._id)

FlowRouter.route '/',
  action: (params, queryParams) ->
    Session.set("storyKey", null)
