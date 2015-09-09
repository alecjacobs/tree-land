root = window ? global

root.storyDepth = (id) ->
  parentId = Stories.findOne(id)?.parentId
  if parentId == null
    0
  else
    1 + storyDepth(parentId)
