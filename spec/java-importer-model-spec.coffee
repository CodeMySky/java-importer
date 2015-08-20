Model = require '../lib/java-importer-model'
temp = require 'temp'
fs = require 'fs'
path = require 'path'

describe 'Java Importer Model', ->
  [model] = []
  beforeEach ->
    directory = temp.mkdirSync()
    atom.project.setPaths([directory])
    fs.writeFileSync(path.join(directory, 'Test.java'), 'package com.example.testcase1;')
    model = new Model()
    expect(atom.project.getDirectories().length).toBe 1
    waitsForPromise ->
      model.updateDictionary()
    # waitsForPromise -> 
    #   atom.workspace.scan /package/, (result)->
    #     expect(result.matches).toBe(null)
    
  describe "Class Name Matching", ->
    it 'should pull out right path for List', ->
      expect(model.getPaths('List')).toEqual ['java.awt.List','java.util.List']
    
    it 'should correctly scan project classes', ->
      expect(model.getPaths('Test')).toEqual ['com.example.testcase1.Test']
    
  describe 'Function: Organize', ->
    it 'should sort statements properly', ->
      unorderedStatements = ['c','a','b'];
      organizedStatementString = model.organizeStatements(unorderedStatements);
      expect(organizedStatementString).toBe 'a\nb\nc\n'
    
    # It is not supported yet
    xit 'should remove empty string', ->
      unorderedStatements = ['a','\n','\n','b'];
      organizedStatementString = model.organizeStatements(unorderedStatements);
      expect(organizedStatementString).toBe 'a\nb\n'
      
    it 'should remove trailing space', ->
      unorderedStatements = ['a  ','b   '];
      organizedStatementString = model.organizeStatements(unorderedStatements);
      expect(organizedStatementString).toBe 'a\nb\n'
