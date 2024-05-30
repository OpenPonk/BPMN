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

{ #category : 'connecting' }
OPBPMNNodeController >> addAsTargetFor: aController [
	self assert: (self canBeTargetFor: aController).
	aController target: self.
	aController
		createModelIn: self model
		andShowInDiagram: self diagramController
]

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
	aModel
		when: OPElementRemoved
		send: #removeController
		to: self
]

{ #category : 'testing' }
OPBPMNNodeController >> isHideable [
	^ true
]

{ #category : 'connecting' }
OPBPMNNodeController >> modelAsParent [
	^ self model owner
]

{ #category : 'private' }
OPBPMNNodeController >> removeModel [
	self model announcer unsubscribe: self.
	self diagramController model remove: self model
]
