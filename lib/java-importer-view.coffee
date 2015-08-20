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
    @itemList = []
    if itemList && itemList.length
      for item in itemList
        @itemList.push(item);
    
  show: ->
    if @itemList.length > 1
      @setItems(@itemList)
      @panel.show()
      @focusFilterEditor()
    else if @itemList.length == 1
      @confirmed(@itemList[0])
  
  confirmed: (item) ->
    statement = 'import ' + item + ';'
    atom.clipboard.write statement
    @sendStatementFoundNotification statement
    @panel.hide()
   
  cancelled: ->
    @panel.hide()
    
  # Select right class name from text.
  getSelection: ->
    editor = atom.workspace.getActiveTextEditor()
    selection = editor.getLastSelection()
    selectedText = selection.getText()
    if selectedText.length == 0
      selection.selectWord()
      selectedText = selection.getText()
    return selectedText
  
  #############################################
  ## Function: Organize Statements
  #############################################
  
  copyOrganizedStatementString: (organizedStatementString) ->
    atom.clipboard.write organizedStatementString
  
  #############################################
  ##  Function: Send Notifications
  #############################################
  
  sendStatementFoundNotification: (statement)->
    atom.notifications.addSuccess statement
    atom.notifications.addSuccess 'Copied to Your Clipboard'
    
  sendStatementNotFoundNotification: (className) ->
    atom.notifications.addError "Class: <code>#{className}</code> is NOT Found"
    
  sendProjectScanFinishedNotification: ->
    atom.notifications.addSuccess 'Project scanning finished'
    
  sendOrganizeFinishedNotification: ->
    atom.notifications.addSuccess 'Organized Statements Copied to Your Clipboard'
  
