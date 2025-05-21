Class {
	#name : 'OPBPMNFlowSimulatorTest',
	#superclass : 'TestCase',
	#instVars : [
		'model',
		'simulator',
		'nodeIn',
		'nodeOut'
	],
	#category : 'OpenPonk-BPMN-Simulation-Tests',
	#package : 'OpenPonk-BPMN-Simulation',
	#tag : 'Tests'
}

{ #category : 'testing' }
OPBPMNFlowSimulatorTest class >> isAbstract [

	^ self == OPBPMNFlowSimulatorTest
]

{ #category : 'running' }
OPBPMNFlowSimulatorTest >> controllerClass [

	^ self subclassResponsibility
]

{ #category : 'running' }
OPBPMNFlowSimulatorTest >> exampleModel [

	^ self subclassResponsibility
]

{ #category : 'running' }
OPBPMNFlowSimulatorTest >> setUp [

	super setUp.
	model := self exampleModel.
	simulator := self controllerClass model: model.
	nodeIn := (OPBPMNNodeSimulator model: OPBPMNNodeModel) bpmnTokens: 10.
	nodeOut := (OPBPMNNodeSimulator model: OPBPMNNodeModel) blocked: true.
	simulator
		source: nodeIn;
		target: nodeOut
]
