Class {
	#name : 'OPBPMNSequenceFlowSimulatorTest',
	#superclass : 'OPBPMNFlowSimulatorTest',
	#category : 'OpenPonk-BPMN-Simulation-Tests',
	#package : 'OpenPonk-BPMN-Simulation',
	#tag : 'Tests'
}

{ #category : 'running' }
OPBPMNSequenceFlowSimulatorTest >> controllerClass [

	^ OPBPMNSequenceFlowSimulator 
]

{ #category : 'running' }
OPBPMNSequenceFlowSimulatorTest >> exampleModel [

	^ OPBPMNFlowModel new
]

{ #category : 'running' }
OPBPMNSequenceFlowSimulatorTest >> testFire [

	simulator addBpmnTokens: 3.
	self assert: simulator bpmnTokens equals: 3.
	simulator fire.
	self assert: simulator bpmnTokens equals: 0
]

{ #category : 'running' }
OPBPMNSequenceFlowSimulatorTest >> testTokens [

	self assert: simulator bpmnTokens equals: 0.
	simulator addBpmnTokens: 6.
	self assert: simulator bpmnTokens equals: 6.
	simulator addBpmnTokens: 3.
	self assert: simulator bpmnTokens equals: 9.
	simulator bpmnTokens: 0.
	self assert: simulator bpmnTokens equals: 0
]
