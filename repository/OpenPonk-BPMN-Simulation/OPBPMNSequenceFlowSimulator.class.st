"
Simulator component for BPMN sequence flows. Controls the direct sequential progression of tokens between flow nodes within the same process.
"
Class {
	#name : 'OPBPMNSequenceFlowSimulator',
	#superclass : 'OPBPMNFlowSimulator',
	#category : 'OpenPonk-BPMN-Simulation-Simulation',
	#package : 'OpenPonk-BPMN-Simulation',
	#tag : 'Simulation'
}

{ #category : 'actions' }
OPBPMNSequenceFlowSimulator >> fire [

	| tokenAmount |
	tokenAmount := self bpmnTokens.
	self target addBpmnTokens: tokenAmount from: self.
	self bpmnTokens: 0.
	(tokenAmount > 0 and: [ diagramSimulator isNotNil ]) ifTrue: [
			diagramSimulator recordTransfer: ((OPSimulationTransfer source: self source model edge: self model target: self target model)
					 amount: tokenAmount;
					 yourself) ]
]

{ #category : 'testing' }
OPBPMNSequenceFlowSimulator >> isSteppable [
	"can I step right now?"

	^ self source bpmnTokens > 0 or: self bpmnTokens > 0
]
