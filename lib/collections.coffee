root = window ? global

class root.Story
  constructor: (doc) ->
    _.extend(this, doc)

    @childrenSelector = {parentId: @_id}
    @syblingsSelector = {parentId: @parentId}
    @syblingsAboveSelector = _.extend({position: {$gt: @position}}, @syblingsSelector)
    @syblingsBelowSelector = _.extend({position: {$lt: @position}}, @syblingsSelector)
    @doneChildrenSelector = _.extend({done: true}, @childrenSelector)

  parent: ->
    Stories.findOne(@parentId)

  children: ->
    Stories.find(@childrenSelector)

  doneChildren: ->
    Stories.find(@doneChildrenSelector)

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
    Stories.find(@syblingsAboveSelector, {sort: {position: 1}})

  syblingsBelow: ->
    Stories.find(@syblingsBelowSelector, {sort: {position: -1}})

  firstSyblingAbove: ->
    Stories.findOne(@syblingsAboveSelector, {sort: {position: 1}})

  firstSyblingBelow: ->
    Stories.findOne(@syblingsBelowSelector, {sort: {position: -1}})

  storyAboveId: ->
    if @parentId && !@syblingsAbove().count() && !@syblingsBelow().count()
      @parentId
    else if @syblingsAbove().count()
      @firstSyblingAbove()._id
    else if @syblingsBelow().count()
      @firstSyblingBelow()._id

  addChildBelow: ->
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

  addSyblingBelow: ->
    newStoryDoc =
      title: ""
      editing: true
      position: @position
      parentId: @parentId

    Meteor.call "bumpStoriesAbove", @_id, ->
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
    max: 1776
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
  themeColors:
    type: Object
    blackbox: true
    optional: true
  done:
    type: Boolean
  hideHelp:
    type: Boolean
    optional: true

Stories.attachSchema(Schemas.Stories)

Stories.defaults = ->
  title: ""
  parentId: null
  userId: null
  editing: false
  position: 0
  showChildren: true
  themeColors: {}
  done: false
  secretKey: (if Meteor.isClient then Session.get("storyKey") else null)

Stories.create = (storyData, callback) ->
  resultDoc = _.extend({}, @defaults(), storyData)
  Stories.insert(resultDoc, callback)

Stories.topLevelStory = ->
  if Meteor.isClient
    @findOne(Session.get("rootLevelStoryId") || {parentId: null})

Stories.allow
  insert: (userId, doc) ->
    true

  update: (userId, doc, fieldNames, modifier) ->
    protectedFields = ["secretKey"]
    _.intersection(fieldNames, protectedFields).length == 0

  remove: (userId, doc) ->
    true

  fetch: []
