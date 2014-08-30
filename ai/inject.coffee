define ->
	class Inject
    constructor: ->
      @bindings = {}

    bind: (key, item) =>
      if key is Object key
        @bind k, i for k, i of key
        return

      @bindings[key] = [] if !@bindings[key]?

      if Array.isArray item
        @bindings[key].push i for i in item
      else
        @bindings[key].push item
    
    one: (key) =>
      throw "[pminject] Nothing bound for '#{key}'!" if !@bindings[key]?
      items = @bindings[key]
      throw "[pminject] '#{key}' has too many bindings to inject one!" if items.length > 1
      items[0]

    oneornone: (key) =>
      return null if !@bindings[key]?
      items = @bindings[key]
      throw "[pminject] '#{key}' has too many bindings to inject oneornone!" if items.length > 1
      items[0]

    first: (key) =>
      throw "[pminject] Nothing bound for '#{key}'!" if !@bindings[key]?
      @bindings[key][0]

    firstornone: (key) =>
      return null if !@bindings[key]?
      @bindings[key][0]

    many: (key) =>
      return [] if !@bindings[key]?
      @bindings[key]

    clear: (key) => delete @bindings[key]
  
  new Inject()