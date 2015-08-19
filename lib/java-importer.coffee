View = require './java-importer-view'
Model = require './java-importer-model'

module.exports = JavaImporter =
  _view: null
  _model: null
  
  # Recover from suspension.
  activate: (state) ->
    that = this
    atom.commands.add 'atom-workspace', 'java-importer:import', => @import()
    atom.commands.add 'atom-workspace', 'java-importer:organize', => @organize()
    @_view = new View()
    
    if state && state.model
      @_model = atom.deserializers.deserialize(state.model)
    else
      @_model = new Model()
      @_model.updateDictionary()
        .then ->
          that._view.sendProjectScanFinishedNotification()
    
  import: ->
    selectedText = @_view.getSelection()
    matchedPaths = @_model.getPaths selectedText
    console.log matchedPaths
    if matchedPaths
      @_view.addAll matchedPaths
      @_view.show()
    else
      @_view.sendStatementNotFoundNotification selectedText

  organize: ->
    console.log("Ready to organize test")
    editor = atom.workspace.getActivePaneItem()
    selection = editor.getLastSelection()
    text =  selection.getText()
    statements = text.split('\n')
    statements.map (s) ->
       return String.prototype.trim.apply(s)
    statements = statements.sort()
    finalStatement = ''
    for statement in statements
      finalStatement += statement + '\n'
    atom.clipboard.write finalStatement
    atom.notifications.addSuccess 'Organized Statements Copied to Your Clipboard'  


  deactivate: ->
    if @modalPanel
      @modalPanel.destroy()
    if @subscriptions
      @subscriptions.dispose()
    if @view
      @view.destroy()

  serialize: ->
    model: @_model.serialize()
