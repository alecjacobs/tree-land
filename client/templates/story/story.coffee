Template.story.events
  "click .story": (e, tmpl) ->
    Session.set("selectedStoryId", @_id)
    if ! @editing
      Stories.update @_id, {$set: {editing: true}}, ->
        $(tmpl.find(".title-edit")).focus().select()
        GAnalytics.event("editStory")
  "blur .story": (e, tmpl) ->
    if @editing
      formData = serializeForm(tmpl.find("#storyUpdateForm"))
      formData.editing = false
      Stories.update(@_id, {$set: formData})
  "click .show-children, click .state-indicator": (e, tmpl) ->
    e.stopPropagation()
    Stories.update(@_id, {$set: {showChildren: !@showChildren}})
  "keydown": (e, tmpl) ->
    if e.which == 27 && @editing
      formData = serializeForm(tmpl.find("#storyUpdateForm"))
      formData.editing = false
      Stories.update(@_id, {$set: formData})

Template.story.helpers
  state: ->
    if @editing
      "editing"
    else if Session.get("selectedStoryId") == @_id
      "selected"
    else
      ""
  depth: ->
    storyDepth(@_id)
  hasChildren: ->
    Stories.find({parentId: @_id}).count()
  triangleDirection: ->
    if @showChildren
      "bottom"
    else
      "right"
  showStoriesList: ->
    @showChildren && (Stories.find({parentId: @_id}).count() > 0)
  showCompletionBar: ->
    @hasChildren() && @parentId && (@doneChildren().count() > 0) && !@editing
  widthPercentage: ->
    (@doneChildren().count() / @children().count()) * 100
  doneChildrenCount: ->
    @doneChildren().count()
  childrenCount: ->
    @children().count()
