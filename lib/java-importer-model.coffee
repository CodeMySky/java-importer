fs = require 'fs'

module.exports = class JavaImporterModel
  atom.deserializers.add(this)
  
  @deserialize: (data) ->
    model = new JavaImporterModel(data.dictionary)
  
  _dictionary: null
  
  constructor: (@_dictionary) ->
    @updateDictionary()
        
  serialize: ->
    deserializer: 'JavaImporterModel'
    dictionary : @_dictionary
            
  updateDictionary: ->
    that = this
    # Recreate _dictionary
    @_dictionary = 
      created: new Date()
    data = require("./data/java8.json")
    
    for path in data.nameList
        name = path.substring path.lastIndexOf('.') + 1
        @_updateDictionaryEntry name, path
    # if atom.project.getDirectories().length == 0
    #   return new Promise()
      
    scanPromise = atom.workspace.scan /package\s+[a-zA-Z0-9_\.]+\s*;/ig, (result) ->  
      filename = result.filePath.replace(/^.*[\\\/]/, '');
      name = filename.split('.')[0];
      packageName = result.matches[0].matchText.replace(/package\s+/,'').replace(';','')
      path = "#{packageName}.#{name}"
      that._updateDictionaryEntry name, path

    
    return scanPromise
    
  getPaths: (name) ->
    return @_dictionary[name]

  _updateDictionaryEntry: (name, path) ->
    pathList = @_dictionary[name]
    if pathList instanceof Array
      if pathList.indexOf(path) == -1
        pathList.push path
    else
      @_dictionary[name] = [path]
