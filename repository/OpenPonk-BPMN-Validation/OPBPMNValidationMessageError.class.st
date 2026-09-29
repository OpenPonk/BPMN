"
I represent a critical validation finding. I indicate a strict violation of the BPMN specification that must be resolved.
"
Class {
	#name : 'OPBPMNValidationMessageError',
	#superclass : 'OPBPMNValidationMessage',
	#category : 'OpenPonk-BPMN-Validation-Messages',
	#package : 'OpenPonk-BPMN-Validation',
	#tag : 'Messages'
}

{ #category : 'accessing' }
OPBPMNValidationMessageError >> severity [
	^ 'Error'
]
