Class {
	#name : 'OPBPMNNodeController',
	#superclass : 'OPElementController',
	#classInstVars : [
		'PossibleOutgoing'
	],
	#category : 'OpenPonk-BPMN-Controllers',
	#package : 'OpenPonk-BPMN',
	#tag : 'Controllers'
}

{ #category : 'forms' }
OPBPMNNodeController >> buildEditorForm: aForm [
	(aForm addText: 'Name')
		text: self model name;
		whenTextChangedDo: [ :newValue | 
			self model name: newValue asString.
			self diagramElement modelChanged ]
]

{ #category : 'announcements' }
OPBPMNNodeController >> internalSubscribeTo: aModel [

	super internalSubscribeTo: aModel.
	aModel weakWhen: OPElementRemoved send: #removeControllerAndDiagramElement to: self
]

{ #category : 'testing' }
OPBPMNNodeController >> isHideable [
	^ true
]

{ #category : 'private' }
OPBPMNNodeController >> removeModel [

	self model owner remove: self model
]
