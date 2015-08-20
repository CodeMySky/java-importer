fs = require 'fs'

module.exports = class JavaImporterModel
  atom.deserializers.add(this)
  
  #######################################
  ##  Properties
  #######################################
  m_dictionary: null
  
  #######################################
  ##  Constructor
  #######################################
  constructor: (@m_dictionary) ->
    @updateDictionary()
  
  #######################################
  ##  Serialization and Deserialization
  #######################################
  serialize: ->
    deserializer: 'JavaImporterModel'
    dictionary : @m_dictionary
    
  @deserialize: (data) ->
    model = new JavaImporterModel(data.dictionary)
        
  #######################################
  ##  Function: Update
  #######################################
  updateDictionary: ->
    that = this
    # Recreate m_dictionary
    @m_dictionary = 
      created: new Date()
    data = require("./data/java8.json")
    
    for path in data.nameList
        name = path.substring path.lastIndexOf('.') + 1
        @_updateDictionaryEntry name, path
    
    # Stop local scan if there is no directory present
    if atom.project.getDirectories().length == 0
      return new Promise ->
      
    scanPromise = atom.workspace.scan /package\s+[a-zA-Z0-9_\.]+\s*;/ig, (result) ->  
      filename = result.filePath.replace(/^.*[\\\/]/, '');
      name = filename.split('.')[0];
      packageName = result.matches[0].matchText.replace(/package\s+/,'').replace(';','')
      path = "#{packageName}.#{name}"
      that._updateDictionaryEntry name, path
    
    return scanPromise
    
  getPaths: (name) ->
    return @m_dictionary[name]

  _updateDictionaryEntry: (name, path) ->
    pathList = @m_dictionary[name]
    if pathList instanceof Array
      if pathList.indexOf(path) == -1
        pathList.push path
    else
      @m_dictionary[name] = [path]
      
  ########################################
  ##  Start Organize Function
  ########################################
  organizeStatements: (statements) ->
    statements = statements.map (s) ->
      return String.prototype.trim.apply(s)
    statements = statements.sort()
    finalStatement = ''
    for statement in statements
      finalStatement += statement + '\n'
    return finalStatement
