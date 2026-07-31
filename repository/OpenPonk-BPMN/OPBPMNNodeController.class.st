Class {
	#name : 'OPBPMNNodeController',
	#superclass : 'OPElementController',
	#category : 'OpenPonk-BPMN-Controllers',
	#package : 'OpenPonk-BPMN',
	#tag : 'Controllers'
}

{ #category : 'accessing' }
OPBPMNNodeController >> dependentElements [

	^ self model edges asSet
]

{ #category : 'announcements' }
OPBPMNNodeController >> internalSubscribeTo: aModel [

	super internalSubscribeTo: aModel.
	aModel weakWhen: OPElementRemoved send: #removeControllerAndDiagramElement to: self
]

{ #category : 'destruction' }
OPBPMNNodeController >> removeModel [

	self model owner remove: self model
]
