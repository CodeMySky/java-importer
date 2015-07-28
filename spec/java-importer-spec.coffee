JavaImporter = require '../lib/java-importer'
ImporterView = require '../lib/java-importer-view'

# Use the command `window:run-package-specs` (cmd-alt-ctrl-p) to run specs.
#
# To run a specific `it` or `describe` block add an `f` to the front (e.g. `fit`
# or `fdescribe`). Remove the `f` to unfocus the block.

describe 'JavaImporter', ->
  [workspaceElement, activationPromise, view] = []

  beforeEach ->
    workspaceElement = atom.views.getView(atom.workspace)
    waitsForPromise ->
      atom.packages.activatePackage('java-importer')

  describe 'Should have all commands', ->
    it 'Should be activated without problem', ->
      expect(atom.packages.isPackageActive('java-importer')).toBe true
      
  describe 'Should select word properly', ->
    beforeEach -> 
      waitsForPromise ->
        atom.workspace.open('sample.txt')
      view = new ImporterView()
        
    it 'Test file should exists', ->
      expect(atom.workspace.getActiveTextEditor().getText()).not.toBe("")
    
    # |List
    it 'should extract right selection from beginning of text', ->
      editor = atom.workspace.getActiveTextEditor()
      editor.setCursorBufferPosition([0,0])
      expect(view.getSelection()).toBe 'List'
    
    # Li|st
    it 'should extract right selection from middle of text', ->
      editor = atom.workspace.getActiveTextEditor()
      editor.setCursorBufferPosition([0,1])
      expect(view.getSelection()).toBe 'List'
    
    # List|
    it 'should extract right selection from end of text', ->
      editor = atom.workspace.getActiveTextEditor()
      editor.setCursorBufferPosition([0,3])
      expect(view.getSelection()).toBe 'List'
    # [List]  
    it 'should extract right selection with full selection of the text', ->
      editor = atom.workspace.getActiveTextEditor()
      editor.setSelectedBufferRange([[0,0],[0,4]])
      expect(view.getSelection()).toBe 'List'
    
    # [Li]st
    it 'should not extract right selection with half selection of the text', ->
      editor = atom.workspace.getActiveTextEditor()
      editor.setSelectedBufferRange([[0,0],[0,2]])
      expect(view.getSelection()).not.toBe 'List'
    
    # Ma|p<HashMap>
    it 'should extract right selection with angle brackets and at middle of text', ->
      editor = atom.workspace.getActiveTextEditor()
      editor.setCursorBufferPosition([1,2])
      expect(view.getSelection()).toBe 'Map'
    
    # Ma|p<HashMap>
    it 'should extract right selection with angle brackets and before bracket', ->
      editor = atom.workspace.getActiveTextEditor()
      editor.setCursorBufferPosition([1,3])
      expect(view.getSelection()).toBe 'Map'
      
    # Map<|HashMap>
    it 'should extract right selection with angle brackets and in bracket', ->
      editor = atom.workspace.getActiveTextEditor()
      editor.setCursorBufferPosition([1,4])
      expect(view.getSelection()).toBe 'HashMap'
      
    # Map<Hash|Map>
    it 'should extract right selection with angle brackets and in middle of bracket', ->
      editor = atom.workspace.getActiveTextEditor()
      editor.setCursorBufferPosition([1,6])
      expect(view.getSelection()).toBe 'HashMap'
    
    it 'should extract right selection with square brackets', ->
      editor = atom.workspace.getActiveTextEditor()
      editor.setCursorBufferPosition([2,4])
      expect(view.getSelection()).toBe 'ArrayList'
