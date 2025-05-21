Class {
	#name : 'OPBPMNSequenceFlowSimulator',
	#superclass : 'OPBPMNFlowSimulator',
	#category : 'OpenPonk-BPMN-Simulation-Simulation',
	#package : 'OpenPonk-BPMN-Simulation',
	#tag : 'Simulation'
}

{ #category : 'actions' }
OPBPMNSequenceFlowSimulator >> fire [

	self target addBpmnTokens: self bpmnTokens from: self.
	self bpmnTokens: 0
]

{ #category : 'testing' }
OPBPMNSequenceFlowSimulator >> isSteppable [
	"can I step right now?"

	^ self source bpmnTokens > 0 or: self bpmnTokens > 0
]
