"
Unit tests for OPBPMNMessageFlowSimulator.
Verifies message token transfer across participant boundaries.
"
Class {
	#name : 'OPBPMNMessageFlowSimulatorTest',
	#superclass : 'OPBPMNFlowSimulatorTest',
	#category : 'OpenPonk-BPMN-Simulation-Tests-Simulation',
	#package : 'OpenPonk-BPMN-Simulation-Tests',
	#tag : 'Simulation'
}

{ #category : 'running' }
OPBPMNMessageFlowSimulatorTest >> exampleModel [

	^ OPBPMNMessageFlowModel new
]

{ #category : 'running' }
OPBPMNMessageFlowSimulatorTest >> simulatorClass [

	^ OPBPMNMessageFlowSimulator
]

{ #category : 'tests' }
OPBPMNMessageFlowSimulatorTest >> testFire [

	self assert: simulator target blocked description: 'Message flow target must start blocked'.
	simulator addBpmnTokens: 3.
	self assert: simulator bpmnTokens equals: 3.
	simulator fire.
	self deny: simulator target blocked description: 'Message flow target must be unblocked after firing'.
	self assert: simulator bpmnTokens equals: 0
]

{ #category : 'tests' }
OPBPMNMessageFlowSimulatorTest >> testTokens [

	self assert: simulator bpmnTokens equals: 0.
	simulator addBpmnTokens: 6.
	self assert: simulator bpmnTokens equals: 6.
	simulator addBpmnTokens: 3.
	self assert: simulator bpmnTokens equals: 9.
	simulator bpmnTokens: 0.
	self assert: simulator bpmnTokens equals: 0
]
