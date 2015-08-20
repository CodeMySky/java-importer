ImporterView = require '../lib/java-importer-view'

# Use the command `window:run-package-specs` (cmd-alt-ctrl-p) to run specs.
#
# To run a specific `it` or `describe` block add an `f` to the front (e.g. `fit`
# or `fdescribe`). Remove the `f` to unfocus the block.

describe 'Java Importer View', ->
  [view, editor] = []

  beforeEach ->
    view = new ImporterView()
    
    waitsForPromise ->
      atom.workspace.open('./test/resources/sample.txt').then ->
        editor = atom.workspace.getActiveTextEditor()
      
  describe 'Should select word properly', ->
    it 'should load test file correctly', ->
      expect(atom.workspace.getActiveTextEditor().getText()).not.toBe("")
    
    # |List
    it 'should extract right selection from beginning of text', ->
      editor.setCursorBufferPosition([0,0])
      expect(view.getSelection()).toBe 'List'
    
    # Li|st
    it 'should extract right selection from middle of text', ->
      editor.setCursorBufferPosition([0,1])
      expect(view.getSelection()).toBe 'List'
    
    # List|
    it 'should extract right selection from end of text', ->
      editor.setCursorBufferPosition([0,3])
      expect(view.getSelection()).toBe 'List'
      
    # [List]  
    it 'should extract right selection with full selection of the text', ->
      editor.setSelectedBufferRange([[0,0],[0,4]])
      expect(view.getSelection()).toBe 'List'
    
    # [Li]st
    it 'should not extract right selection with half selection of the text', ->
      editor.setSelectedBufferRange([[0,0],[0,2]])
      expect(view.getSelection()).not.toBe 'List'
    
    # Ma|p<HashMap>
    it 'should extract right selection with angle brackets and at middle of text', ->
      editor.setCursorBufferPosition([1,2])
      expect(view.getSelection()).toBe 'Map'
    
    # Ma|p<HashMap>
    it 'should extract right selection with angle brackets and before bracket', ->
      editor.setCursorBufferPosition([1,3])
      expect(view.getSelection()).toBe 'Map'
      
    # Map<|HashMap>
    it 'should extract right selection with angle brackets and in bracket', ->
      editor.setCursorBufferPosition([1,4])
      expect(view.getSelection()).toBe 'HashMap'
      
    # Map<Hash|Map>
    it 'should extract right selection with angle brackets and in middle of bracket', ->
      editor.setCursorBufferPosition([1,6])
      expect(view.getSelection()).toBe 'HashMap'
    
    it 'should extract right selection with square brackets', ->
      editor.setCursorBufferPosition([2,4])
      expect(view.getSelection()).toBe 'ArrayList'
  
  describe 'Function: Update', ->
    it 'should have a confirmed method', ->
      expect(view.confirmed).toBeDefined()
    
    it 'should write to clipboard', ->
      view.confirmed('test')
      expect(atom.clipboard.read()).toBe 'import test;'
  
  describe 'Function: Organize', ->
    it 'should write to clipboard properly', ->
      view.copyOrganizedStatementString('test')
      expect(atom.clipboard.read()).toBe 'test'
