"
Simulator component for BPMN exclusive (XOR) gateways.
Evaluates conditions to route tokens through exactly one outgoing sequence flow.
"
Class {
	#name : 'OPBPMNExclusiveGatewaySimulator',
	#superclass : 'OPBPMNGatewaySimulator',
	#category : 'OpenPonk-BPMN-Simulation-Simulation',
	#package : 'OpenPonk-BPMN-Simulation',
	#tag : 'Simulation'
}

{ #category : 'actions' }
OPBPMNExclusiveGatewaySimulator >> fire [

	self canSendBpmnTokens ifFalse: [ ^ self ].
	self outgoingActive first addBpmnTokens: self bpmnTokens.
	self bpmnTokens: 0
]
