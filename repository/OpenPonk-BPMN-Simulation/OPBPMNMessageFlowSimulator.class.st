Class {
	#name : 'OPBPMNMessageFlowSimulator',
	#superclass : 'OPBPMNFlowSimulator',
	#category : 'OpenPonk-BPMN-Simulation-Simulation',
	#package : 'OpenPonk-BPMN-Simulation',
	#tag : 'Simulation'
}

{ #category : 'actions' }
OPBPMNMessageFlowSimulator >> fire [

	self target blocked: false.
	self bpmnTokens: 0
]

{ #category : 'testing' }
OPBPMNMessageFlowSimulator >> isSteppable [

	^ self bpmnTokens > 0
]
