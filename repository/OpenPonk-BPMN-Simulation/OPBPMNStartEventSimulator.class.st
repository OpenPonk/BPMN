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
