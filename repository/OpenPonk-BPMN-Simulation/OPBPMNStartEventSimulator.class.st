"
Simulator component for BPMN start events.
Acts as the entry point for process execution, generating and dispatching initial tokens to outgoing flows.
"
Class {
	#name : 'OPBPMNStartEventSimulator',
	#superclass : 'OPBPMNEventSimulator',
	#category : 'OpenPonk-BPMN-Simulation-Simulation',
	#package : 'OpenPonk-BPMN-Simulation',
	#tag : 'Simulation'
}

{ #category : 'creation' }
OPBPMNStartEventSimulator >> loadConnectedItems [
	"loads and/or connects appropriate tokens and elements"

	super loadConnectedItems.
	model owner = diagramSimulator model ifTrue: [ bpmnTokens := 1 ]
]
