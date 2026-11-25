"
Simulator component for standard BPMN events (start, intermediate, end). Manages event triggering and token generation or consumption.
"
Class {
	#name : 'OPBPMNEventSimulator',
	#superclass : 'OPBPMNFlowNodeSimulator',
	#category : 'OpenPonk-BPMN-Simulation-Simulation',
	#package : 'OpenPonk-BPMN-Simulation',
	#tag : 'Simulation'
}

{ #category : 'testing' }
OPBPMNEventSimulator >> isCatchingEvent [

	^ {
		  OPBPMNNodeType Receive.
		  OPBPMNNodeType Escalation.
		  OPBPMNNodeType Link.
		  OPBPMNNodeType Compensation.
		  OPBPMNNodeType Signal.
		  OPBPMNNodeType Multiple.
		  OPBPMNNodeType ParallelMultiple } includes: self model type
]

{ #category : 'creation' }
OPBPMNEventSimulator >> loadConnectedItems [
	"Loads initial catching state for event simulators."

	super loadConnectedItems.
	self isCatchingEvent ifTrue: [ blocked := true ]
]

{ #category : 'actions' }
OPBPMNEventSimulator >> loadState [

	super loadState.
	self isCatchingEvent ifTrue: [ blocked := true ]
]
