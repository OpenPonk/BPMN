Class {
	#name : 'OPBPMNValidationMessageUI',
	#superclass : 'Object',
	#category : 'OpenPonk-BPMN-Validation-UI',
	#package : 'OpenPonk-BPMN-Validation',
	#tag : 'UI'
}

{ #category : 'displaying' }
OPBPMNValidationMessageUI class >> getObjectReferenceName: aVerificationMessage [
	(aVerificationMessage objectReference respondsTo: #name)
		ifTrue: [ ^ aVerificationMessage objectReference name ].
]
