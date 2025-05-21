Class {
	#name : 'OPBPMNGatewaySimulatorTest',
	#superclass : 'OPBPMNNodeSimulatorTest',
	#instVars : [
		'flowIn2',
		'flowOut2'
	],
	#category : 'OpenPonk-BPMN-Simulation-Tests',
	#package : 'OpenPonk-BPMN-Simulation',
	#tag : 'Tests'
}

{ #category : 'testing' }
OPBPMNGatewaySimulatorTest class >> isAbstract [

	^ self == OPBPMNGatewaySimulatorTest
]

{ #category : 'accessing' }
OPBPMNGatewaySimulatorTest >> exampleModel [

	^ OPBPMNGatewayModel new
]

{ #category : 'accessing' }
OPBPMNGatewaySimulatorTest >> setUp [

	super setUp.
	flowIn2 := OPBPMNSequenceFlowSimulator model: OPBPMNFlowModel.
	flowOut2 := OPBPMNSequenceFlowSimulator model: OPBPMNFlowModel.
	simulator addedIncoming: flowIn2.
	simulator addedOutgoing: flowOut2.
	simulator bpmnTokens: 1.
	simulator outgoingActive: {
			flowOut1.
			flowOut2 }
]
