Class {
	#name : #OPBPMNFactory,
	#superclass : #Object,
	#category : #'OpenPonk-BPMN-Factory'
}

{ #category : #adding }
OPBPMNFactory class >> addFqnFlows: aCollection in: aParticipant [
	aCollection do: [ :pair | self fqnFlowFrom: pair key to: pair value in: aParticipant ]
]

{ #category : #moving }
OPBPMNFactory class >> detachFLowsFrom: aDiagram [
	aDiagram elements removeAll
]

{ #category : #adding }
OPBPMNFactory class >> flowFrom: fromNode to: toNode [
	| flow |
	flow := OPBPMNEdgeModel from: fromNode to: toNode.
	fromNode addFlow: flow.
	toNode addFlow: flow.
	^ flow
]

{ #category : #adding }
OPBPMNFactory class >> fqnFlowFrom: fromName to: toName in: aParticipant [
	^ self flowFrom: aParticipant @ fromName to: aParticipant @ toName
]

{ #category : #moving }
OPBPMNFactory class >> moveFlowsFrom: aSourceDiagram to: aTargetDiagram [
	aTargetDiagram removeAll.
	"detach elements from old diagram without causing a cascade"
	aSourceDiagram elements do: [ :each | each announcer unsubscribe: aSourceDiagram ].
	aSourceDiagram elements do: [ :each | aTargetDiagram add: each ].
	aSourceDiagram elements removeAll
]
