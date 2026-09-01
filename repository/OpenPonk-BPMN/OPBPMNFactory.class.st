"
I am a deprecated utility factory used to construct, manipulate, and manage specific BPMN flows and model transitions between nodes within the diagram.
"
Class {
	#name : 'OPBPMNFactory',
	#superclass : 'Object',
	#category : 'OpenPonk-BPMN-Factory',
	#package : 'OpenPonk-BPMN',
	#tag : 'Factory'
}

{ #category : 'adding' }
OPBPMNFactory class >> addFqnFlows: aCollection in: aParticipant [
	aCollection do: [ :pair | self fqnFlowFrom: pair key to: pair value in: aParticipant ]
]

{ #category : 'moving' }
OPBPMNFactory class >> detachFLowsFrom: aDiagram [
	aDiagram elements removeAll
]

{ #category : 'adding' }
OPBPMNFactory class >> flowFrom: fromNode to: toNode [
	| flow |
	flow := OPBPMNAbstractFlowModel from: fromNode to: toNode.
	fromNode addFlow: flow.
	toNode addFlow: flow.
	^ flow
]

{ #category : 'adding' }
OPBPMNFactory class >> fqnFlowFrom: fromName to: toName in: aParticipant [
	^ self flowFrom: aParticipant @ fromName to: aParticipant @ toName
]

{ #category : 'testing' }
OPBPMNFactory class >> isDeprecated [
	"currently unused, untested"

	^ true
]

{ #category : 'moving' }
OPBPMNFactory class >> moveFlowsFrom: aSourceDiagram to: aTargetDiagram [
	aTargetDiagram removeAll.
	"detach elements from old diagram without causing a cascade"
	aSourceDiagram elements do: [ :each | each announcer unsubscribe: aSourceDiagram ].
	aSourceDiagram elements do: [ :each | aTargetDiagram add: each ].
	aSourceDiagram elements removeAll
]
