"
Unit tests for OPBPMNInclusiveGatewaySimulator.
Verifies proper token synchronization and multi-branch routing execution logic.
"
Class {
	#name : 'OPBPMNInclusiveGatewaySimulatorTest',
	#superclass : 'OPBPMNGatewaySimulatorTest',
	#category : 'OpenPonk-BPMN-Simulation-Tests-Simulation',
	#package : 'OpenPonk-BPMN-Simulation-Tests',
	#tag : 'Simulation'
}

{ #category : 'running' }
OPBPMNInclusiveGatewaySimulatorTest >> setUp [

	super setUp.
	model type: OPBPMNNodeType Inclusive.
	simulator incomingBpmnTokens: (Dictionary new
			 at: flowIn1 put: 0;
			 at: flowIn2 put: 0;
			 yourself)
]

{ #category : 'accessing' }
OPBPMNInclusiveGatewaySimulatorTest >> simulatorClass [

	^ OPBPMNInclusiveGatewaySimulator
]

{ #category : 'tests' }
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

{ #category : 'tests' }
OPBPMNInclusiveGatewaySimulatorTest >> testAddBpmnTokensFromHandlesUpstreamCycleAndMergesWhenClear [

	| upstreamNodeA upstreamNodeB backFlow |
	upstreamNodeA := OPBPMNActivitySimulator model: OPBPMNActivityModel new.
	upstreamNodeB := OPBPMNActivitySimulator model: OPBPMNActivityModel new.
	backFlow := OPBPMNSequenceFlowSimulator model: OPBPMNFlowModel new.
	flowIn2 bpmnTokens: 0.
	flowIn2 source: upstreamNodeA.
	upstreamNodeA addedIncoming: backFlow.
	backFlow source: upstreamNodeB.
	upstreamNodeB addedIncoming: flowIn2.

	upstreamNodeB bpmnTokens: 1.
	simulator addBpmnTokens: 2 from: flowIn1.
	self assert: simulator bpmnTokens equals: 1.
	self assert: (simulator incomingBpmnTokens at: flowIn1) equals: 2.

	upstreamNodeB bpmnTokens: 0.
	simulator addBpmnTokens: 1 from: flowIn1.
	self assert: simulator bpmnTokens equals: 4.
	self assert: (simulator incomingBpmnTokens at: flowIn1) equals: 0
]

{ #category : 'tests' }
OPBPMNInclusiveGatewaySimulatorTest >> testAddBpmnTokensFromMergesDirectlyWhenAllIncomingArePositive [

	simulator incomingBpmnTokens at: flowIn2 put: 2.
	simulator addBpmnTokens: 5 from: flowIn1.
	self assert: simulator bpmnTokens equals: 3.
	self assert: (simulator incomingBpmnTokens at: flowIn1) equals: 3.
	self assert: (simulator incomingBpmnTokens at: flowIn2) equals: 0
]

{ #category : 'tests' }
OPBPMNInclusiveGatewaySimulatorTest >> testAddZeroTokensWithNoUpstreamTokensDoesNotFail [

	flowIn1 bpmnTokens: 0.
	flowIn2 bpmnTokens: 0.
	simulator addBpmnTokens: 0 from: flowIn1.
	self assert: simulator bpmnTokens equals: 1.
	self assert: (simulator incomingBpmnTokens at: flowIn1) equals: 0.
	self assert: (simulator incomingBpmnTokens at: flowIn2) equals: 0
]

{ #category : 'tests' }
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

{ #category : 'tests' }
OPBPMNInclusiveGatewaySimulatorTest >> testFireDoesNothingWhenOutgoingActiveIsEmpty [

	simulator outgoingActive: OrderedCollection new.
	simulator fire.
	self assert: simulator bpmnTokens equals: 1.
	self assert: flowOut1 bpmnTokens equals: 0.
	self assert: flowOut2 bpmnTokens equals: 0
]

{ #category : 'tests' }
OPBPMNInclusiveGatewaySimulatorTest >> testLoadConnectedItemsIgnoresIncomingAssociation [

	| testModel gateway start annotation sequenceFlow association diagramSimulator gatewaySimulator |
	testModel := OPBPMNModel new name: 'Inclusive With Association'.
	start := OPBPMNStartEventModel new name: 'Start'.
	gateway := OPBPMNGatewayModel new
		           name: 'OR';
		           type: OPBPMNNodeType Inclusive;
		           yourself.
	annotation := OPBPMNAnnotationModel new name: 'Note'.
	sequenceFlow := OPBPMNFlowModel from: start to: gateway.
	association := OPBPMNAssociationModel new
		               source: annotation;
		               target: gateway;
		               yourself.
	start addFlow: sequenceFlow.
	gateway
		addAssociation: association;
		addFlow: sequenceFlow.
	testModel
		add: start;
		add: gateway;
		add: annotation;
		add: sequenceFlow;
		add: association.

	diagramSimulator := OPBPMNSimulator model: testModel.
	gatewaySimulator := diagramSimulator simulatorOf: gateway.
	self assert: gatewaySimulator incomingBpmnTokens size equals: 1.
	self assert: (gatewaySimulator incomingBpmnTokens at: (diagramSimulator simulatorOf: sequenceFlow)) equals: 0
]
