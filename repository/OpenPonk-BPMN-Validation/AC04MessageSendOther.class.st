"
I am a validation rule verifying the structural correctness of outgoing messages on activities other than explicit Send Tasks.
"
Class {
	#name : 'AC04MessageSendOther',
	#superclass : 'OPBPMNValidation',
	#category : 'OpenPonk-BPMN-Validation-Validation-Classes',
	#package : 'OpenPonk-BPMN-Validation',
	#tag : 'Validation-Classes'
}

{ #category : 'accessing' }
AC04MessageSendOther class >> validateClass [
	^ OPBPMNActivityModel.
]

{ #category : 'verification' }
AC04MessageSendOther >> validateObject: aVerifiedObject withModel: aVerifiedModel [
	| hasOutgoingMessageFlow |
	(aVerifiedObject isKindOf: OPBPMNActivityModel) ifFalse: [ ^ {  } ].
	hasOutgoingMessageFlow := aVerifiedObject outgoing anySatisfy: [ :eachFlow |
		eachFlow isKindOf: OPBPMNMessageFlowModel ].
	hasOutgoingMessageFlow ifFalse: [ ^ {  } ].
	aVerifiedObject type = OPBPMNNodeType Receive ifFalse: [ ^ {  } ].
	^ { (OPBPMNValidationMessageError
		createFor: aVerifiedObject
		withValidation: self
		withText: '(AC04) ' , aVerifiedObject class name
			, ' of type ' , aVerifiedObject type asString
			, ' cannot have outgoing Message Flow.') }
]
