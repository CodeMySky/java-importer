fs = require 'fs'

module.exports = class JavaImporterView 
  _dictionary: null
  activate: (state) ->
    @_dictionary =
      if state && state.created
        state
      else
        @_getDictionary()
            
  updateDictionary: ->
    that = this
    # Recreate _dictionary
    @_dictionary = 
      created: new Date()
    data = require("./data/java8.json")
    
    for path in data.nameList
        name = path.substring path.lastIndexOf('.') + 1
        @_updateDictionaryEntry name, path
    
    scanPromise = atom.workspace.scan /package\s+[a-zA-Z0-9_\.]+\s*;/ig, (result) ->  
      filename = result.filePath.replace(/^.*[\\\/]/, '');
      name = filename.split('.')[0];
      packageName = result.matches[0].matchText.replace(/package\s+/,'').replace(';','')
      path = "#{packageName}.#{name}"
      that._updateDictionaryEntry name, path
      
    return scanPromise
  
  _updateDictionaryEntry: (name, path) ->
    pathList = @_dictionary[name]
    if pathList instanceof Array
      if pathList.indexOf name == -1
        pathList.push(path)
    else
      @_dictionary[name] = [path]
  
  getStatements: (name) ->
    return @_dictionary[name]
