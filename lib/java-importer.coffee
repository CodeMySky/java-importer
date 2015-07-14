JavaImporterView = require './java-importer-view'
JavaBaseClassList = require './java-base-class-list'
{CompositeDisposable} = require 'atom'

module.exports = JavaImporter =
  javaImporterView: null
  modalPanel: null
  subscriptions: null
  classDictionary: null
  
  activate: (state) ->
    atom.commands.add 'atom-workspace', 'java-importer:import', => @import()
  
  import: ->
    editor = atom.workspace.getActivePaneItem()
    selection = editor.getLastSelection()
    grammar = editor.getGrammar().name
    console.log editor.getGrammar().name
    scope = editor.scopeDescriptorForBufferPosition editor.getCursorBufferPosition()
    classDictionary = this.getDictionary()
    className = editor.getWordUnderCursor()
    if classDictionary[className]
      statement = 'import ' + classDictionary[className] + ';'
      atom.clipboard.write statement
      atom.notifications.addSuccess statement
      atom.notifications.addSuccess 'Copied to Your Clipboard'
    else
      atom.notifications.addError className + ' NOT Found'
    #if scope == 'storage.type.java'
      
    #wholeText = editor.getText()
  
  getDictionary: ->
    if this.classDictionary == null
      this.classDictionary = {}
      for classPath in JavaBaseClassList
        lastDot = classPath.lastIndexOf('.')
        className = classPath.substring lastDot + 1
        this.classDictionary[className] = classPath
    return this.classDictionary
    

  deactivate: ->
    @modalPanel.destroy()
    @subscriptions.dispose()
    @javaImporterView.destroy()

  serialize: ->
    javaImporterViewState: @javaImporterView.serialize()

  toggle: ->
    console.log 'JavaImporter was toggled!'

    if @modalPanel.isVisible()
      @modalPanel.hide()
    else
      @modalPanel.show()
