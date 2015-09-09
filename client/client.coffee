root = window

Session.setDefault("showHelp", true)

root.serializeForm = (formElement) ->
  formData = {}
  $(formElement).serializeArray().map (inputObject) ->
    formData[inputObject.name] = inputObject.value
  formData

Template.registerHelper "meteorStatus", ->
  Meteor.status()

Template.registerHelper "collectionsLoaded", ->
  Session.get("collectionsLoaded")

Template.application.helpers
  topLevelStory: ->
    Stories.topLevelStory()

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
    else if currentStory.parentId
        Session.set("selectedStoryId", currentStory.parentId)

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

    if Session.get("pendingDeleteId")
      if keyPressed == "y"
        newSelectedId = currentStory.storyAboveId()

        Stories.remove Session.get("pendingDeleteId"), ->
          Session.set("selectedStoryId", newSelectedId)
          Session.set("pendingDeleteId", null)
      else
        Session.set("pendingDeleteId", null)
    else
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
      else if keyPressed == "d"
        Session.set("pendingDeleteId", currentStory._id)
      else if keyPressed == "h"
        Session.set("showHelp", !Session.get("showHelp"))
      else if keyPressed == "x"
        Stories.update(currentStory._id, {$set: {done: !currentStory.done}})
      else if keyPressed == "esc"
        Session.set("rootLevelStoryId", null)
      else if keyPressed == "tab"
        keyEvent.preventDefault()
        console.log "tab being pressed"
        if currentStory
          Stories.update(currentStory._id, {$set: {showChildren: !currentStory.showChildren}})


  Mousetrap.bind(["down", "up", "left", "right", "enter", "n", "e", "d", "y", "h", "x", "esc", "tab"], handleKeypress)

  Mousetrap.bind "shift+up", ->
    currentStory = Stories.findOne(Session.get("selectedStoryId"))
    aboveStory = currentStory.firstSyblingAbove()

    if aboveStory
      currentPosition = aboveStory.position
      abovePosition = currentStory.position

      Stories.update(currentStory._id, {$set: {position: currentPosition}})
      Stories.update(aboveStory._id, {$set: {position: abovePosition}})

  Mousetrap.bind "shift+down", ->
    currentStory = Stories.findOne(Session.get("selectedStoryId"))
    belowStory = currentStory.firstSyblingBelow()

    if belowStory
      currentPosition = belowStory.position
      belowPosition = currentStory.position

      Stories.update(currentStory._id, {$set: {position: currentPosition}})
      Stories.update(belowStory._id, {$set: {position: belowPosition}})
