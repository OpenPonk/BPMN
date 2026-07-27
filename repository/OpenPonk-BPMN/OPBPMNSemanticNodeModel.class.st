Class {
	#name : 'OPBPMNSemanticNodeModel',
	#superclass : 'OPBPMNNodeModel',
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
OPBPMNSemanticNodeModel >> => aNode [

	^ OPBPMNFactory flowFrom: self to: aNode
]

{ #category : 'adding' }
OPBPMNSemanticNodeModel >> addFlow: aFlow [
	(flows includes: aFlow)
		ifTrue: [ ^ self ].
	flows add: aFlow.
	aFlow source = self
		ifTrue: [ 
			aFlow addedTo: self.
			self announceAdded: aFlow ]
		ifFalse: [ self changed ]
]

{ #category : 'accessing' }
OPBPMNSemanticNodeModel >> allElements [

	^ super allElements
	  , (self flows flatCollect: [ :each | each withAllElements ])
]

{ #category : 'accessing' }
OPBPMNSemanticNodeModel >> defaultType [
	^ OPBPMNNodeType None
]

{ #category : 'accessing' }
OPBPMNSemanticNodeModel >> edges [

	^ super edges , self flows
]

{ #category : 'accessing' }
OPBPMNSemanticNodeModel >> executableAttribute [

	^ executableAttribute ifNil: [ '' ]
]

{ #category : 'accessing' }
OPBPMNSemanticNodeModel >> executableAttribute: anAttribute [
	executableAttribute := anAttribute
]

{ #category : 'accessing' }
OPBPMNSemanticNodeModel >> executableAttributeValue [

	^ executableAttributeValue ifNil: [ '' ]
]

{ #category : 'accessing' }
OPBPMNSemanticNodeModel >> executableAttributeValue: anAttribute [
	executableAttributeValue := anAttribute
]

{ #category : 'accessing' }
OPBPMNSemanticNodeModel >> flows [
	^ flows
]

{ #category : 'testing' }
OPBPMNSemanticNodeModel >> has: anElement [

	^ (super has: anElement) or: [ flows includes: anElement ]
]

{ #category : 'accessing' }
OPBPMNSemanticNodeModel >> incoming [

	^ super incoming , (flows select: [ :each | each target = self ])
]

{ #category : 'initialization' }
OPBPMNSemanticNodeModel >> initialize [

	super initialize.
	type := self defaultType.
	flows := OrderedCollection new.
	executableAttributeValue := ''
]

{ #category : 'accessing' }
OPBPMNSemanticNodeModel >> outgoing [

	^ super outgoing , (flows select: [ :each | each source = self ])
]

{ #category : 'printing' }
OPBPMNSemanticNodeModel >> printIdType [
	^ '_6-'
]

{ #category : 'accessing' }
OPBPMNSemanticNodeModel >> relatedElements [
	^ (self incoming , self outgoing) asSet asOrderedCollection
]

{ #category : 'removing' }
OPBPMNSemanticNodeModel >> removeAllFlows [
	flows copy
		do: [ :each | 
			each source removeFlow: each.
			each target removeFlow: each ]
]

{ #category : 'removing' }
OPBPMNSemanticNodeModel >> removeFlow: aFlow [

	flows remove: aFlow.
	self announceRemoved: aFlow
]

{ #category : 'removing' }
OPBPMNSemanticNodeModel >> removedFrom: aDiagram [
	self
		removedFrom: aDiagram
		do: [ self incoming do: [ :each | aDiagram remove: each ].
			self outgoing do: [ :each | aDiagram remove: each ] ]
]

{ #category : 'accessing' }
OPBPMNSemanticNodeModel >> type [
	^ type
]

{ #category : 'accessing' }
OPBPMNSemanticNodeModel >> type: aParticipantType [
	type := aParticipantType.
	self changed
]
