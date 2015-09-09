Meteor.methods
  toggleAllVisibility: (topLevelId) ->
    topLevelStory = Stories.findOne(topLevelId)
    Stories.update({secretKey: topLevelStory.secretKey}, {$set: {showChildren: !topLevelStory.showChildren}}, {multi: true})
