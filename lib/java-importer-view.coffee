{SelectListView} = require 'atom-space-pen-views'

module.exports =
class JavaImporterView extends SelectListView
  
  test: 'test'
  initialize: ->
    super
    @addClass('overlay from-top')
    @panel ?= atom.workspace.addModalPanel(item: this)
    @panel.hide()
    @itemList = []
   
  viewForItem: (item) ->
    "<li>#{item}</li>"
    
  addAll: (itemList) ->
    if itemList && itemList.length
      for item in itemList
        @itemList.push(item);
    
  show: ->
    debugger
    if @itemList.length > 1
      @setItems(@itemList)
      @panel.show()
      @focusFilterEditor()
    else if @itemList.length == 1
      @confirmed(@itemList[0])
  
  confirmed: (item) ->
    statement = 'import ' + item + ';'
    atom.clipboard.write statement
    atom.notifications.addSuccess statement
    atom.notifications.addSuccess 'Copied to Your Clipboard'
    @panel.hide()
   
  cancelled: ->
    @panel.hide()
    
  # Select right class name from text.
  getSelection: ->
    editor = atom.workspace.getActiveTextEditor()
    selection = editor.getLastSelection()
    className = selection.getText()
    if className.length == 0
      selection.selectWord()
      className = selection.getText()
    return className
