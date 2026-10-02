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

{ #category : 'testing' }
OPBPMNStartEventSimulator >> isInsideSubProcess [
	| current |
	current := model owner.
	[ current isNotNil ] whileTrue: [
		(current isKindOf: OPBPMNSubProcessModel) ifTrue: [ ^ true ].
		current := current owner ].
	^ false
]

{ #category : 'creation' }
OPBPMNStartEventSimulator >> loadConnectedItems [

	super loadConnectedItems.
	self isInsideSubProcess ifTrue: [ ^ self ].
	bpmnTokens := 1.
	blocked := false
]
