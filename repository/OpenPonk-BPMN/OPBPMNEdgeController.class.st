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
OPBPMNEdgeController >> createModelIn: aParentModel [
	self model: self modelClass new.
	model source: self source model.
	model target: self target model.
	source model addFlow: model.
	target model addFlow: model.
	"(aParentModel owner isKindOf: OPBPMNPoolModel) 
	ifTrue: [ (aParentModel owner) owner add: model ]
	ifFalse: [ aParentModel owner add: model ]."
	^ model
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

{ #category : 'private' }
OPBPMNEdgeController >> removeModel [
	self diagramController model remove: self model.
	self model target removeFlow: self model.
	self model source removeFlow: self model
]
