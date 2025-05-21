Class {
	#name : 'OPBPMNExclusiveGatewaySimulatorTest',
	#superclass : 'OPBPMNGatewaySimulatorTest',
	#category : 'OpenPonk-BPMN-Simulation-Tests',
	#package : 'OpenPonk-BPMN-Simulation',
	#tag : 'Tests'
}

{ #category : 'accessing' }
OPBPMNExclusiveGatewaySimulatorTest >> controllerClass [

	^ OPBPMNExclusiveGatewaySimulator
]

{ #category : 'accessing' }
OPBPMNExclusiveGatewaySimulatorTest >> setUp [

	super setUp.
	model type: OPBPMNNodeType Exclusive
]

{ #category : 'accessing' }
OPBPMNExclusiveGatewaySimulatorTest >> testFire [

	self assert: simulator bpmnTokens equals: 1.
	self assert: simulator outgoingActive size equals: 2.
	self assert: simulator outgoingActive first bpmnTokens equals: 0.
	self assert: simulator outgoingActive second bpmnTokens equals: 0.
	simulator fire.
	self assert: simulator bpmnTokens equals: 0.
	self assert: simulator outgoingActive first bpmnTokens equals: 1.
	self assert: simulator outgoingActive second bpmnTokens equals: 0
]
