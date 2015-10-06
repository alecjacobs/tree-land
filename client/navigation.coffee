window.Navigation =
  moveUp: (currentStory) ->
    if currentStory.parentId && !currentStory.syblingsAbove().count()
      Session.set("selectedStoryId", currentStory.parentId)
    else if currentStory.syblingsAbove().count()
      inspectingStory = currentStory.firstSyblingAbove()
      while inspectingStory.showChildren && inspectingStory.lastChild()
        inspectingStory = inspectingStory.lastChild()
      Session.set("selectedStoryId", inspectingStory._id)
  moveDown: (currentStory) ->
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
  moveLeft: (currentStory) ->
    if currentStory.showChildren && currentStory.hasChildren()
      currentStory.collapse()
    else if currentStory.parentId
        Session.set("selectedStoryId", currentStory.parentId)
  moveRight: (currentStory) ->
    if !currentStory.showChildren && currentStory.hasChildren()
      currentStory.expand()
    else
      @moveDown(currentStory)
