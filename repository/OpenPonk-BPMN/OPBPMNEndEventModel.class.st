"
I represent a BPMN End Event in the semantic model, signifying the completion of a specific process path.
"
Class {
	#name : 'OPBPMNEndEventModel',
	#superclass : 'OPBPMNEventModel',
	#category : 'OpenPonk-BPMN-Models',
	#package : 'OpenPonk-BPMN',
	#tag : 'Models'
}

{ #category : 'printing' }
OPBPMNEndEventModel >> printType [
	^ 'endEvent'
]
