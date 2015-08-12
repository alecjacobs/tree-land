Template.buttonGroup.helpers
  decDepth: ->
    _.extend({class: "dec-depth", glyph: "chevron-left"}, this)
  incDepth: ->
    _.extend({class: "inc-depth", glyph: "chevron-right"}, this)
  add: ->
    _.extend({class: "add", glyph: "plus"}, this)
  delete: ->
    _.extend({class: "delete", glyph: "remove"}, this)
  