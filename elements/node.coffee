{ React, Component, mixins } = require '../common.coffee'
{ div, span, p, a, ul, li, img, h1, h2, h3, em, strong, canvas,
pre, iframe, br, audio, form, input, label, button, datalist,
option, optgroup, svg, defs, linearGradient, stop, video } = React.DOM


class Node
    context: null
    id: null
    label: null
    paramsUI: ->
    constructor: (custom_theme={})->
        theme = @context.theme
        sockets =
            basic: new @context.sockets.BasicSocket custom_theme
            bool: new @context.sockets.BoolSocket custom_theme
            collection: new @context.sockets.CollectionSocket custom_theme
            float: new @context.sockets.FloatSocket custom_theme
            int: new @context.sockets.IntSocket custom_theme
            string: new @context.sockets.StringSocket custom_theme
            vector: new @context.sockets.VectorSocket custom_theme

        @inputs_by_id = {}
        @outputs_by_id = {}

        for socket in @inputs
            @inputs_by_id[socket.id] = socket

        for socket in @outputs
            @outputs_by_id[socket.id] = socket

        label = @label

        getOrientation = => @isHorizontal
        paramsUI = @paramsUI()

        inputsUI = div
            key: @id + '.inputs'
            style: [mixins.columnFlex, minWidth:230]
            for socket in @inputs
                key = @id + '.inputs.' + socket.id
                sockets[socket.type].ui(socket)({key})

        outputsUI = div
            key: @id + '.outputs'
            style: [
                mixins.columnFlex
                justifyContent: 'flex-end'
                width: '100%'
                minWidth:230
            ]
            for socket in @outputs
                key = @id + '.outputs.' + socket.id
                sockets.basic.ui(socket, true)({key})

        splitter = new @context.Splitter
            splitter:
                title_container:
                    paddingTop: 0
                    paddingLeft: 0
                    paddingBottom: 0
                    paddingRight: 0
                    minHeight: 30
        @updateUI = ->
            console.warn "Component could not be updated because it isn't mounted."
        saveUpdateUIFunction = (f)=>
            @updateUI = f

        id = @id
        @ui = Component
            componentDidMount: ->
                saveUpdateUIFunction =>
                     @forceUpdate()

            render: ->
                isHorizontal = getOrientation()
                div
                    id: id + '.node'
                    className: 'myoui node'
                    style: [
                        # required style
                        mixins.columnFlex
                        position: 'absolute'
                        top: 200
                        left: 200
                        overflow: 'hidden'
                        # default customizable style
                        theme.popupMenu true
                    ]
                    splitter.ui
                        key: id + '.node.head'
                        label: label
                        style:
                            paddingTop: 0
                            paddingBottom: 0
                            paddingLeft: 0
                            paddingRight: 0
                            minHeight: 30

                    div
                        key: id + '.node.body'
                        style: [
                            # required style
                            if isHorizontal then mixins.rowFlex else mixins.columnFlex
                            alignItems: 'flex-start'
                        ]

                        if isHorizontal
                            [inputsUI, paramsUI, outputsUI]
                        else [
                            # paramsUI
                            inputsUI
                            # outputsUI
                        ]


    setVertical: ->
        @isHorizontal = false
        @updateUI()

    setHorizontal: ->
        @isHorizontal = true
        @updateUI()

    toggleOrientation: ->
        @isHorizontal = not @isHorizontal
        @updateUI()


module.exports = {Node}
