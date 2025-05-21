"
An OPBPMNStartEventSimulatorTest is a test class for testing the behavior of OPBPMNStartEventSimulator
"
Class {
	#name : 'OPBPMNEndEventSimulatorTest',
	#superclass : 'OPBPMNNodeSimulatorTest',
	#category : 'OpenPonk-BPMN-Simulation-Tests',
	#package : 'OpenPonk-BPMN-Simulation',
	#tag : 'Tests'
}

{ #category : 'accessing' }
OPBPMNEndEventSimulatorTest >> controllerClass [

	^ OPBPMNEndEventSimulator
]

{ #category : 'accessing' }
OPBPMNEndEventSimulatorTest >> exampleModel [

	^ OPBPMNEndEventModel new
]

{ #category : 'accessing' }
OPBPMNEndEventSimulatorTest >> testFire [

	model type: OPBPMNNodeType None.
	simulator addBpmnTokens: 3 from: flowIn1.
	self assert: simulator bpmnTokens equals: 3.
	self assert: flowOut1 bpmnTokens equals: 0.
	simulator fire.
	self assert: simulator bpmnTokens equals: 0.
	self assert: flowOut1 bpmnTokens equals: 0
]
