View = require './java-importer-view'
Model = require './java-importer-model'
{DirectorySearch} = require 'atom'

module.exports = JavaImporter =
  _view: null
  debug: false
  
  activate: (state) ->
    that = this
    atom.commands.add 'atom-workspace', 'java-importer:import', => @import()
    atom.commands.add 'atom-workspace', 'java-importer:organize', => @organize()
    atom.commands.add 'atom-workspace', 'java-importer:update', => @update()
    @_model = new Model()
    @_view = new View()
    @update()
  
  update: ->
    that = this
    @_model.updateDictionary()
      .then ->
        that._view.sendProjectScanFinishedNotification()
    # if state
    #   # Deserialize model
    # else
    #   @_model = new Model()
    #   @_model.updateDictionary().then ->
    #     @_view.sendProjectScanFinishedNotification()
    
  import: ->
    # @view = new View()
    className = @_view.getSelection()
    
    if @_model.getStatements(className)
      @_view.addAll(@classDictionary[className])
      @_view.show()
    else
      @_view.sendStatementNotFoundNotification(className)
  
  

  organize: ->
    console.log("Ready to organize")
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
    if @classDictionary
      @classDictionary
