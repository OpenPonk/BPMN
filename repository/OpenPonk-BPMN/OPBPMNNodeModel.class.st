Class {
	#name : 'OPBPMNNodeModel',
	#superclass : 'OPModelObject',
	#instVars : [
		'flows',
		'type',
		'executableAttribute',
		'executableAttributeValue'
	],
	#category : 'OpenPonk-BPMN-Models',
	#package : 'OpenPonk-BPMN',
	#tag : 'Models'
}

{ #category : 'associating' }
OPBPMNNodeModel >> -> aNode [
	^ OPBPMNFactory flowFrom: self to: aNode
]

{ #category : 'accessing' }
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

{ #category : 'associating' }
OPBPMNNodeModel >> allEntities [
	^ Set with: self flows
]

{ #category : 'accessing' }
OPBPMNNodeModel >> connected [
	owner ifNil: [ ^ #() ].
	^ owner flows
		select: [ :each | each source = self or: [ each target = self ] ]
]

{ #category : 'accessing' }
OPBPMNNodeModel >> defaultType [
	^ OPBPMNNodeType None
]

{ #category : 'printing' }
OPBPMNNodeModel >> executableAttribute [
	^ executableAttribute
]

{ #category : 'printing' }
OPBPMNNodeModel >> executableAttribute: anAttribute [
	executableAttribute := anAttribute
]

{ #category : 'printing' }
OPBPMNNodeModel >> executableAttributeValue [
	^ executableAttributeValue
]

{ #category : 'printing' }
OPBPMNNodeModel >> executableAttributeValue: anAttribute [
	executableAttributeValue := anAttribute
]

{ #category : 'accessing' }
OPBPMNNodeModel >> flows [
	^ flows
]

{ #category : 'accessing' }
OPBPMNNodeModel >> has: anElement [
	^ flows includes: anElement
]

{ #category : 'accessing' }
OPBPMNNodeModel >> incoming [
	^ flows select: [ :each | each target = self ]
]

{ #category : 'accessing' }
OPBPMNNodeModel >> initialize [
	super initialize.
	type := self defaultType.
	flows := OrderedCollection new.
	executableAttributeValue := ''
]

{ #category : 'testing' }
OPBPMNNodeModel >> isEdge [
	^ false
]

{ #category : 'testing' }
OPBPMNNodeModel >> isNode [
	^ true
]

{ #category : 'accessing' }
OPBPMNNodeModel >> nodes [
	^ elements 
]

{ #category : 'accessing' }
OPBPMNNodeModel >> outgoing [
	^ flows select: [ :each | each source = self ]
]

{ #category : 'printing' }
OPBPMNNodeModel >> printIdType [
	^ '_6-'
]

{ #category : 'accessing' }
OPBPMNNodeModel >> relatedElements [
	^ (self incoming , self outgoing) asSet asOrderedCollection
]

{ #category : 'accessing' }
OPBPMNNodeModel >> removeAllFlows [
	flows copy
		do: [ :each | 
			each source removeFlow: each.
			each target removeFlow: each ]
]

{ #category : 'accessing' }
OPBPMNNodeModel >> removeFlow: aFlow [
	flows remove: aFlow

]

{ #category : 'accessing' }
OPBPMNNodeModel >> removedFrom: aDiagram [
	self
		removedFrom: aDiagram
		do: [ self incoming do: [ :each | aDiagram remove: each ].
			self outgoing do: [ :each | aDiagram remove: each ] ]
]

{ #category : 'accessing' }
OPBPMNNodeModel >> type [
	^ type
]

{ #category : 'accessing' }
OPBPMNNodeModel >> type: aParticipantType [
	type := aParticipantType.
	self changed
]
