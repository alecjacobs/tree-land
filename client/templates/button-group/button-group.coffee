Template.buttonGroup.helpers
  add: ->
    _.extend({class: "add", glyph: "plus"}, this)
  delete: ->
    _.extend({class: "delete", glyph: "remove"}, this)
