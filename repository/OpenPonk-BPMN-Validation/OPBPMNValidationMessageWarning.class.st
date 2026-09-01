"
I represent a non-critical validation finding. I indicate a deviation from BPMN best practices or a potential structural issue that does not strictly violate the specification.
"
Class {
	#name : 'OPBPMNValidationMessageWarning',
	#superclass : 'OPBPMNValidationMessage',
	#category : 'OpenPonk-BPMN-Validation-Messages',
	#package : 'OpenPonk-BPMN-Validation',
	#tag : 'Messages'
}

{ #category : 'accessing' }
OPBPMNValidationMessageWarning >> severity [
	^ 'Warning'
]
