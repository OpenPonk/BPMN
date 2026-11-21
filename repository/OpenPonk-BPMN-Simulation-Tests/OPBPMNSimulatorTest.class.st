"
Unit tests for OPBPMNSimulator.
Verifies diagram-level simulation stepping, state management, and overall execution flow logic.
"
Class {
	#name : 'OPBPMNSimulatorTest',
	#superclass : 'TestCase',
	#instVars : [
		'simulator'
	],
	#category : 'OpenPonk-BPMN-Simulation-Tests-Simulation',
	#package : 'OpenPonk-BPMN-Simulation-Tests',
	#tag : 'Simulation'
}

{ #category : 'running' }
OPBPMNSimulatorTest >> exampleModel [

	| model activity1 flow1 flow2 start1 end1 |
	model := OPBPMNModel new name: 'BPMN Diagram'.
	start1 := OPBPMNStartEventModel new
		          name: 'S1';
		          yourself.
	end1 := OPBPMNEndEventModel new
		        name: 'E1';
		        yourself.
	activity1 := OPBPMNActivityModel new
		             name: 'A1';
		             yourself.
	model
		add: start1;
		add: end1;
		add: activity1.
	flow1 := OPBPMNFlowModel from: start1 to: activity1.
	flow2 := OPBPMNFlowModel from: activity1 to: end1.
	model
		add: flow1;
		add: flow2.
	^ model
]

{ #category : 'running' }
OPBPMNSimulatorTest >> setUp [

	super setUp.

	simulator := self simulatorClass model: self exampleModel
]

{ #category : 'running' }
OPBPMNSimulatorTest >> simulatorClass [

	^ OPBPMNSimulator
]

{ #category : 'tests' }
OPBPMNSimulatorTest >> testConfigurableGatewaysExcludesParallelGateways [

	| testModel exclusiveGateway inclusiveGateway parallelGateway diagramSimulator |
	testModel := OPBPMNModel new name: 'Gateways'.
	exclusiveGateway := OPBPMNGatewayModel new
		                    type: OPBPMNNodeType Exclusive;
		                    yourself.
	inclusiveGateway := OPBPMNGatewayModel new
		                    type: OPBPMNNodeType Inclusive;
		                    yourself.
	parallelGateway := OPBPMNGatewayModel new
		                   type: OPBPMNNodeType Parallel;
		                   yourself.
	testModel
		add: exclusiveGateway;
		add: inclusiveGateway;
		add: parallelGateway.

	diagramSimulator := self simulatorClass model: testModel.
	self assertCollection: (diagramSimulator configurableGateways collect: #model) hasSameElements: {
			exclusiveGateway.
			inclusiveGateway }
]

{ #category : 'tests' }
OPBPMNSimulatorTest >> testDefaultStepping [

	| items stepped didAction |
	simulator setDefaultStepping.

	items := simulator itemsForAction.
	self assert: items size equals: 2.
	items do: [ :each |
			self assert: each isSimulable description: 'Default stepping item must be simulable'.
			self assert: each isSteppable description: 'Default stepping item must be steppable' ].
	self assert: (items collect: #class as: Array) equals: {
			OPBPMNStartEventSimulator.
			OPBPMNSequenceFlowSimulator }.

	stepped := OrderedCollection new.
	didAction := OrderedCollection new.
	simulator simulableElementsDo: [ :each |
			each when: OPSimulatorStepped do: [ :event | stepped add: event ] for: self.
			each when: OPSimulatorDidAction do: [ :event | didAction add: event ] for: self ].
	simulator step.
	self assert: stepped size equals: 2.
	self assert: didAction size equals: 2
]

{ #category : 'tests' }
OPBPMNSimulatorTest >> testExampleAllElementsAndTypesLoadsWithoutError [

	| exampleModel diagramSimulator |
	exampleModel := OPBPMNExamples exampleAllElementsAndTypes.
	diagramSimulator := self simulatorClass model: exampleModel.
	self denyEmpty: diagramSimulator elements
]

{ #category : 'tests' }
OPBPMNSimulatorTest >> testInitialClassMappingContainsAllSupportedBPMNModels [

	| mapping |
	mapping := OPBPMNSimulator initialClassMapping.
	self assert: (mapping at: OPBPMNDataFlowModel) identicalTo: OPBPMNDataFlowSimulator.
	self assert: (mapping at: OPBPMNFlowModel) identicalTo: OPBPMNSequenceFlowSimulator.
	self assert: (mapping at: OPBPMNMessageFlowModel) identicalTo: OPBPMNMessageFlowSimulator.
	self assert: (mapping at: OPBPMNBoundaryEventModel) identicalTo: OPBPMNBoundaryEventSimulator.
	self assert: (mapping at: OPBPMNDataObjectModel) identicalTo: OPBPMNDataObjectSimulator.
	self assert: (mapping at: OPBPMNActivityModel) identicalTo: OPBPMNActivitySimulator.
	self assert: (mapping at: OPBPMNCollapsedSubProcessModel) identicalTo: OPBPMNCollapsedSubProcessSimulator.
	self assert: (mapping at: OPBPMNEndEventModel) identicalTo: OPBPMNEndEventSimulator.
	self assert: (mapping at: OPBPMNIntermediateEventModel) identicalTo: OPBPMNIntermediateEventSimulator.
	self assert: (mapping at: OPBPMNStartEventModel) identicalTo: OPBPMNStartEventSimulator.
	self assert: (mapping at: OPBPMNGatewayModel) identicalTo: OPBPMNGatewaySimulator.
	self assert: (mapping at: OPBPMNSubProcessModel) identicalTo: OPBPMNSubProcessSimulator.
	self assert: (mapping at: OPBPMNPoolModel) identicalTo: OPBPMNPoolSimulator
]

{ #category : 'tests' }
OPBPMNSimulatorTest >> testOrderFulfillmentExampleStartEventIsSteppable [

	| exampleModel sim startEvent startSim |
	exampleModel := OPBPMNExamples exampleOrderFulfillment.
	startEvent := exampleModel allElements detect: [ :each |
		              (each isKindOf: OPBPMNStartEventModel) and: [ each name = 'Order Placed' ] ].

	sim := self simulatorClass model: exampleModel.
	sim setDefaultStepping.

	startSim := sim simulatorOf: startEvent.
	self assert: startSim bpmnTokens equals: 1.
	self assert: startSim isSteppable description: 'Order Placed start event must be steppable with initial token'.

	sim step.
	self assert: startSim bpmnTokens equals: 0
]

{ #category : 'tests' }
OPBPMNSimulatorTest >> testSimulationWithAssociation [

	| testModel activity end association diagramSimulator |
	testModel := self exampleModel.
	activity := testModel elements detect: [ :each | each name = 'A1' ].
	end := testModel elements detect: [ :each | each name = 'E1' ].
	association := OPBPMNAssociationModel new.
	association
		source: activity;
		target: end.
	testModel add: association.

	diagramSimulator := self simulatorClass model: testModel.
	self assert: diagramSimulator elements size equals: 5.
	self
		deny: (diagramSimulator elements anySatisfy: [ :each | each model == association ])
		description: 'Non-simulable associations must be excluded from diagram simulator elements'
]

{ #category : 'tests' }
OPBPMNSimulatorTest >> testStartEventInLaneReceivesInitialTokenAndIsSteppable [

	| testModel pool lane start task flow sim startSim |
	testModel := OPBPMNModel new name: 'Process Model'.
	pool := OPBPMNPoolModel new name: 'Pool'.
	lane := OPBPMNLaneModel new name: 'Lane'.
	pool addLane: lane.
	testModel add: pool.

	start := OPBPMNStartEventModel new
		         name: 'Start';
		         type: OPBPMNNodeType Receive;
		         yourself.
	task := OPBPMNActivityModel new name: 'Task'.
	flow := (OPBPMNFlowModel from: start to: task)
		        name: 'Flow';
		        yourself.
	start addFlow: flow.
	task addFlow: flow.

	lane
		add: start;
		add: task.
	testModel add: flow.

	sim := self simulatorClass model: testModel.
	sim setDefaultStepping.

	startSim := sim simulatorOf: start.
	self assert: startSim bpmnTokens equals: 1.
	self assert: startSim isSteppable description: 'Start event inside a lane must be steppable with initial token'.

	sim step.
	self assert: startSim bpmnTokens equals: 0.
	self assert: (sim simulatorOf: task) bpmnTokens equals: 1
]
