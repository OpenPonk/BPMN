"
Unit tests for OPBPMNDataFlowSimulator.
Verifies token transfer and data association logic during simulation.
"
Class {
	#name : 'OPBPMNDataFlowSimulatorTest',
	#superclass : 'OPBPMNFlowSimulatorTest',
	#category : 'OpenPonk-BPMN-Simulation-Tests-Simulation',
	#package : 'OpenPonk-BPMN-Simulation-Tests',
	#tag : 'Simulation'
}

{ #category : 'running' }
OPBPMNDataFlowSimulatorTest >> controllerClass [

	^ OPBPMNDataFlowSimulator
]

{ #category : 'running' }
OPBPMNDataFlowSimulatorTest >> exampleModel [

	^ OPBPMNDataFlowModel new
]

{ #category : 'tests' }
OPBPMNDataFlowSimulatorTest >> testFire [

	simulator fire.
	self assert: simulator bpmnTokens equals: 10.
	self assert: nodeOut bpmnTokens equals: 10
]

{ #category : 'tests' }
OPBPMNDataFlowSimulatorTest >> testTokens [

	self assert: simulator bpmnTokens equals: 0.
	simulator addBpmnTokens: 6.
	self assert: simulator bpmnTokens equals: 0.
	simulator addBpmnTokens: 3.
	self assert: simulator bpmnTokens equals: 0.
	simulator bpmnTokens: 0.
	self assert: simulator bpmnTokens equals: 0
]
