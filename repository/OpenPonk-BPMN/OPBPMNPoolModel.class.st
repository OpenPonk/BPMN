"
I represent a BPMN Pool. I serve as a participant container managing enclosed flow nodes, nested lanes, and lane naming metadata.
"
Class {
	#name : 'OPBPMNPoolModel',
	#superclass : 'OPBPMNSemanticNodeModel',
	#category : 'OpenPonk-BPMN-Models',
	#package : 'OpenPonk-BPMN',
	#tag : 'Models'
}

{ #category : 'accessing' }
OPBPMNPoolModel >> @ aName [
	^ self nodeNamed: aName
]

{ #category : 'accessing' }
OPBPMNPoolModel >> addLane: aLaneModel [

	| elementsToMigrate |
	elementsToMigrate := self elements reject: [ :eachChildElement | eachChildElement isKindOf: OPBPMNLaneModel ].
	self add: aLaneModel.
	elementsToMigrate do: [ :eachElement | self relocateChildElement: eachElement from: self to: aLaneModel ].
	^ aLaneModel
]

{ #category : 'adding' }
OPBPMNPoolModel >> addLane: aLaneModel after: aTargetLaneModel [
	(elements includes: aLaneModel) ifTrue: [ ^ aLaneModel ].
	aLaneModel addedTo: self.
	elements add: aLaneModel after: aTargetLaneModel.
	aLaneModel weakWhen: OPModelChanged send: #changed to: self.
	self announceAdded: aLaneModel.
	^ aLaneModel
]

{ #category : 'adding' }
OPBPMNPoolModel >> addLane: aLaneModel before: aTargetLaneModel [
	(elements includes: aLaneModel) ifTrue: [ ^ aLaneModel ].
	aLaneModel addedTo: self.
	elements add: aLaneModel before: aTargetLaneModel.
	aLaneModel weakWhen: OPModelChanged send: #changed to: self.
	self announceAdded: aLaneModel.
	^ aLaneModel
]

{ #category : 'updating' }
OPBPMNPoolModel >> changed [
	super changed.
	owner changed
]

{ #category : 'hooks' }
OPBPMNPoolModel >> enclosingPool [

	^ self
]

{ #category : 'accessing' }
OPBPMNPoolModel >> flowNodesInLanes [
	"Answers all flow nodes belonging to any lane in this pool."
	^ (self lanes flatCollect: [ :eachLane | eachLane flowNodes ]) asOrderedCollection
]

{ #category : 'testing' }
OPBPMNPoolModel >> hasLanes [
	"Answers whether this pool is partitioned into lanes."
	^ self lanes isNotEmpty
]

{ #category : 'testing' }
OPBPMNPoolModel >> isBlackBox [
	"Answers whether this pool is an unpartitioned black-box pool without internal process elements."
	^ self hasLanes not and: [
		elements noneSatisfy: [ :eachElement |
			(eachElement isKindOf: OPBPMNFlowNodeModel)
				or: [ eachElement isKindOf: OPBPMNDataObjectModel ] ] ]
]

{ #category : 'accessing' }
OPBPMNPoolModel >> laneFor: aNodeModel [
	"Answers the lane containing the given node, or nil if the node is directly in the pool or not found."
	^ self lanes detect: [ :eachLane | (eachLane has: aNodeModel) or: [ aNodeModel isInsideOf: eachLane ] ] ifNone: [ nil ]
]

{ #category : 'accessing' }
OPBPMNPoolModel >> laneNamed: aString [
	"Answers the lane matching the given name, or nil."
	^ self lanes detect: [ :eachLane | eachLane name = aString ] ifNone: [ nil ]
]

{ #category : 'accessing' }
OPBPMNPoolModel >> lanes [
	"Answers all lane models contained in this pool in hierarchical order."
	^ (self elements select: [ :eachElement | eachElement isKindOf: OPBPMNLaneModel ]) asOrderedCollection
]

{ #category : 'accessing' }
OPBPMNPoolModel >> lanesCount [
	"Answers the number of lanes in this pool."
	^ self lanes size
]

{ #category : 'accessing' }
OPBPMNPoolModel >> nodeNamed: aName [
	^ self elementNamed: aName
]

{ #category : 'printing' }
OPBPMNPoolModel >> printType [
	^ 'process'
]

{ #category : 'private' }
OPBPMNPoolModel >> relocateChildElement: aChildElement from: aSourceContainer to: aTargetContainer [
	aSourceContainer elements remove: aChildElement ifAbsent: [ ].
	aChildElement unsubscribe: aSourceContainer.
	aTargetContainer add: aChildElement
]

{ #category : 'removing' }
OPBPMNPoolModel >> removeAllNodes [
	self removeAll
]

{ #category : 'accessing' }
OPBPMNPoolModel >> removeLane: aLaneModel [
	| isRemovingLastLane containedElements |
	isRemovingLastLane := (self lanes copyWithout: aLaneModel) isEmpty.
	isRemovingLastLane ifTrue: [
		containedElements := aLaneModel elements copy.
		containedElements do: [ :eachElement |
			self relocateChildElement: eachElement from: aLaneModel to: self ] ].
	super remove: aLaneModel.
	^ aLaneModel
]

{ #category : 'accessing' }
OPBPMNPoolModel >> removeNode: aNode [
	elements remove: aNode
]
