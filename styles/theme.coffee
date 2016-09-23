
base = require './default_theme/default_theme.coffee'

class Theme
    constructor: (custom) ->
        @set base
        @set custom
    set: (custom = {})->
        for k,t of custom when k not in ['set', 'copy']
             @[k] = t
    copy: ->
        new Theme @

module.exports = {Theme}
