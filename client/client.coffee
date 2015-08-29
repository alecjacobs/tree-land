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

Template.application.helpers
  topLevelStory: ->
    if Session.get("rootLevelStoryId")
      Stories.findOne(Session.get("rootLevelStoryId"))
    else
      Stories.findOne({parentId: null})

Template.application.onCreated ->
  @subscribe "stories", ->
    Tracker.autorun ->
      if Meteor.status().connected && (Stories.find({parentId: null}).count() == 0)
        Stories.create({title: "life"})

    Session.setDefault("selectedStoryId", Stories.findOne({parentId: null})?._id)

Template.body.onCreated ->
  moveUp = (currentStory) ->
    if currentStory.parentId && !currentStory.syblingsAbove().count()
      Session.set("selectedStoryId", currentStory.parentId)
    else if currentStory.syblingsAbove().count()
      inspectingStory = currentStory.firstSyblingAbove()
      while inspectingStory.showChildren && inspectingStory.lastChild()
        inspectingStory = inspectingStory.lastChild()

      Session.set("selectedStoryId", inspectingStory._id)

  moveDown = (currentStory) ->
    if currentStory.showChildren && currentStory.hasChildren()
      Session.set("selectedStoryId", currentStory.firstChild()._id)
    else
      if currentStory.syblingsBelow().count()
        Session.set("selectedStoryId", currentStory.firstSyblingBelow()._id)
      else
        inspectingStory = currentStory
        while !nextStoryId && inspectingStory.parentId
          nextStoryId = inspectingStory.parent().firstSyblingBelow()?._id
          inspectingStory = inspectingStory.parent()

        if nextStoryId then Session.set("selectedStoryId", nextStoryId)

  moveLeft = (currentStory) ->
    if currentStory.showChildren && currentStory.hasChildren()
      currentStory.collapse()
    else
      moveUp(currentStory)

  moveRight = (currentStory) ->
    if !currentStory.showChildren && currentStory.hasChildren()
      currentStory.expand()
    else
      moveDown(currentStory)

  handleKeypress = (keyEvent, keyPressed) ->
    currentStory = Stories.findOne(Session.get("selectedStoryId"))

    if !currentStory
      currentStory = Stories.findOne({parentId: null})
      Session.set("selectedStoryId", currentStory._id)

    if keyPressed == "up"
      moveUp(currentStory)
    else if keyPressed == "down"
      moveDown(currentStory)
    else if keyPressed == "left"
      moveLeft(currentStory)
    else if keyPressed == "right"
      moveRight(currentStory)
    else if keyPressed == "enter"
      $("[data-story-id='#{currentStory._id}']").click()
    else if keyPressed == "n"
      currentStory.addStoryBelow()
    else if keyPressed == "e"
      Session.set("rootLevelStoryId", currentStory._id)
    else if keyPressed == "esc"
      Session.set("rootLevelStoryId", null)

  Mousetrap.bind(["down","up","left","right","enter","n","e","esc"], handleKeypress)
