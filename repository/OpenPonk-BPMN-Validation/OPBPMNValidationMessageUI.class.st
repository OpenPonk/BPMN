"
I provide UI utilities for formatting validation messages, such as extracting human-readable names for the referenced diagram objects.
"
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
