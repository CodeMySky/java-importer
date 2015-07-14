JavaImporterView = require './java-importer-view'
{CompositeDisposable} = require 'atom'

module.exports = JavaImporter =
  javaImporterView: null
  modalPanel: null
  subscriptions: null

  activate: (state) ->
    atom.commands.add 'atom-workspace', 'java-importer:import', => @import()
  
  import: ->
    editor = atom.workspace.getActivePaneItem()
    selection = editor.getLastSelection()
    
    figlet = require 'figlet'
    figlet selection.getText(), {font: 'Larry 3D 2'}, (error, asciiArt) ->
      if error
        console.error(error)
      else
        selection.insertText("\n#{asciiArt}\n")

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
