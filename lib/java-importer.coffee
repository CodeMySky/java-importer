View = require './java-importer-view'
Model = require './java-importer-model'

module.exports = JavaImporter =
  #######################################
  ##  Properties
  #######################################
  m_view: null
  m_model: null
  m_scanPromise: null
  
  #######################################
  ##  Serialization and Deserialization
  #######################################
  activate: (state) ->
    # Add commands to command dropdown
    atom.commands.add 'atom-workspace', 'java-importer:import', => @import()
    atom.commands.add 'atom-workspace', 'java-importer:organize', => @organize()
    atom.commands.add 'atom-workspace', 'java-importer:update', => @update()
    
    # Recover from serialized state if possible
    if state && state.model
      @m_model = atom.deserializers.deserialize(state.model)
    else
      @m_model = new Model()
    @update()
    
    # Create new view
    @m_view = new View()
  
  deactivate: ->
      
  serialize: ->
    if (@m_scanPromise)
      @m_scanPromise.cancel()
    model: @m_model.serialize()
  
  #######################################
  ##  Function: Update
  #######################################
  update: ->
    that = this
    @scanPromise = @m_model.updateDictionary()
    @scanPromise.then ->
        that.m_view.sendProjectScanFinishedNotification()
        
  #######################################
  ##  Function: Import
  #######################################    
  import: ->
    selectedText = @m_view.getSelection()
    matchedPaths = @m_model.getPaths selectedText
    if matchedPaths
      @m_view.addAll matchedPaths
      @m_view.show()
    else
      @m_view.sendStatementNotFoundNotification selectedText
    
  #######################################
  ##  Function: Organize Statements
  #######################################
  organize: ->
    selectedText = @m_view.getSelection()
    statements = selectedText.split('\n')
    
    # Avoid single line and empty statement
    if (statements.length > 1)
      organizedStatementString = 
        @m_model.organizeStatements(statements)
      @m_view.copyOrganizedStatementString(organizedStatementString)
