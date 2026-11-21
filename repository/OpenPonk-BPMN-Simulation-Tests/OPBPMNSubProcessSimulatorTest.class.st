"
Unit tests for expanded BPMN subprocess simulation, verifying inner start and end event wiring, token forwarding, and tolerance for attached associations.
"
Class {
	#name : 'OPBPMNSubProcessSimulatorTest',
	#superclass : 'TestCase',
	#category : 'OpenPonk-BPMN-Simulation-Tests-Simulation',
	#package : 'OpenPonk-BPMN-Simulation-Tests',
	#tag : 'Simulation'
}

{ #category : 'tests' }
OPBPMNSubProcessSimulatorTest >> testAddBpmnTokensForwardsToInnerStartEventsAndEndEventPropagatesBack [

	| testModel subProcess innerStart innerEnd innerFlow diagramSimulator subProcessSimulator innerStartSimulator |
	testModel := OPBPMNModel new name: 'SubProcess Flow'.
	subProcess := OPBPMNSubProcessModel new name: 'SP'.
	innerStart := OPBPMNStartEventModel new name: 'InnerStart'.
	innerEnd := OPBPMNEndEventModel new name: 'InnerEnd'.
	innerFlow := OPBPMNFlowModel from: innerStart to: innerEnd.
	innerStart addFlow: innerFlow.
	innerEnd addFlow: innerFlow.
	subProcess
		add: innerStart;
		add: innerEnd;
		add: innerFlow.
	testModel add: subProcess.

	diagramSimulator := OPBPMNSimulator model: testModel.
	diagramSimulator setDefaultStepping.
	subProcessSimulator := diagramSimulator simulatorOf: subProcess.
	innerStartSimulator := diagramSimulator simulatorOf: innerStart.

	self assert: subProcessSimulator startEvents size equals: 1.
	self assert: innerStartSimulator bpmnTokens equals: 0.

	subProcessSimulator addBpmnTokens: 3 from: nil.
	self assert: innerStartSimulator bpmnTokens equals: 3.

	diagramSimulator step.
	self assert: (diagramSimulator simulatorOf: innerEnd) bpmnTokens equals: 3.

	diagramSimulator step.
	self assert: subProcessSimulator bpmnTokens equals: 3.
	self assert: (diagramSimulator simulatorOf: innerEnd) bpmnTokens equals: 0
]

{ #category : 'tests' }
OPBPMNSubProcessSimulatorTest >> testEmptySubProcessLoadsWithNoStartEvents [

	| testModel subProcess diagramSimulator subProcessSimulator |
	testModel := OPBPMNModel new name: 'Empty SubProcess'.
	subProcess := OPBPMNSubProcessModel new name: 'EmptySP'.
	testModel add: subProcess.

	diagramSimulator := OPBPMNSimulator model: testModel.
	subProcessSimulator := diagramSimulator simulatorOf: subProcess.
	self assertEmpty: subProcessSimulator startEvents
]

{ #category : 'tests' }
OPBPMNSubProcessSimulatorTest >> testLoadConnectedItemsIgnoresAttachedAssociation [

	| testModel subProcess innerStart innerEnd innerFlow annotation association diagramSimulator subProcessSimulator |
	testModel := OPBPMNModel new name: 'SubProcess With Association'.
	subProcess := OPBPMNSubProcessModel new name: 'SP'.
	innerStart := OPBPMNStartEventModel new name: 'InnerStart'.
	innerEnd := OPBPMNEndEventModel new name: 'InnerEnd'.
	innerFlow := OPBPMNFlowModel from: innerStart to: innerEnd.
	innerStart addFlow: innerFlow.
	innerEnd addFlow: innerFlow.
	subProcess
		add: innerStart;
		add: innerEnd;
		add: innerFlow.
	annotation := OPBPMNAnnotationModel new name: 'Note'.
	association := OPBPMNAssociationModel new
		               source: subProcess;
		               target: annotation;
		               yourself.
	subProcess addAssociation: association.
	testModel
		add: subProcess;
		add: annotation;
		add: association.

	diagramSimulator := OPBPMNSimulator model: testModel.
	subProcessSimulator := diagramSimulator simulatorOf: subProcess.
	self assert: subProcessSimulator startEvents size equals: 1.
	self assert: subProcessSimulator startEvents first model identicalTo: innerStart
]
