Class {
	#name : #OPBPMNNodeModel,
	#superclass : #OPModelObject,
	#instVars : [
		'flows',
		'type'
	],
	#category : #'OpenPonk-BPMN-Models'
}

{ #category : #associating }
OPBPMNNodeModel >> -> aNode [
	^ OPBPMNFactory transitionFrom: self to: aNode
]

{ #category : #accessing }
OPBPMNNodeModel >> addFlow: aFlow [
	(flows includes: aFlow)
		ifTrue: [ ^ self ].
	flows add: aFlow.
	aFlow source = self
		ifTrue: [ 
			aFlow addedTo: self.
			self announceAdded: aFlow ]
		ifFalse: [ self changed ]
]

{ #category : #accessing }
OPBPMNNodeModel >> connected [
	owner ifNil: [ ^ #() ].
	^ owner flows
		select: [ :each | each source = self or: [ each target = self ] ]
]

{ #category : #accessing }
OPBPMNNodeModel >> defaultType [
	^ OPBPMNNodeType None
]

{ #category : #accessing }
OPBPMNNodeModel >> flows [
	^ flows
]

{ #category : #accessing }
OPBPMNNodeModel >> has: anElement [
	^ flows includes: anElement
]

{ #category : #accessing }
OPBPMNNodeModel >> incoming [
	^ flows select: [ :each | each target = self ]
]

{ #category : #accessing }
OPBPMNNodeModel >> initialize [
	super initialize.
	type := self defaultType.
	flows := OrderedCollection new
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
	^ flows select: [ :each | each source = self ]
]

{ #category : #accessing }
OPBPMNNodeModel >> relatedElements [
	^ (self incoming , self outgoing) asSet asOrderedCollection
]

{ #category : #accessing }
OPBPMNNodeModel >> removeAllFlows [
	flows copy
		do: [ :each | 
			each source removeFlow: each.
			each target removeFlow: each ]
]

{ #category : #accessing }
OPBPMNNodeModel >> removeFlow: aFlow [
	flows remove: aFlow

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
