Class {
	#name : #OPBPMNNodeModel,
	#superclass : #OPBPMNModel,
	#instVars : [
		'transitions',
		'type'
	],
	#category : #'OpenPonk-BPMN-Models'
}

{ #category : #associating }
OPBPMNNodeModel >> -> aNode [
	^ OPBPMNFactory transitionFrom: self to: aNode
]

{ #category : #accessing }
OPBPMNNodeModel >> addTransition: aTransition [
	(transitions includes: aTransition)
		ifTrue: [ ^ self ].
	transitions add: aTransition.
	aTransition source = self
		ifTrue: [ 
			aTransition addedTo: self.
			self announceAdded: aTransition ]
		ifFalse: [ self changed ]
]

{ #category : #accessing }
OPBPMNNodeModel >> connected [
	owner ifNil: [ ^ #() ].
	^ owner edges
		select: [ :each | each source = self or: [ each target = self ] ]
]

{ #category : #accessing }
OPBPMNNodeModel >> defaultType [
	^ OPBPMNNodeType None
]

{ #category : #accessing }
OPBPMNNodeModel >> has: anElement [
	^ transitions includes: anElement
]

{ #category : #accessing }
OPBPMNNodeModel >> incoming [
	^ transitions select: [ :each | each target = self ]
]

{ #category : #accessing }
OPBPMNNodeModel >> initialize [
	super initialize.
	type := self defaultType.
	transitions := OrderedCollection new
]

{ #category : #testing }
OPBPMNNodeModel >> isEdge [
	^ false
]

{ #category : #testing }
OPBPMNNodeModel >> isNode [
	^ true
]

{ #category : #accessing }
OPBPMNNodeModel >> outgoing [
	^ transitions select: [ :each | each source = self ]
]

{ #category : #accessing }
OPBPMNNodeModel >> relatedElements [
	^ (self incoming , self outgoing) asSet asOrderedCollection
]

{ #category : #accessing }
OPBPMNNodeModel >> removeAllTransitions [
	transitions copy
		do: [ :each | 
			each source removeTransition: each.
			each target removeTransition: each ]
]

{ #category : #accessing }
OPBPMNNodeModel >> removeTransition: aTransition [
	transitions remove: aTransition.
	aTransition source = self
		ifTrue: [ 
			aTransition removedFrom: self.
			self announceRemoved: aTransition ]
]

{ #category : #accessing }
OPBPMNNodeModel >> removedFrom: aDiagram [
	self
		removedFrom: aDiagram
		do: [ self incoming do: [ :each | aDiagram remove: each ].
			self outgoing do: [ :each | aDiagram remove: each ] ]
]

{ #category : #accessing }
OPBPMNNodeModel >> transitions [
	^ transitions
]

{ #category : #accessing }
OPBPMNNodeModel >> type [
	^ type
]

{ #category : #accessing }
OPBPMNNodeModel >> type: aParticipantType [
	type := aParticipantType.
	self changed
]
