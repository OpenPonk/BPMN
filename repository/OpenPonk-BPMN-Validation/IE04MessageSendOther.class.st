"
I am a validation rule verifying the structural correctness of outgoing messages on throwing Intermediate Events other than explicit Message Events.
"
Class {
	#name : 'IE04MessageSendOther',
	#superclass : 'OPBPMNValidation',
	#category : 'OpenPonk-BPMN-Validation-Validation-Classes',
	#package : 'OpenPonk-BPMN-Validation',
	#tag : 'Validation-Classes'
}

{ #category : 'accessing' }
IE04MessageSendOther class >> validateClass [
	^ OPBPMNIntermediateEventModel.
]

{ #category : 'verification' }
IE04MessageSendOther >> validateObject: aVerifiedObject withModel: aVerifiedModel [
	| hasOutgoingMessageFlow allowedTypes |
	(aVerifiedObject isKindOf: OPBPMNIntermediateEventModel) ifFalse: [ ^ {  } ].
	hasOutgoingMessageFlow := aVerifiedObject outgoing anySatisfy: [ :eachFlow |
		eachFlow isKindOf: OPBPMNMessageFlowModel ].
	hasOutgoingMessageFlow ifFalse: [ ^ {  } ].
	allowedTypes := {
		OPBPMNNodeType Send .
		OPBPMNNodeType MultipleThrow }.
	(allowedTypes includes: aVerifiedObject type) ifTrue: [ ^ {  } ].
	^ { (OPBPMNValidationMessageError
		createFor: aVerifiedObject
		withValidation: self
		withText: '(IE04) ' , aVerifiedObject class name
			, ' can have outgoing Message Flow only as Message Send or MultipleThrow type.') }
]
