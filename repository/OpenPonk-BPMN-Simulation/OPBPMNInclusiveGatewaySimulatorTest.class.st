Class {
	#name : 'OPBPMNInclusiveGatewaySimulatorTest',
	#superclass : 'OPBPMNGatewaySimulatorTest',
	#category : 'OpenPonk-BPMN-Simulation-Tests',
	#package : 'OpenPonk-BPMN-Simulation',
	#tag : 'Tests'
}

{ #category : 'accessing' }
OPBPMNInclusiveGatewaySimulatorTest >> controllerClass [

	^ OPBPMNInclusiveGatewaySimulator
]

{ #category : 'accessing' }
OPBPMNInclusiveGatewaySimulatorTest >> setUp [

	super setUp.
	model type: OPBPMNNodeType Inclusive.
	simulator incomingBpmnTokens: (Dictionary new
			 at: flowIn1 put: 0;
			 at: flowIn2 put: 0;
			 yourself)
]

{ #category : 'accessing' }
OPBPMNInclusiveGatewaySimulatorTest >> testAddBpmnTokensFrom [

	self assert: simulator incomingBpmnTokens size equals: 2.
	self assert: simulator incomingBpmnTokens values max equals: 0.
	self assert: simulator bpmnTokens equals: 1.
	flowIn2 bpmnTokens: 1.
	simulator addBpmnTokens: 3 from: flowIn1.
	self assert: (simulator incomingBpmnTokens at: flowIn1) equals: 3.
	self assert: simulator bpmnTokens equals: 1.
	flowIn2 bpmnTokens: 0.
	simulator addBpmnTokens: 10 from: flowIn2.
	self assert: simulator bpmnTokens equals: 4.
	self assert: (simulator incomingBpmnTokens at: flowIn2) equals: 7.
	self assert: (simulator incomingBpmnTokens at: flowIn1) equals: 0
]

{ #category : 'accessing' }
OPBPMNInclusiveGatewaySimulatorTest >> testFire [

	self assert: simulator bpmnTokens equals: 1.
	self assert: simulator outgoingActive size equals: 2.
	simulator outgoingActive do: [ :each |
		self assert: each bpmnTokens equals: 0 ].
	simulator fire.
	self assert: simulator bpmnTokens equals: 0.
	simulator outgoingActive do: [ :each |
		self assert: each bpmnTokens equals: 1 ]
]
