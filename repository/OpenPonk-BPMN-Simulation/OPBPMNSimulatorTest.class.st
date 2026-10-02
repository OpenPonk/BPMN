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
	#category : 'OpenPonk-BPMN-Simulation-Tests',
	#package : 'OpenPonk-BPMN-Simulation',
	#tag : 'Tests'
}

{ #category : 'running' }
OPBPMNSimulatorTest >> controllerClass [

	^ OPBPMNSimulator
]

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

	simulator := self controllerClass model: self exampleModel
]

{ #category : 'tests' }
OPBPMNSimulatorTest >> testDefaultStepping [

	| items stepped didAction |
	simulator setDefaultStepping.

	items := simulator itemsForAction.
	self assert: items size equals: 2.
	items do: [ :each |
		self assert: each isSimulable.
		self assert: each isSteppable ].
	self assert: (items first isKindOf: OPBPMNStartEventSimulator).
	self assert: (items second isKindOf: OPBPMNSequenceFlowSimulator).

	stepped := OrderedCollection new.
	didAction := OrderedCollection new.
	simulator simulableElementsDo: [ :each |
		each
			when: OPSimulatorStepped
			do: [ :event | stepped add: event ]
			for: self.
		each
			when: OPSimulatorDidAction
			do: [ :event | didAction add: event ]
			for: self ].
	simulator step.
	self assert: stepped size equals: 2.
	self assert: didAction size equals: 2
]

{ #category : 'tests' }
OPBPMNSimulatorTest >> testOrderFulfillmentExampleStartEventIsSteppable [
	| exampleModel sim startEvent startSim |
	exampleModel := OPBPMNExamples exampleOrderFulfillment.
	startEvent := exampleModel allElements detect: [ :each | each isKindOf: OPBPMNStartEventModel ].

	sim := self controllerClass model: exampleModel.
	sim setDefaultStepping.

	startSim := sim simulatorOf: startEvent.
	self assert: startSim bpmnTokens equals: 1.
	self assert: startSim isSteppable.

	sim step.
	self assert: startSim bpmnTokens equals: 0
]

{ #category : 'tests' }
OPBPMNSimulatorTest >> testSimulationWithAssociation [
	| testModel activity end association |
	testModel := self exampleModel.
	activity := testModel elements detect: [ :each | each name = 'A1' ].
	end := testModel elements detect: [ :each | each name = 'E1' ].
	association := OPBPMNAssociationModel new.
	association
		source: activity;
		target: end.
	testModel add: association.

	self controllerClass model: testModel
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

	lane add: start; add: task.
	testModel add: flow.

	sim := self controllerClass model: testModel.
	sim setDefaultStepping.

	startSim := sim simulatorOf: start.
	self assert: startSim bpmnTokens equals: 1.
	self assert: startSim isSteppable.

	sim step.
	self assert: startSim bpmnTokens equals: 0.
	self assert: (sim simulatorOf: task) bpmnTokens equals: 1
]
