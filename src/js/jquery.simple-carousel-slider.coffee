do ($ = jQuery) ->

  pluginName  = "scSlider"

  $.fn[pluginName] = (options) ->
    @each ->
      unless $(this).data pluginName
        $(this).addClass(pluginName)
        $(this).data pluginName, new SCSlider this, options

  class SCSlider

    _defaults =
      interval: 0,
      draggable: true,
      prev: null,
      next: null

    constructor: (@source, options) ->
      @settings = $.extend {}, _defaults, options
      @$slider   = $(@source)
      @$prev    = $("<div class='sc-prev'><div class='sc-inner'>#{@settings.prev}</div></div>") if @settings.prev
      @$next    = $("<div class='sc-next'><div class='sc-inner'>#{@settings.next}</div></div>") if @settings.next
      @timer    = null
      @sliding  = false
      @dragging = false
      @init()

    init: ->

      self = @

      @$slider.find('.sc-slide').filter(':first').addClass 'active'

      if @settings.interval > 0
        @timer = setInterval ->
          self.slide 'left'
        , @settings.interval

      if @settings.prev
        @$slider.append(@$prev)
        @$prev.on 'tap', -> self.fire 'left'

      if @settings.next
        @$slider.append(@$next)
        @$next.on 'tap', -> self.fire 'right'

      if @settings.draggable
        @$slider.on 'drag', (e)->
          if e.orientation == 'horizontal'
            self.dragging = true
            if 1 == e.direction
              self.fire 'right'
            else
              self.fire 'left'

    slide: (dir) ->
      return if @sliding
      @sliding = true

      self = @
      
      $activeSlide = @$slider.find '.sc-slide.active'

      leftTo = if (dir == "left") then "-100%" else "100%"
      $activeSlide.animate(
        "left": leftTo
      , ->
        $activeSlide.removeClass("active")
        if self.dragging
          setTimeout ->
            self.sliding = false
            self.dragging = false
          , 500
        else
          self.sliding = false
      )

      if dir == 'left'
        if $activeSlide.nextAll(".sc-slide").length > 0
          $nextSlide = $activeSlide.nextAll(".sc-slide:first")
        else
          $nextSlide = $activeSlide.parent().find(".sc-slide").filter(":first")
      else 
        if $activeSlide.prevAll(".sc-slide").length > 0
          $nextSlide = $activeSlide.prevAll(".sc-slide:first")
        else
          $nextSlide = $activeSlide.parent().find(".sc-slide").filter(":last")

      leftTo = if (dir == "left") then "100%" else "-100%"
      $nextSlide.css("left", leftTo)
      $nextSlide.addClass("active")

      $nextSlide.animate
        "left": 0

    fire: (dir)->
      self = @
      @slide(dir)
      if @timer
        clearInterval(@timer)
        @timer = setInterval ->
          self.slide 'left'
        , @settings.interval