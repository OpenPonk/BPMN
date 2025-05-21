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
	self incomingBpmnTokens
		at: aFlow
		update: [ :value | value + anInteger ].

	(self incomingBpmnTokens values allSatisfy: [ :each | each positive ])
		ifFalse: [ ^ self ].

	tokenAmount := self incomingBpmnTokens values min.
	self bpmnTokens: self bpmnTokens + tokenAmount.
	self incomingBpmnTokens keysDo: [ :key |
		self incomingBpmnTokens
			at: key
			update: [ :value | value - tokenAmount ] ]
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
	model incoming do: [ :flow |
		self incomingBpmnTokens
			at: (diagramSimulator simulatorOf: flow)
			put: 0 ]
]
