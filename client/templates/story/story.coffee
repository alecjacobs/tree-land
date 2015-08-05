Template.story.events
  "click .edit": (e, tmpl) ->
    Stories.update @_id, {$set: {editing: (! @editing)}}, ->
      $(".title-edit").focus()
  "click .delete": (e, tmpl) ->
    Stories.remove(@_id)
  "click .title": (e, tmpl) ->
    Stories.update @_id, {$set: {editing: true}}, ->
      $(".title-edit").focus()

Template.story.helpers
  sizeClass: (depthLevel) ->
    if depthLevel == 0
      offsetClass = ""
    else
      offsetClass = "col-xs-offset-#{depthLevel}"

    "col-xs-#{12 - depthLevel} #{offsetClass}"

storyFormHooks =
  updateStoryForm:
    after:
      update: (doc) ->
        Stories.update(@docId, {$set: {editing: (! @currentDoc.editing)}})
  insertStoryForm:
    after:
      insert: (doc) ->
        Stories.update(@docId, {$set: {editing: false}})

AutoForm.hooks(storyFormHooks)
