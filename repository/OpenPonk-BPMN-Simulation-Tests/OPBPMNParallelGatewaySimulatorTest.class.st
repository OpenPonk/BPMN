"
Unit tests for OPBPMNParallelGatewaySimulator.
Verifies strict synchronization of all incoming branches and concurrent splitting to all outgoing branches.
"
Class {
	#name : 'OPBPMNParallelGatewaySimulatorTest',
	#superclass : 'OPBPMNGatewaySimulatorTest',
	#category : 'OpenPonk-BPMN-Simulation-Tests-Simulation',
	#package : 'OpenPonk-BPMN-Simulation-Tests',
	#tag : 'Simulation'
}

{ #category : 'running' }
OPBPMNParallelGatewaySimulatorTest >> setUp [

	super setUp.
	model type: OPBPMNNodeType Parallel.
	simulator incomingBpmnTokens: (Dictionary new
			 at: flowIn1 put: 0;
			 at: flowIn2 put: 0;
			 yourself)
]

{ #category : 'accessing' }
OPBPMNParallelGatewaySimulatorTest >> simulatorClass [

	^ OPBPMNParallelGatewaySimulator 
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
OPBPMNParallelGatewaySimulatorTest >> testAddBpmnTokensFromDoesNotReassignTokensWhenBranchIsEmpty [

	simulator stub bpmnTokens: Any.
	simulator addBpmnTokens: 3 from: flowIn1.
	simulator should not receive bpmnTokens: Any.
	self assert: (simulator incomingBpmnTokens at: flowIn1) equals: 3.
	self assert: (simulator incomingBpmnTokens at: flowIn2) equals: 0
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

{ #category : 'tests' }
OPBPMNParallelGatewaySimulatorTest >> testIsConfigurableReturnsFalse [

	self deny: simulator isConfigurable description: 'Parallel gateways are not user-configurable'
]

{ #category : 'tests' }
OPBPMNParallelGatewaySimulatorTest >> testLoadConnectedItemsIgnoresIncomingAssociation [

	| testModel gateway start annotation sequenceFlow association diagramSimulator gatewaySimulator |
	testModel := OPBPMNModel new name: 'Parallel With Association'.
	start := OPBPMNStartEventModel new name: 'Start'.
	gateway := OPBPMNGatewayModel new
		           name: 'AND';
		           type: OPBPMNNodeType Parallel;
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
