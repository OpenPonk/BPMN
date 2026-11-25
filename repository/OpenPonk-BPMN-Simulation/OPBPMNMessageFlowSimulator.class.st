"
Simulator component for BPMN message flows. Transfers message tokens across participant boundaries (pools).
"
Class {
	#name : 'OPBPMNMessageFlowSimulator',
	#superclass : 'OPBPMNFlowSimulator',
	#category : 'OpenPonk-BPMN-Simulation-Simulation',
	#package : 'OpenPonk-BPMN-Simulation',
	#tag : 'Simulation'
}

{ #category : 'actions' }
OPBPMNMessageFlowSimulator >> fire [

	| tokenAmount |
	tokenAmount := self bpmnTokens.
	self target blocked: false.
	self bpmnTokens: 0.
	(tokenAmount > 0 and: [ diagramSimulator isNotNil ]) ifTrue: [
			diagramSimulator recordTransfer: ((OPSimulationTransfer source: self source model edge: self model target: self target model)
					 amount: tokenAmount;
					 kind: #message;
					 yourself) ]
]

{ #category : 'testing' }
OPBPMNMessageFlowSimulator >> isSteppable [

	^ self bpmnTokens > 0
]
