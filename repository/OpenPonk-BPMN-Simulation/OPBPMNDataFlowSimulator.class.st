"
Simulator component for BPMN data flows (data associations). Transfers data tokens between elements and data objects.
"
Class {
	#name : 'OPBPMNDataFlowSimulator',
	#superclass : 'OPBPMNFlowSimulator',
	#category : 'OpenPonk-BPMN-Simulation-Simulation',
	#package : 'OpenPonk-BPMN-Simulation',
	#tag : 'Simulation'
}

{ #category : 'adding' }
OPBPMNDataFlowSimulator >> addBpmnTokens: anInteger [
	"do nothing"

	
]

{ #category : 'actions' }
OPBPMNDataFlowSimulator >> fire [

	| tokenCount |
	self bpmnTokens: 0.
	tokenCount := self source bpmnTokens.
	tokenCount = 0 ifTrue: [ ^ self ].
	self bpmnTokens: tokenCount.
	self target addBpmnTokens: tokenCount from: self
]

{ #category : 'initialization' }
OPBPMNDataFlowSimulator >> initialize [

	super initialize.
	priority := -2
]

{ #category : 'testing' }
OPBPMNDataFlowSimulator >> isSteppable [
	"can I step right now?"

	^ true
]
