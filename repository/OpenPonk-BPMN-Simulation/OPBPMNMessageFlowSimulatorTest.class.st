Class {
	#name : 'OPBPMNMessageFlowSimulatorTest',
	#superclass : 'OPBPMNFlowSimulatorTest',
	#category : 'OpenPonk-BPMN-Simulation-Tests',
	#package : 'OpenPonk-BPMN-Simulation',
	#tag : 'Tests'
}

{ #category : 'running' }
OPBPMNMessageFlowSimulatorTest >> controllerClass [

	^ OPBPMNMessageFlowSimulator
]

{ #category : 'running' }
OPBPMNMessageFlowSimulatorTest >> exampleModel [

	^ OPBPMNMessageFlowModel new
]

{ #category : 'tests' }
OPBPMNMessageFlowSimulatorTest >> testFire [

	self assert: simulator target blocked.
	simulator addBpmnTokens: 3.
	self assert: simulator bpmnTokens equals: 3.
	simulator fire.
	self assert: simulator target blocked not.
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
