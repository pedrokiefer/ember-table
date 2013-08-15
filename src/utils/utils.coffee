Ember.MultiItemViewCollectionView =
Ember.CollectionView.extend Ember.StyleBindingsMixin,
  styleBindings:  'width'
  itemViewClassField: null
  createChildView: (view, attrs) ->
    itemViewClassField = @get 'itemViewClassField'
    itemViewClass = attrs.content.get(itemViewClassField)
    if typeof itemViewClass is 'string'
      itemViewClass = Ember.get Ember.lookup, itemViewClass
    @_super(itemViewClass, attrs)

Ember.MouseWheelHandlerMixin = Ember.Mixin.create
  onMouseWheel: Ember.K
  didInsertElement: ->
    @_super()
    @$().bind 'mousewheel', (event, delta, deltaX, deltaY) =>
      Ember.run this, @onMouseWheel, event, delta, deltaX, deltaY
  willDestroyElement: ->
    @$()?.unbind 'mousewheel'
    @_super()

Ember.ScrollHandlerMixin = Ember.Mixin.create
  onScroll: Ember.K
  scrollElementSelector: ''
  didInsertElement: ->
    @_super()
    @$(@get('scrollElementSelector')).bind 'scroll', (event) =>
      Ember.run this, @onScroll, event
  willDestroyElement: ->
    @$(@get('scrollElementSelector'))?.unbind 'scroll'
    @_super()

Ember.TouchHandlerMixin = Ember.Mixin.create
  scroller: null

  onTouchScroll: Ember.K

  didInsertElement: ->
    @_super()
    @setupScroller()
    @updateScrollerDimensions()

  updateScrollerDimensions: ->
    width = @get('width')
    height = @get('height')
    totalHeight = @get('totalHeight')
    @get('scroller').setDimensions(width, height, width, totalHeight)

  setupScroller: ->
    @set 'scroller', new Scroller((left, top, zoom) =>
      return if @state isnt 'inDOM'
      console.log(top)
      @onTouchScroll(left, top, zoom))

  # events
  touchStart: (event) ->
    event = event.originalEvent || event
    @get('scroller').doTouchStart(event.touches, event.timeStamp)

  touchMove: (event) ->
    event = event.originalEvent || event
    @get('scroller').doTouchMove(event.touches, event.timeStamp)

  touchEnd: (event) ->
    event = event.originalEvent || event
    @get('scroller').doTouchEnd(event.timeStamp)
