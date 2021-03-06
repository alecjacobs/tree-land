Template.storiesList.helpers
  stories: ->
    Stories.find({parentId: @parentId}, {sort: {position: -1}})
  widthPercentage: (depthLevel) ->
    maximumDepth = 24

    if depthLevel == 0
      100
    else if depthLevel > maximumDepth
      20
    else
      100 - (80 * (depthLevel / maximumDepth))
  showBorder: ->
    @parentId == Session.get("selectedStoryId")
