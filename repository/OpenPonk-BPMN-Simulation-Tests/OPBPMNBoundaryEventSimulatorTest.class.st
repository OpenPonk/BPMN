"
Unit tests for BPMN boundary event simulation, verifying event type mapping, interrupting and non-interrupting triggers, and resilience against unrelated model elements.
"
Class {
	#name : 'OPBPMNBoundaryEventSimulatorTest',
	#superclass : 'TestCase',
	#category : 'OpenPonk-BPMN-Simulation-Tests-Simulation',
	#package : 'OpenPonk-BPMN-Simulation-Tests',
	#tag : 'Simulation'
}

{ #category : 'tests' }
OPBPMNBoundaryEventSimulatorTest >> testInterruptingBoundaryEventCapturesTokensAndClearsSource [

	| model activity boundaryEvent throwEvent nextTask flow diagramSimulator boundarySimulator throwSimulator nextSimulator |
	model := OPBPMNModel new name: 'Interrupting Boundary Model'.
	activity := OPBPMNActivityModel new name: 'Task'.
	boundaryEvent := OPBPMNBoundaryEventModel new
		                 name: 'CatchEscalation';
		                 type: OPBPMNNodeType Escalation;
		                 isNonInterrupting: false;
		                 yourself.
	throwEvent := OPBPMNIntermediateEventModel new
		              name: 'ThrowEscalation';
		              type: OPBPMNNodeType EscalationThrow;
		              yourself.
	nextTask := OPBPMNActivityModel new name: 'AfterThrow'.
	flow := OPBPMNFlowModel from: throwEvent to: nextTask.
	throwEvent addFlow: flow.
	nextTask addFlow: flow.
	activity add: boundaryEvent.
	model
		add: activity;
		add: throwEvent;
		add: nextTask;
		add: flow.

	diagramSimulator := OPBPMNSimulator model: model.
	diagramSimulator setDefaultStepping.
	boundarySimulator := diagramSimulator simulatorOf: boundaryEvent.
	throwSimulator := diagramSimulator simulatorOf: throwEvent.
	nextSimulator := diagramSimulator simulatorOf: nextTask.

	throwSimulator bpmnTokens: 2.
	diagramSimulator step.
	self assert: boundarySimulator bpmnTokens equals: 2.
	self assert: throwSimulator bpmnTokens equals: 0.
	self assert: nextSimulator bpmnTokens equals: 0
]

{ #category : 'tests' }
OPBPMNBoundaryEventSimulatorTest >> testLoadConnectedItemsIgnoresElementsWithoutType [

	| model activity boundaryEvent annotation association simulator |
	model := OPBPMNModel new name: 'Boundary Model'.
	activity := OPBPMNActivityModel new name: 'Task'.
	boundaryEvent := OPBPMNBoundaryEventModel new
		                 name: 'Escalation';
		                 type: OPBPMNNodeType Escalation;
		                 yourself.
	annotation := OPBPMNAnnotationModel new name: 'Note'.
	association := OPBPMNAssociationModel new
		               source: activity;
		               target: annotation;
		               yourself.
	activity
		add: boundaryEvent;
		addAssociation: association.
	model
		add: activity;
		add: annotation;
		add: association.

	simulator := OPBPMNSimulator model: model.
	self assert: (simulator simulatorOf: boundaryEvent) class identicalTo: OPBPMNBoundaryEventSimulator
]

{ #category : 'tests' }
OPBPMNBoundaryEventSimulatorTest >> testLoadConnectedItemsIgnoresUnmappedEventType [

	| model activity boundaryEvent diagramSimulator |
	model := OPBPMNModel new name: 'Timer Boundary Model'.
	activity := OPBPMNActivityModel new name: 'Task'.
	boundaryEvent := OPBPMNBoundaryEventModel new
		                 name: 'Timer';
		                 type: OPBPMNNodeType Timer;
		                 yourself.
	activity add: boundaryEvent.
	model add: activity.

	diagramSimulator := OPBPMNSimulator model: model.
	self assert: (diagramSimulator simulatorOf: boundaryEvent) bpmnTokens equals: 0
]

{ #category : 'tests' }
OPBPMNBoundaryEventSimulatorTest >> testNonInterruptingBoundaryEventCapturesTokensAndPreservesSource [

	| model activity boundaryEvent throwEvent nextTask flow diagramSimulator boundarySimulator throwSimulator nextSimulator |
	model := OPBPMNModel new name: 'NonInterrupting Boundary Model'.
	activity := OPBPMNActivityModel new name: 'Task'.
	boundaryEvent := OPBPMNBoundaryEventModel new
		                 name: 'CatchSignal';
		                 type: OPBPMNNodeType Signal;
		                 isNonInterrupting: true;
		                 yourself.
	throwEvent := OPBPMNIntermediateEventModel new
		              name: 'ThrowSignal';
		              type: OPBPMNNodeType SignalThrow;
		              yourself.
	nextTask := OPBPMNActivityModel new name: 'AfterSignal'.
	flow := OPBPMNFlowModel from: throwEvent to: nextTask.
	throwEvent addFlow: flow.
	nextTask addFlow: flow.
	activity add: boundaryEvent.
	model
		add: activity;
		add: throwEvent;
		add: nextTask;
		add: flow.

	diagramSimulator := OPBPMNSimulator model: model.
	diagramSimulator setDefaultStepping.
	boundarySimulator := diagramSimulator simulatorOf: boundaryEvent.
	throwSimulator := diagramSimulator simulatorOf: throwEvent.
	nextSimulator := diagramSimulator simulatorOf: nextTask.

	throwSimulator bpmnTokens: 2.
	diagramSimulator step.
	self assert: boundarySimulator bpmnTokens equals: 2.
	self assert: nextSimulator bpmnTokens equals: 2
]
