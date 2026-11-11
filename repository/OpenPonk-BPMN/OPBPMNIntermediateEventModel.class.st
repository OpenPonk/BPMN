"
I represent a BPMN Intermediate Event in the semantic model, denoting a specific event trigger or catch that occurs during the execution of a process.
"
Class {
	#name : 'OPBPMNIntermediateEventModel',
	#superclass : 'OPBPMNEventModel',
	#category : 'OpenPonk-BPMN-Models',
	#package : 'OpenPonk-BPMN',
	#tag : 'Models'
}

{ #category : 'printing' }
OPBPMNIntermediateEventModel >> printType [
	| throwTypes |
	throwTypes := {
		OPBPMNNodeType None .
		OPBPMNNodeType Send .
		OPBPMNNodeType EscalationThrow .
		OPBPMNNodeType LinkThrow .
		OPBPMNNodeType CompensationThrow .
		OPBPMNNodeType SignalThrow .
		OPBPMNNodeType MultipleThrow }.
	(throwTypes includes: type) ifTrue: [ ^ 'intermediateThrowEvent' ].
	^ 'intermediateCatchEvent'
]
