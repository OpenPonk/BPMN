"
Unit tests for OPBPMNSequenceFlowSimulator.
Verifies direct token progression between flow nodes within the same process.
"
Class {
	#name : 'OPBPMNSequenceFlowSimulatorTest',
	#superclass : 'OPBPMNFlowSimulatorTest',
	#category : 'OpenPonk-BPMN-Simulation-Tests-Simulation',
	#package : 'OpenPonk-BPMN-Simulation-Tests',
	#tag : 'Simulation'
}

{ #category : 'running' }
OPBPMNSequenceFlowSimulatorTest >> exampleModel [

	^ OPBPMNFlowModel new
]

{ #category : 'running' }
OPBPMNSequenceFlowSimulatorTest >> simulatorClass [

	^ OPBPMNSequenceFlowSimulator 
]

{ #category : 'tests' }
OPBPMNSequenceFlowSimulatorTest >> testFire [

	simulator addBpmnTokens: 3.
	self assert: simulator bpmnTokens equals: 3.
	simulator fire.
	self assert: simulator bpmnTokens equals: 0.
	self assert: nodeOut bpmnTokens equals: 3
]

{ #category : 'tests' }
OPBPMNSequenceFlowSimulatorTest >> testTokens [

	self assert: simulator bpmnTokens equals: 0.
	simulator addBpmnTokens: 6.
	self assert: simulator bpmnTokens equals: 6.
	simulator addBpmnTokens: 3.
	self assert: simulator bpmnTokens equals: 9.
	simulator bpmnTokens: 0.
	self assert: simulator bpmnTokens equals: 0
]
