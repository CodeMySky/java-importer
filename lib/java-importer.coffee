JavaImporterView = require './java-importer-view'
JavaBaseClassList = require './java-base-class-list'
JavaImporterView = require './java-importer-view'
{DirectorySearch} = require 'atom'

module.exports = JavaImporter =
  javaImporterView: null
  modalPanel: null
  subscriptions: null
  classDictionary: null
  debug: false
  
  activate: (state) ->
    atom.commands.add 'atom-workspace', 'java-importer:import', => @import()
    atom.commands.add 'atom-workspace', 'java-importer:organize', => @organize()
    @classDictionary =
      if state && state.created
        state
      else
        @getDictionary()
      
  import: ->
    @javaImporterView = new JavaImporterView()
    className = @javaImporterView.getSelection()
    
    if @classDictionary && @classDictionary[className]
      @javaImporterView.addAll(@classDictionary[className])
      @javaImporterView.show()
    else
      atom.notifications.addError "Class: <code>#{className}</code> is NOT Found"
  
  tranverse:  ->
    that = this
    promise = atom.workspace.scan /package\s+[a-zA-Z0-9_\.]+\s*;/ig, (result) ->
      filename = result.filePath.replace(/^.*[\\\/]/, '');
      className = filename.split('.')[0];
      packageName = result.matches[0].matchText.replace(/package\s+/,'').replace(';','')
      classPath = "#{packageName}.#{className}"
      if that.classDictionary[className] instanceof Array
        that.classDictionary[className].push(classPath)
      else
        that.classDictionary[className] = [classPath]
    promise.done ->
      atom.notifications.addSuccess 'Project scanning finished'
            
  getDictionary: (callback)->
    if @classDictionary == null || !@classDictionary.hasOwnProperty()
      @classDictionary = {created: new Date()}
      for classPath in JavaBaseClassList
        lastDot = classPath.lastIndexOf('.')
        className = classPath.substring lastDot + 1
        @classDictionary[className] = [classPath]
      directories =  atom.project.getDirectories()
      atom.notifications.addSuccess 'Project scanning started'
      @tranverse()
    return @classDictionary

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
    if @javaImporterView
      @javaImporterView.destroy()

  serialize: ->
    if @classDictionary
      @classDictionary
