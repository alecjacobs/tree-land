getCurrentStory = ->
  currentStory = Stories.findOne(Session.get("selectedStoryId"))
  if !currentStory
    currentStory = Stories.topLevelStory()
    Session.set("selectedStoryId", currentStory._id)
  currentStory

possiblyClearDeleteId = ->
  if Session.get("pendingDeleteId")
    Session.set("pendingDeleteId", null)

setupBinding = (boundKey, callback) ->
  Mousetrap.bind boundKey, (keyEvent, keyPressed) ->
    possiblyClearDeleteId()
    callback(getCurrentStory(), keyEvent)
    if keyPressed.indexOf("tab") > -1
      keyEvent.preventDefault()

setupBinding "up", ((currentStory) -> Navigation.moveUp(currentStory))
setupBinding "down", ((currentStory) -> Navigation.moveDown(currentStory))
setupBinding "left", ((currentStory) -> Navigation.moveLeft(currentStory))
setupBinding "right", ((currentStory) -> Navigation.moveRight(currentStory))

setupBinding "enter", ((currentStory) -> $("[data-story-id='#{currentStory._id}']").click())
setupBinding "esc", ((currentStory) -> Session.set("rootLevelStoryId", null))

setupBinding "l", ((currentStory) -> Stories.update(currentStory._id, {$set: {eval: !currentStory.eval}}))
setupBinding "x", ((currentStory) -> Stories.update(currentStory._id, {$set: {done: !currentStory.done}}))
setupBinding "h", ((currentStory) -> Stories.update(Stories.topLevelStory()._id, {$set: {hideHelp: !Stories.topLevelStory().hideHelp}}))
setupBinding "e", ((currentStory) -> Session.set("rootLevelStoryId", currentStory._id))

setupBinding "tab", (currentStory, keyEvent) ->
  Stories.update(currentStory._id, {$set: {showChildren: !currentStory.showChildren}})

setupBinding "n", (currentStory) ->
  GAnalytics.event("newStory")
  if currentStory.parentId
    currentStory.addSyblingBelow()
  else
    currentStory.addChildBelow()

setupBinding "y", (currentStory) ->
  if Session.get("pendingDeleteId")
    newSelectedId = currentStory.storyAboveId()

    Stories.remove Session.get("pendingDeleteId"), ->
      Session.set("selectedStoryId", newSelectedId)
      Session.set("pendingDeleteId", null)
  else
    Session.set("pendingDeleteId", null)

setupBinding "shift+n", (currentStory) ->
  currentStory.addChildBelow()
  GAnalytics.event("newStory")

setupBinding "d", (currentStory) ->
  if Stories.topLevelStory()._id == currentStory._id
    console.log "Cannot delete top level story!"
  else
    Session.set("pendingDeleteId", currentStory._id)

setupBinding "shift+tab", (currentStory) ->
  topLevelStory = Stories.topLevelStory()
  if topLevelStory.showChildren then Session.set("selectedStoryId", topLevelStory._id)
  Meteor.call("toggleAllVisibility", topLevelStory._id)

setupBinding "shift+left", (currentStory) ->
  currentStory.promote()

setupBinding "shift+right", (currentStory) ->
  currentStory.demote()

setupBinding "shift+up", (currentStory) ->
  if aboveStory = currentStory.firstSyblingAbove()
    currentPosition = aboveStory.position
    abovePosition = currentStory.position

    Stories.update(currentStory._id, {$set: {position: currentPosition}})
    Stories.update(aboveStory._id, {$set: {position: abovePosition}})

setupBinding "shift+down", (currentStory) ->
  if belowStory = currentStory.firstSyblingBelow()
    currentPosition = belowStory.position
    belowPosition = currentStory.position

    Stories.update(currentStory._id, {$set: {position: currentPosition}})
    Stories.update(belowStory._id, {$set: {position: belowPosition}})
