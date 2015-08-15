root = window

root.serializeForm = (formElement) ->
  formData = {}

  $(formElement).serializeArray().map (inputObject) ->
    formData[inputObject.name] = inputObject.value

  formData

Accounts.ui.config
  passwordSignupFields: "USERNAME_ONLY"

Template.registerHelper "meteorStatus", ->
  Meteor.status()

Template.application.onCreated ->
  @subscribe "stories", ->
    Tracker.autorun ->
      if Meteor.status().connected && (Stories.find({}).count() == 0)
        Stories.create({title: "life"})
    
    Session.setDefault("selectedStoryId", Stories.findOne({parentId: null})?._id)
    
Template.body.onCreated ->
  handleArrow = (keyEvent, keyPressed) ->
    Session.set("selectedStoryId", Stories.findOne({parentId: null})._id) unless Session.get("selectedStoryId")
    currentStory = Stories.findOne(Session.get("selectedStoryId"))
    
    syblingsSelector = {parentId: currentStory.parentId}
    childrenSelector = {parentId: currentStory._id}
    positionLt = {position: {$lt: currentStory.position}}
    positionGt = {position: {$gt: currentStory.position}}
    syblingsBelow = _.extend({}, positionLt, syblingsSelector)
    syblingsAbove = _.extend({}, positionGt, syblingsSelector)
    
    if keyPressed == "up"
      if Stories.find(syblingsAbove).count() == 0
        if currentStory.parentId
          parent = Stories.findOne(currentStory.parentId, {sort: {position: -1}})
          Session.set("selectedStoryId", parent._id)
      else if Stories.find(syblingsAbove).count() > 0
        syblingAbove = Stories.findOne(syblingsAbove, {sort: {position: 1}})
        Session.set("selectedStoryId", syblingAbove._id)
    else if keyPressed == "down"
      if Stories.find(childrenSelector).count() > 0
        firstChild = Stories.findOne(childrenSelector, {sort: {position: -1}})
        Session.set("selectedStoryId", firstChild._id)
      else if Stories.find(childrenSelector).count() == 0
        if Stories.find(syblingsBelow).count()
          syblingBelow = Stories.findOne(syblingsBelow, {sort: {position: -1}})
          Session.set("selectedStoryId", syblingBelow._id)
  
  Mousetrap.bind "down", handleArrow
  Mousetrap.bind "up", handleArrow
