Class {
	#name : #OPBPMNNodeModel,
	#superclass : #OPBPMNModel,
	#instVars : [
		'type'
	],
	#category : #'OpenPonk-BPMN-Models'
}

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
OPBPMNNodeModel >> incoming [
	owner ifNil: [ ^ #() ].
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
	owner ifNil: [ ^ #() ].
	^ owner edges select: [ :each | each source = self ]
]

{ #category : #accessing }
OPBPMNNodeModel >> relatedElements [
	^ (self incoming , self outgoing) asSet asOrderedCollection
]

{ #category : #accessing }
OPBPMNNodeModel >> removedFrom: aDiagram [
	self
		removedFrom: aDiagram
		do: [ self incoming do: [ :each | aDiagram remove: each ].
			self outgoing do: [ :each | aDiagram remove: each ] ]
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
