Class {
	#name : 'OPBPMNEventSimulator',
	#superclass : 'OPBPMNFlowNodeSimulator',
	#category : 'OpenPonk-BPMN-Simulation-Simulation',
	#package : 'OpenPonk-BPMN-Simulation',
	#tag : 'Simulation'
}

{ #category : 'creation' }
OPBPMNEventSimulator >> loadConnectedItems [
	"loads and/or connects appropriate tokens and elements"

	"if event is catching start blocked"
	({
		 OPBPMNNodeType Receive.
		 OPBPMNNodeType Escalation.
		 OPBPMNNodeType Link.
		 OPBPMNNodeType Compensation.
		 OPBPMNNodeType Signal.
		 OPBPMNNodeType Multiple.
		 OPBPMNNodeType ParallelMultiple } includes: self model type)
		ifTrue: [ blocked := true ]
]
