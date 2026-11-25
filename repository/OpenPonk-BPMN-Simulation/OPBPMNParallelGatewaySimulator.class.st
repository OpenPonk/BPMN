"
Simulator component for BPMN parallel (AND) gateways.
Synchronizes all incoming sequence flows, waiting for tokens on each, before splitting the token concurrently to all outgoing sequence flows.
"
Class {
	#name : 'OPBPMNParallelGatewaySimulator',
	#superclass : 'OPBPMNGatewaySimulator',
	#instVars : [
		'incomingBpmnTokens'
	],
	#category : 'OpenPonk-BPMN-Simulation-Simulation',
	#package : 'OpenPonk-BPMN-Simulation',
	#tag : 'Simulation'
}

{ #category : 'adding' }
OPBPMNParallelGatewaySimulator >> addBpmnTokens: anInteger from: aFlow [

	| tokenAmount |
	self incomingBpmnTokens at: aFlow update: [ :value | value + anInteger ].

	(self incomingBpmnTokens values allSatisfy: [ :each | each strictlyPositive ]) ifFalse: [ ^ self ].

	tokenAmount := self incomingBpmnTokens values min.
	self bpmnTokens: self bpmnTokens + tokenAmount.
	self incomingBpmnTokens keysDo: [ :key | self incomingBpmnTokens at: key update: [ :value | value - tokenAmount ] ]
]

{ #category : 'accessing' }
OPBPMNParallelGatewaySimulator >> incomingBpmnTokens [

	^ incomingBpmnTokens
]

{ #category : 'accessing' }
OPBPMNParallelGatewaySimulator >> incomingBpmnTokens: aDictionary [

	incomingBpmnTokens := aDictionary
]

{ #category : 'initialization' }
OPBPMNParallelGatewaySimulator >> initialize [

	super initialize.
	incomingBpmnTokens := Dictionary new
]

{ #category : 'testing' }
OPBPMNParallelGatewaySimulator >> isConfigurable [

	^ false
]

{ #category : 'creation' }
OPBPMNParallelGatewaySimulator >> loadConnectedItems [

	super loadConnectedItems.
	model incoming
		select: [ :flow | diagramSimulator class hasSimulatorFor: flow ]
		thenDo: [ :flow | self incomingBpmnTokens at: (diagramSimulator simulatorOf: flow) put: 0 ]
]

{ #category : 'actions' }
OPBPMNParallelGatewaySimulator >> loadState [

	super loadState.
	incomingBpmnTokens keysDo: [ :eachFlow | incomingBpmnTokens at: eachFlow put: 0 ]
]
