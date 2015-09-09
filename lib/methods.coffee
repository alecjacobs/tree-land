Meteor.methods
  toggleAllVisibility: (topLevelId) ->
    topLevelStory = Stories.findOne(topLevelId)
    Stories.update({secretKey: topLevelStory.secretKey}, {$set: {showChildren: !topLevelStory.showChildren}}, {multi: true})
  bumpStoriesAbove: (storyId) ->
    story = Stories.findOne(storyId)
    Stories.update({parentId: story.parentId, position: {$gte: story.position}},{$inc: {position: 1}},{multi: true})
