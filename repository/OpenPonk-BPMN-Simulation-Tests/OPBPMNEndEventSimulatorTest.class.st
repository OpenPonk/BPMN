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
OPBPMNEndEventSimulatorTest >> controllerClass [

	^ OPBPMNEndEventSimulator
]

{ #category : 'accessing' }
OPBPMNEndEventSimulatorTest >> exampleModel [

	^ OPBPMNEndEventModel new
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
