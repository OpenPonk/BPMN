Class {
	#name : 'OPBPMNDataFlowSimulatorTest',
	#superclass : 'OPBPMNFlowSimulatorTest',
	#category : 'OpenPonk-BPMN-Simulation-Tests',
	#package : 'OpenPonk-BPMN-Simulation',
	#tag : 'Tests'
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
