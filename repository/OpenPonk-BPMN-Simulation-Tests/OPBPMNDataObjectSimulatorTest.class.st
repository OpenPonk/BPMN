"
Unit tests for BPMN data object and base node firing behavior, including token clearing and blocked or dead-end guards.
"
Class {
	#name : 'OPBPMNDataObjectSimulatorTest',
	#superclass : 'OPBPMNNodeSimulatorTest',
	#category : 'OpenPonk-BPMN-Simulation-Tests-Simulation',
	#package : 'OpenPonk-BPMN-Simulation-Tests',
	#tag : 'Simulation'
}

{ #category : 'accessing' }
OPBPMNDataObjectSimulatorTest >> exampleModel [

	^ OPBPMNDataObjectModel new
]

{ #category : 'accessing' }
OPBPMNDataObjectSimulatorTest >> simulatorClass [

	^ OPBPMNDataObjectSimulator
]

{ #category : 'tests' }
OPBPMNDataObjectSimulatorTest >> testBaseNodeFireGuardsBlockedAndEmptyOutgoing [

	| nodeSimulator targetFlow |
	nodeSimulator := OPBPMNActivitySimulator model: OPBPMNActivityModel new.
	nodeSimulator bpmnTokens: 2.
	nodeSimulator fire.
	self assert: nodeSimulator bpmnTokens equals: 2.

	targetFlow := OPBPMNSequenceFlowSimulator model: OPBPMNFlowModel new.
	nodeSimulator addedOutgoing: targetFlow.
	nodeSimulator blocked: true.
	nodeSimulator fire.
	self assert: nodeSimulator bpmnTokens equals: 2.
	self assert: targetFlow bpmnTokens equals: 0.

	nodeSimulator blocked: false.
	nodeSimulator fire.
	self assert: nodeSimulator bpmnTokens equals: 0.
	self assert: targetFlow bpmnTokens equals: 2
]

{ #category : 'tests' }
OPBPMNDataObjectSimulatorTest >> testFire [

	simulator bpmnTokens: 4.
	simulator fire.
	self assert: simulator bpmnTokens equals: 0.
	self assert: flowOut1 bpmnTokens equals: 0
]
