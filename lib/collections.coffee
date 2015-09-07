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

  expand: ->
    Stories.update(@_id, {$set: {showChildren: true}})

  collapse: ->
    Stories.update(@_id, {$set: {showChildren: false}})

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

  storyAboveId: ->
    if @parentId && !@syblingsAbove().count()
      @parentId
    else if @syblingsAbove().count()
      inspectingStory = @firstSyblingAbove()
      while inspectingStory.showChildren && inspectingStory.lastChild()
        inspectingStory.lastChild()._id

  addStoryBelow: ->
    @expand()

    newStoryDoc =
      title: ""
      editing: true
      position: Stories.defaults().position
      parentId: @_id

    if @hasChildren()
      stories = Stories.find({parentId: @_id}).fetch()

      maxStory = _.max stories, (story) ->
        story.position

      newStoryDoc.position = maxStory.position + 1

    Stories.create newStoryDoc, (error, result) ->
      if error
        throw error
      else
        if Meteor.isClient
          Session.set("selectedStoryId", result)
          $("[data-story-id='#{result}'] .title-edit").focus().select()

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
  secretKey:
    type: String
    optional: true
  backgroundColor:
    type: String
    optional: true

Stories.attachSchema(Schemas.Stories)

Stories.defaults = ->
  title: ""
  parentId: null
  userId: null
  editing: false
  position: 0
  showChildren: true
  secretKey: (if Meteor.isClient then Session.get("storyKey") else null)

Stories.create = (storyData, callback) ->
  resultDoc = _.extend({}, @defaults(), storyData)
  Stories.insert(resultDoc, callback)

Stories.topLevelStory = ->
  if Meteor.isClient
    @findOne(Session.get("rootLevelStoryId") || {parentId: null})
