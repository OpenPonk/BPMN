"
I am the base controller for directional BPMN edges, managing interactions for sequence flows, message flows, and data associations.
"
Class {
	#name : 'OPBPMNEdgeController',
	#superclass : 'OPDirectionalRelationshipController',
	#category : 'OpenPonk-BPMN-Controllers',
	#package : 'OpenPonk-BPMN',
	#tag : 'Controllers'
}

{ #category : 'connecting' }
OPBPMNEdgeController >> canConnectSource: aSourceController toTarget: aTargetController [
	"Answers whether this edge can validly link the source and target controllers."
	aSourceController ifNil: [ ^ true ].
	(aSourceController canBeSourceFor: self) ifFalse: [ ^ false ].
	^ aSourceController ~~ aTargetController
]

{ #category : 'connecting' }
OPBPMNEdgeController >> canConnectTo: aTargetController [
	"Answers whether this edge can connect to the given target controller."
	^ self canConnectSource: self source toTarget: aTargetController
]

{ #category : 'private' }
OPBPMNEdgeController >> enclosingSubProcessOf: aModelElement [
	| currentOwner |
	(aModelElement isKindOf: OPBPMNBoundaryEventModel) ifTrue: [
		^ aModelElement owner ifNotNil: [ :hostModel |
			self enclosingSubProcessOf: hostModel ] ].
	currentOwner := aModelElement owner.
	[ currentOwner isNotNil ] whileTrue: [
		(currentOwner isKindOf: OPBPMNSubProcessModel) ifTrue: [ ^ currentOwner ].
		(currentOwner isKindOf: OPBPMNPoolModel) ifTrue: [ ^ nil ].
		(currentOwner isKindOf: OPBPMNModel) ifTrue: [ ^ nil ].
		currentOwner := currentOwner owner ].
	^ nil
]
