root = window ? global

class root.Story
  constructor: (doc) ->
    _.extend(this, doc)

    @childrenSelector = {parentId: @_id}
    @syblingsSelector = {parentId: @parentId}
    @syblingsAboveSelector = _.extend({position: {$gt: @position}}, @syblingsSelector)
    @syblingsBelowSelector = _.extend({position: {$lt: @position}}, @syblingsSelector)

  parent: ->
    Stories.findOne(@parentId)

  children: ->
    Stories.find(@childrenSelector)

  hasChildren: ->
    @children().count() > 0

  firstChild: ->
    Stories.findOne(@childrenSelector, {sort: {position: -1}})

  lastChild: ->
    Stories.findOne(@childrenSelector, {sort: {position: 1}})

  syblings: ->
    Stories.find(@syblingsSelector)

  syblingsAbove: ->
    Stories.find(@syblingsAboveSelector)

  syblingsBelow: ->
    Stories.find(@syblingsBelowSelector)

  firstSyblingAbove: ->
    Stories.findOne(@syblingsAboveSelector, {sort: {position: 1}})

  firstSyblingBelow: ->
    Stories.findOne(@syblingsBelowSelector, {sort: {position: -1}})

  expand: ->
    Stories.update(@_id, {$set: {showChildren: true}})

  collapse: ->
    Stories.update(@_id, {$set: {showChildren: false}})


root.Stories = new Mongo.Collection "stories",
  transform: (doc) ->
    new Story(doc)

root.Schemas = {}

Schemas.Stories = new SimpleSchema
  title:
    type: String
    max: 140
    optional: true
  parentId:
    type: String
    optional: true
  userId:
    optional: true
    type: String
  editing:
    type: Boolean
  position:
    type: Number
  showChildren:
    type: Boolean

Stories.attachSchema(Schemas.Stories)

Stories.defaults =
  title: ""
  parentId: null
  userId: null
  editing: false
  position: 0
  showChildren: true

Stories.create = (storyData) ->
  resultDoc = _.extend({}, @defaults, storyData)
  Stories.insert(resultDoc)
