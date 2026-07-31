Class {
	#name : 'OPBPMNSemanticNodeController',
	#superclass : 'OPBPMNNodeController',
	#category : 'OpenPonk-BPMN-Controllers',
	#package : 'OpenPonk-BPMN',
	#tag : 'Controllers'
}

{ #category : 'forms' }
OPBPMNSemanticNodeController >> buildEditorForm: aForm [
	(aForm addText: 'Name')
		text: self model name;
		whenTextChangedDo: [ :newValue | 
			self model name: newValue asString.
			self modelChanged ]
]
