JavaImporterView = require './java-importer-view'
JavaBaseClassList = require './java-base-class-list'
{search, PathScanner, PathSearcher} = require 'scandal'
JavaImporterView = require './java-importer-view'
{DirectorySearch} = require 'atom'

module.exports = JavaImporter =
  javaImporterView: null
  modalPanel: null
  subscriptions: null
  classDictionary: null
  
  activate: (state) ->
    atom.commands.add 'atom-workspace', 'java-importer:import', => @import()
    atom.commands.add 'atom-workspace', 'java-importer:organize', => @organize()
    this.classDictionary = {}
    console.log "java importer activated"
    # TODO: recover directory from state.
    # if state.hasOwnProperty()
    #   this.classDictionary = state;
    # else
    #   this.getDictionary()
      
  import: ->
    @javaImporterView = new JavaImporterView()
    #@javaImporterView.viewForItem('HEEYYY')
    editor = atom.workspace.getActivePaneItem()
    selection = editor.getLastSelection()
    grammar = editor.getGrammar().name
    #scope = editor.scopeDescriptorForBufferPosition editor.getCursorBufferPosition()
    classDictionary = this.getDictionary()
    className = editor.getWordUnderCursor()
    if classDictionary[className]
      statement = 'import ' + classDictionary[className] + ';'
      
      @javaImporterView.addAll(classDictionary[className])
      @javaImporterView.show()
    else
      atom.notifications.addError 'Class: ' + className + ' is NOT Found'
  
  tranverse: (entry, callback) ->
    that = this
    path = entry.getRealPathSync()
    scanner = new PathScanner(path, inclusions:['*.java'])
    searcher = new PathSearcher()
    
    searcher.on 'results-found',(result)->
      filename = result.filePath.replace(/^.*[\\\/]/, '');
      className = filename.split('.')[0];
      packageName = result.matches[0].matchText.replace(/package\s+/,'').replace(';','')
      classPath = "#{packageName}.#{className}"
      if !that.classDictionary[className]
        that.classDictionary[className] = [classPath]
      else
        that.classDictionary[className].push(classPath)

    search /package\s+[a-zA-Z0-9_\.]+\s*;/ig, scanner, searcher, ->
      callback()
            
  getDictionary: (callback)->
    if this.classDictionary == null
      this.classDictionary = {}
      for classPath in JavaBaseClassList
        lastDot = classPath.lastIndexOf('.')
        className = classPath.substring lastDot + 1
        this.classDictionary[className] = classPath
      directories =  atom.project.getDirectories()
      for directory in directories
        this.tranverse directory
    return this.classDictionary

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
    @modalPanel.destroy()
    @subscriptions.dispose()
    @javaImporterView.destroy()
    

  serialize: ->
    javaImporterViewState: @javaImporterView.serialize()
    return this.classDictionary
