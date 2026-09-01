"
Simulator component for BPMN end events.
Handles token consumption and finalizes process paths upon execution.
"
Class {
	#name : 'OPBPMNEndEventSimulator',
	#superclass : 'OPBPMNEventSimulator',
	#category : 'OpenPonk-BPMN-Simulation-Simulation',
	#package : 'OpenPonk-BPMN-Simulation',
	#tag : 'Simulation'
}

{ #category : 'actions' }
OPBPMNEndEventSimulator >> fire [

	self model type = OPBPMNNodeType Terminate
		ifFalse: [ self bpmnTokens: 0 ]
		ifTrue: [ diagramSimulator elementsDo: [ :el | el bpmnTokens: 0 ] ]
]
