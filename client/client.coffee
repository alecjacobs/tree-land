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
  handleKeypress = (keyEvent, keyPressed) ->
    currentStory = Stories.findOne(Session.get("selectedStoryId"))

    unless currentStory
      currentStory = Stories.findOne({parentId: null})
      Session.set("selectedStoryId", currentStory._id)

    parent = Stories.findOne(currentStory.parentId)

    if keyPressed == "up"
      if currentStory.parentId && !currentStory.syblingsAbove().count()
        Session.set("selectedStoryId", parent._id)
      else if currentStory.syblingsAbove().count()
        syblingAbove = currentStory.firstSyblingAbove()
        syblingChildAbove = syblingAbove.lastChild()

        if syblingChildAbove && syblingAbove.showChildren
          Session.set("selectedStoryId", syblingChildAbove._id)
        else
          Session.set("selectedStoryId", syblingAbove._id)
    else if keyPressed == "down"
      if currentStory.hasChildren()
        if currentStory.showChildren
          Session.set("selectedStoryId", currentStory.firstChild()._id)
        else
          if currentStory.syblingsBelow().count()
            Session.set("selectedStoryId", currentStory.firstSyblingBelow()._id)
      else
        if currentStory.syblingsBelow().count()
          Session.set("selectedStoryId", currentStory.firstSyblingBelow()._id)
        else
          nextStoryId = parent.firstSyblingBelow()?._id
          if nextStoryId then Session.set("selectedStoryId", nextStoryId)
    else if keyPressed == "left"
      if currentStory.showChildren && currentStory.hasChildren()
        currentStory.collapse()
      else
        if parent
          Session.set("selectedStoryId", parent._id)
          parent.collapse()
    else if keyPressed == "right"
      if currentStory.hasChildren()
        currentStory.expand()
    else if keyPressed == "enter"
      $("[data-story-id='#{currentStory._id}']").click()
    else if keyPressed == "n"
      $("[data-story-id='#{currentStory._id}'] .btn-group .add").click()
      $("[data-story-id='#{currentStory._id}'] .title-edit").click()
    else if keyPressed == "e"
      Session.set("rootLevelStoryId", currentStory._id)
    else if keyPressed == "esc"
      Session.set("rootLevelStoryId", null)

  Mousetrap.bind "down", handleKeypress
  Mousetrap.bind "up", handleKeypress
  Mousetrap.bind "left", handleKeypress
  Mousetrap.bind "right", handleKeypress
  Mousetrap.bind "enter", handleKeypress
  Mousetrap.bind "n", handleKeypress
  Mousetrap.bind "e", handleKeypress
  Mousetrap.bind "esc", handleKeypress
