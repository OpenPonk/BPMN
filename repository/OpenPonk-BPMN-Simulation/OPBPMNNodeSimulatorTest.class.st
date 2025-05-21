Class {
	#name : 'OPBPMNNodeSimulatorTest',
	#superclass : 'TestCase',
	#instVars : [
		'model',
		'simulator',
		'flowIn1',
		'flowOut1'
	],
	#category : 'OpenPonk-BPMN-Simulation-Tests',
	#package : 'OpenPonk-BPMN-Simulation',
	#tag : 'Tests'
}

{ #category : 'testing' }
OPBPMNNodeSimulatorTest class >> isAbstract [

	^ self == OPBPMNNodeSimulatorTest
]

{ #category : 'accessing' }
OPBPMNNodeSimulatorTest >> controllerClass [

	^ self subclassResponsibility
]

{ #category : 'accessing' }
OPBPMNNodeSimulatorTest >> exampleModel [

	^ self subclassResponsibility
]

{ #category : 'accessing' }
OPBPMNNodeSimulatorTest >> setUp [

	super setUp.
	model := self exampleModel.
	simulator := self controllerClass model: model.
	flowIn1 := (OPBPMNSequenceFlowSimulator model: OPBPMNFlowModel) bpmnTokens:
		           10.
	flowOut1 := OPBPMNSequenceFlowSimulator model: OPBPMNFlowModel.
	simulator addedIncoming: flowIn1.
	simulator addedOutgoing: flowOut1
]

{ #category : 'accessing' }
OPBPMNNodeSimulatorTest >> testFire [

	^ self subclassResponsibility
]
