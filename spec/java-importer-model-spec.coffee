Model = require '../lib/java-importer-model'

describe 'Java Importer Model', ->
  [model] = []
  beforeEach ->
    model = new Model()
    atom.project.addPath("#{__dirname}/test")
    expect(atom.project.getDirectories().length).toBe 1
    waitsForPromise ->
      model.updateDictionary()
    
  describe "Class Name Matching", ->
    it 'should pull out right path for List', ->
      expect(model.getStatements('List')).toEqual ['java.awt.List','java.util.List']
    
    it 'should correctly scan project classes', ->
      expect(model.getStatements('Test')).toEqual ['com.example.testcase1.Test','com.example.testcase2.Test']
    
