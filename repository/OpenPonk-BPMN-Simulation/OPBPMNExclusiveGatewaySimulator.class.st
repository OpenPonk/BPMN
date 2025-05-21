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
