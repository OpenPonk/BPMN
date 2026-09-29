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
	| flowNodesToMigrate |
	flowNodesToMigrate := (self elements select: [ :eachChildElement |
		eachChildElement isKindOf: OPBPMNFlowNodeModel ]) copy.
	self add: aLaneModel.
	flowNodesToMigrate do: [ :eachFlowNode |
		self remove: eachFlowNode.
		aLaneModel add: eachFlowNode ].
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

{ #category : 'removing' }
OPBPMNPoolModel >> removeAllNodes [
	self removeAll
]

{ #category : 'accessing' }
OPBPMNPoolModel >> removeLane: aLaneModel [
	| containedFlowNodes |
	containedFlowNodes := aLaneModel flowNodes copy.
	self remove: aLaneModel.
	self hasLanes ifFalse: [
		containedFlowNodes do: [ :eachFlowNode |
			aLaneModel remove: eachFlowNode.
			self add: eachFlowNode ] ].
	^ aLaneModel
]

{ #category : 'accessing' }
OPBPMNPoolModel >> removeNode: aNode [
	elements remove: aNode
]
