userInputToInt = (text) ->
  parsedInt = Number.parseInt(text)
  if _.isNaN(parsedInt)
    0
  else
    parsedInt

arraySum = (arr) ->
  accumulator = (memo, element) ->
    memo + element

  _.reduce(arr, accumulator, 0)

Template.storyTitle.events
  "submit #storyUpdateForm": (e, tmpl) ->
    e.preventDefault()
    formData = serializeForm(e.currentTarget)
    formData.editing = false
    Stories.update(@_id, {$set: formData})

Template.storyTitle.helpers
  titleMaxChars: ->
    Schemas.Stories._schema.title.max
  aboutToDelete: ->
    Session.get("pendingDeleteId") == @_id
  treEval: (code) ->
    tokens = code.split("|")
    children = @children().fetch()

    if _.isEqual(tokens, ["sum", "children"])
      arraySum(_.map(_.pluck(children, "title"), userInputToInt))
    else if _.isEqual(tokens, ["avg", "children"])
      childrenSum = arraySum(_.map(_.pluck(children, "title"), userInputToInt))
      childrenSum / children.length
    else
      "Parse error"
