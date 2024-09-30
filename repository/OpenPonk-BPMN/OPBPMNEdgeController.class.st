Class {
	#name : 'OPBPMNEdgeController',
	#superclass : 'OPDirectionalRelationshipController',
	#category : 'OpenPonk-BPMN-Controllers',
	#package : 'OpenPonk-BPMN',
	#tag : 'Controllers'
}

{ #category : 'accessing' }
OPBPMNEdgeController >> addLabels [
	self constraintLabel: #name balance: 0.4 offset: 12
]

{ #category : 'construction' }
OPBPMNEdgeController >> diagramElementClass [
	^ self subclassResponsibility
]

{ #category : 'private' }
OPBPMNEdgeController >> headMarker [
	"line decoration shape class used as head"

	^ self subclassResponsibility
]

{ #category : 'private' }
OPBPMNEdgeController >> internalSubscribeTo: aModel [

	super internalSubscribeTo: aModel.
	aModel
		when: OPElementRemoved
		send: #removeController
		to: self
]

{ #category : 'private' }
OPBPMNEdgeController >> isHideable [
	^ true
]

{ #category : 'private' }
OPBPMNEdgeController >> modelClass [
	^ self subclassResponsibility
]

{ #category : 'construction' }
OPBPMNEdgeController >> modelSource: aModel in: aParentModel [

	(super modelSource: aModel in: aParentModel) ifFalse: [ ^ false ].
	self modelSource addFlow: model.
	^ true
]

{ #category : 'construction' }
OPBPMNEdgeController >> modelTarget: aModel in: aParentModel [

	(super modelTarget: aModel in: aParentModel) ifFalse: [ ^ false ].
	self modelTarget addFlow: model.
	^ true
]

{ #category : 'private' }
OPBPMNEdgeController >> removeModel [
	self model owner remove: self model.
	self model target removeFlow: self model.
	self model source removeFlow: self model
]
