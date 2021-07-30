Class {
	#name : #OPBPMNIntermediateEventModel,
	#superclass : #OPBPMNEventModel,
	#category : #'OpenPonk-BPMN-Models'
}

{ #category : #printing }
OPBPMNIntermediateEventModel >> printType [
	(type = OPBPMNNodeType None) | (type = OPBPMNNodeType Link) | (type = OPBPMNNodeType Send)
		ifTrue: [ ^ 'intermediateThrowEvent' ]
		ifFalse: [ ^ 'intermediateCatchEvent' ].

]
