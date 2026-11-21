"
Unit tests for OPBPMNExclusiveGatewaySimulator.
Verifies that tokens are correctly routed through exactly one active outgoing branch based on conditions.
"
Class {
	#name : 'OPBPMNExclusiveGatewaySimulatorTest',
	#superclass : 'OPBPMNGatewaySimulatorTest',
	#category : 'OpenPonk-BPMN-Simulation-Tests-Simulation',
	#package : 'OpenPonk-BPMN-Simulation-Tests',
	#tag : 'Simulation'
}

{ #category : 'running' }
OPBPMNExclusiveGatewaySimulatorTest >> setUp [

	super setUp.
	model type: OPBPMNNodeType Exclusive
]

{ #category : 'accessing' }
OPBPMNExclusiveGatewaySimulatorTest >> simulatorClass [

	^ OPBPMNExclusiveGatewaySimulator
]

{ #category : 'tests' }
OPBPMNExclusiveGatewaySimulatorTest >> testFactoryCreatesSimulatorForEachGatewayType [

	| diagramSimulator |
	diagramSimulator := OPBPMNSimulator model: OPBPMNModel new.
	self
		assert: (OPBPMNGatewaySimulator
				 model: (OPBPMNGatewayModel new
						  type: OPBPMNNodeType Parallel;
						  yourself)
				 diagramSimulator: diagramSimulator) class
		identicalTo: OPBPMNParallelGatewaySimulator.
	self
		assert: (OPBPMNGatewaySimulator
				 model: (OPBPMNGatewayModel new
						  type: OPBPMNNodeType Inclusive;
						  yourself)
				 diagramSimulator: diagramSimulator) class
		identicalTo: OPBPMNInclusiveGatewaySimulator.
	self
		assert: (OPBPMNGatewaySimulator
				 model: (OPBPMNGatewayModel new
						  type: OPBPMNNodeType Complex;
						  yourself)
				 diagramSimulator: diagramSimulator) class
		identicalTo: OPBPMNInclusiveGatewaySimulator.
	self
		assert: (OPBPMNGatewaySimulator
				 model: (OPBPMNGatewayModel new
						  type: OPBPMNNodeType ExclusiveEmpty;
						  yourself)
				 diagramSimulator: diagramSimulator) class
		identicalTo: OPBPMNExclusiveGatewaySimulator.
	self
		assert: (OPBPMNGatewaySimulator
				 model: (OPBPMNGatewayModel new
						  type: OPBPMNNodeType Exclusive;
						  yourself)
				 diagramSimulator: diagramSimulator) class
		identicalTo: OPBPMNExclusiveGatewaySimulator.
	self
		assert: (OPBPMNGatewaySimulator
				 model: (OPBPMNGatewayModel new
						  type: OPBPMNNodeType Eventbased;
						  yourself)
				 diagramSimulator: diagramSimulator) class
		identicalTo: OPBPMNExclusiveGatewaySimulator.
	self
		should: [
				OPBPMNGatewaySimulator
					model: (OPBPMNGatewayModel new
							 type: OPBPMNNodeType None;
							 yourself)
					diagramSimulator: diagramSimulator ]
		raise: AssertionFailure
]

{ #category : 'tests' }
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

{ #category : 'tests' }
OPBPMNExclusiveGatewaySimulatorTest >> testFireDoesNothingWhenOutgoingActiveIsEmpty [

	simulator outgoingActive: OrderedCollection new.
	simulator fire.
	self assert: simulator bpmnTokens equals: 1.
	self assert: flowOut1 bpmnTokens equals: 0.
	self assert: flowOut2 bpmnTokens equals: 0
]

{ #category : 'tests' }
OPBPMNExclusiveGatewaySimulatorTest >> testLoadConnectedItemsIgnoresOutgoingAssociation [

	| testModel gateway task annotation sequenceFlow association diagramSimulator gatewaySimulator |
	testModel := OPBPMNModel new name: 'Gateway With Association'.
	gateway := OPBPMNGatewayModel new
		           name: 'XOR';
		           type: OPBPMNNodeType Exclusive;
		           yourself.
	task := OPBPMNActivityModel new name: 'Task'.
	annotation := OPBPMNAnnotationModel new name: 'Note'.
	sequenceFlow := OPBPMNFlowModel from: gateway to: task.
	association := OPBPMNAssociationModel new
		               source: gateway;
		               target: annotation;
		               yourself.
	gateway
		addAssociation: association;
		addFlow: sequenceFlow.
	task addFlow: sequenceFlow.
	testModel
		add: gateway;
		add: task;
		add: annotation;
		add: sequenceFlow;
		add: association.

	diagramSimulator := OPBPMNSimulator model: testModel.
	gatewaySimulator := diagramSimulator simulatorOf: gateway.
	self assert: gatewaySimulator outgoingActive size equals: 1.
	self assert: gatewaySimulator outgoingActive first model identicalTo: sequenceFlow
]

{ #category : 'tests' }
OPBPMNExclusiveGatewaySimulatorTest >> testLoadConnectedItemsSelectsDefaultFlowOrFirstOrEmpty [

	| testModel emptyGateway defaultGateway normalGateway task1 task2 task3 task4 flow1 flow2 flow3 flow4 diagramSimulator |
	testModel := OPBPMNModel new name: 'Gateway Outgoing Modes'.
	emptyGateway := OPBPMNGatewayModel new
		                type: OPBPMNNodeType Exclusive;
		                yourself.
	defaultGateway := OPBPMNGatewayModel new
		                  type: OPBPMNNodeType Exclusive;
		                  yourself.
	normalGateway := OPBPMNGatewayModel new
		                 type: OPBPMNNodeType Exclusive;
		                 yourself.
	task1 := OPBPMNActivityModel new name: 'T1'.
	task2 := OPBPMNActivityModel new name: 'T2'.
	task3 := OPBPMNActivityModel new name: 'T3'.
	task4 := OPBPMNActivityModel new name: 'T4'.
	flow1 := OPBPMNFlowModel from: defaultGateway to: task1.
	flow2 := (OPBPMNFlowModel from: defaultGateway to: task2)
		         type: #Default;
		         yourself.
	flow3 := OPBPMNFlowModel from: normalGateway to: task3.
	flow4 := OPBPMNFlowModel from: normalGateway to: task4.
	defaultGateway
		addFlow: flow1;
		addFlow: flow2.
	normalGateway
		addFlow: flow3;
		addFlow: flow4.
	task1 addFlow: flow1.
	task2 addFlow: flow2.
	task3 addFlow: flow3.
	task4 addFlow: flow4.
	testModel
		add: emptyGateway;
		add: defaultGateway;
		add: normalGateway;
		add: task1;
		add: task2;
		add: task3;
		add: task4;
		add: flow1;
		add: flow2;
		add: flow3;
		add: flow4.

	diagramSimulator := OPBPMNSimulator model: testModel.
	self assertEmpty: (diagramSimulator simulatorOf: emptyGateway) outgoingActive.
	self assert: (diagramSimulator simulatorOf: defaultGateway) outgoingActive size equals: 1.
	self assert: (diagramSimulator simulatorOf: defaultGateway) outgoingActive first model identicalTo: flow2.
	self assert: (diagramSimulator simulatorOf: normalGateway) outgoingActive size equals: 1.
	self assert: (diagramSimulator simulatorOf: normalGateway) outgoingActive first model identicalTo: flow3
]
