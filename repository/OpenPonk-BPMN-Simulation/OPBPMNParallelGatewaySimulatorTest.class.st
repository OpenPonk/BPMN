"
Unit tests for OPBPMNParallelGatewaySimulator.
Verifies strict synchronization of all incoming branches and concurrent splitting to all outgoing branches.
"
Class {
	#name : 'OPBPMNParallelGatewaySimulatorTest',
	#superclass : 'OPBPMNGatewaySimulatorTest',
	#category : 'OpenPonk-BPMN-Simulation-Tests',
	#package : 'OpenPonk-BPMN-Simulation',
	#tag : 'Tests'
}

{ #category : 'accessing' }
OPBPMNParallelGatewaySimulatorTest >> controllerClass [

	^ OPBPMNParallelGatewaySimulator 
]

{ #category : 'running' }
OPBPMNParallelGatewaySimulatorTest >> setUp [

	super setUp.
	model type: OPBPMNNodeType Parallel.
	simulator incomingBpmnTokens: (Dictionary new
			 at: flowIn1 put: 0;
			 at: flowIn2 put: 0;
			 yourself)
]

{ #category : 'tests' }
OPBPMNParallelGatewaySimulatorTest >> testAddBpmnTokensFrom [

	self assert: simulator incomingBpmnTokens size equals: 2.
	self assert: simulator incomingBpmnTokens values max equals: 0.
	self assert: simulator bpmnTokens equals: 1.
	simulator addBpmnTokens: 3 from: flowIn1.
	self assert: (simulator incomingBpmnTokens at: flowIn1) equals: 3.
	self assert: simulator bpmnTokens equals: 1.
	simulator addBpmnTokens: 10 from: flowIn2.
	self assert: simulator bpmnTokens equals: 4.
	self assert: (simulator incomingBpmnTokens at: flowIn2) equals: 7.
	self assert: (simulator incomingBpmnTokens at: flowIn1) equals: 0
]

{ #category : 'tests' }
OPBPMNParallelGatewaySimulatorTest >> testFire [

	self assert: simulator bpmnTokens equals: 1.
	self assert: simulator outgoing size equals: 2.
	simulator outgoingDo: [ :each |
		self assert: each bpmnTokens equals: 0 ].
	simulator fire.
	self assert: simulator bpmnTokens equals: 0.
	simulator outgoingDo: [ :each |
		self assert: each bpmnTokens equals: 1 ]
]
