"
Unit tests for OPBPMNEndEventSimulator.
Verifies token consumption and process termination behavior at end events.
"
Class {
	#name : 'OPBPMNEndEventSimulatorTest',
	#superclass : 'OPBPMNNodeSimulatorTest',
	#category : 'OpenPonk-BPMN-Simulation-Tests-Simulation',
	#package : 'OpenPonk-BPMN-Simulation-Tests',
	#tag : 'Simulation'
}

{ #category : 'accessing' }
OPBPMNEndEventSimulatorTest >> exampleModel [

	^ OPBPMNEndEventModel new
]

{ #category : 'accessing' }
OPBPMNEndEventSimulatorTest >> simulatorClass [

	^ OPBPMNEndEventSimulator
]

{ #category : 'tests' }
OPBPMNEndEventSimulatorTest >> testFire [

	model type: OPBPMNNodeType None.
	simulator addBpmnTokens: 3 from: flowIn1.
	self assert: simulator bpmnTokens equals: 3.
	self assert: flowOut1 bpmnTokens equals: 0.
	simulator fire.
	self assert: simulator bpmnTokens equals: 0.
	self assert: flowOut1 bpmnTokens equals: 0
]

{ #category : 'tests' }
OPBPMNEndEventSimulatorTest >> testFireTerminateClearsAllDiagramSimulatorTokens [

	| testModel start task end flow1 flow2 diagramSimulator |
	testModel := OPBPMNModel new name: 'Terminate Model'.
	start := OPBPMNStartEventModel new name: 'Start'.
	task := OPBPMNActivityModel new name: 'Task'.
	end := OPBPMNEndEventModel new
		       name: 'TerminateEnd';
		       type: OPBPMNNodeType Terminate;
		       yourself.
	flow1 := OPBPMNFlowModel from: start to: task.
	flow2 := OPBPMNFlowModel from: task to: end.
	start addFlow: flow1.
	task
		addFlow: flow1;
		addFlow: flow2.
	end addFlow: flow2.
	testModel
		add: start;
		add: task;
		add: end;
		add: flow1;
		add: flow2.

	diagramSimulator := OPBPMNSimulator model: testModel.
	(diagramSimulator simulatorOf: task) bpmnTokens: 5.
	(diagramSimulator simulatorOf: end) bpmnTokens: 1.

	(diagramSimulator simulatorOf: end) fire.
	diagramSimulator elementsDo: [ :each | self assert: each bpmnTokens equals: 0 ]
]
