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
      if Meteor.status().connected && (Stories.find({parentId: null}).count() == 0)
        Stories.create({title: "life"})

    Session.setDefault("selectedStoryId", Stories.findOne({parentId: null})?._id)

Template.body.onCreated ->
  handleArrow = (keyEvent, keyPressed) ->
    currentStory = Stories.findOne(Session.get("selectedStoryId"))

    unless currentStory
      currentStory = Stories.findOne({parentId: null})
      Session.set("selectedStoryId", currentStory._id)

    parent = Stories.findOne(currentStory.parentId, {sort: {position: -1}})

    syblingsSelector = {parentId: currentStory.parentId}
    childrenSelector = {parentId: currentStory._id}
    positionLt = {position: {$lt: currentStory.position}}
    positionGt = {position: {$gt: currentStory.position}}
    syblingsBelow = _.extend({}, positionLt, syblingsSelector)
    syblingsAbove = _.extend({}, positionGt, syblingsSelector)

    if keyPressed == "up"
      if Stories.find(syblingsAbove).count() == 0
        if currentStory.parentId
          Session.set("selectedStoryId", parent._id)
      else if Stories.find(syblingsAbove).count() > 0
        syblingAbove = Stories.findOne(syblingsAbove, {sort: {position: 1}})
        syblingAboveChild = Stories.findOne({parentId: syblingAbove._id}, {sort: {position: 1}})

        if syblingAboveChild && syblingAbove.showChildren
          Session.set("selectedStoryId", syblingAboveChild._id)
        else
          Session.set("selectedStoryId", syblingAbove._id)
    else if keyPressed == "down"
      if Stories.find(childrenSelector).count() > 0
        if currentStory.showChildren
          firstChild = Stories.findOne(childrenSelector, {sort: {position: -1}})
          Session.set("selectedStoryId", firstChild._id)
        else
          syblingBelow = Stories.findOne(syblingsBelow, {sort: {position: -1}})
          Session.set("selectedStoryId", syblingBelow._id)
      else if Stories.find(childrenSelector).count() == 0
        if Stories.find(syblingsBelow).count()
          syblingBelow = Stories.findOne(syblingsBelow, {sort: {position: -1}})
          Session.set("selectedStoryId", syblingBelow._id)
        else
          # go to parent's sybling below
          selector =
            parentId: parent.parentId
            position:
              $lt: parent.position

          nextStory = Stories.findOne(selector, {sort: {position: -1}})

          if nextStory
            Session.set("selectedStoryId", nextStory._id)
    else if keyPressed == "left"
      Stories.update(currentStory._id, {$set: {showChildren: false}})
    else if keyPressed == "right"
      Stories.update(currentStory._id, {$set: {showChildren: true}})
    else if keyPressed == "enter"
      $("[data-story-id='#{currentStory._id}']").click()

  Mousetrap.bind "down", handleArrow
  Mousetrap.bind "up", handleArrow
  Mousetrap.bind "left", handleArrow
  Mousetrap.bind "right", handleArrow
  Mousetrap.bind "enter", handleArrow
