"
I am a validation rule verifying the structural correctness of incoming messages on Start Events other than explicit Message Start Events.
"
Class {
	#name : 'SE04MessageOther',
	#superclass : 'OPBPMNValidation',
	#category : 'OpenPonk-BPMN-Validation-Validation-Classes',
	#package : 'OpenPonk-BPMN-Validation',
	#tag : 'Validation-Classes'
}

{ #category : 'accessing' }
SE04MessageOther class >> validateClass [
	^ OPBPMNStartEventModel.
]

{ #category : 'verification' }
SE04MessageOther >> validateObject: aVerifiedObject withModel: aVerifiedModel [
	| hasIncomingMessageFlow allowedTypes |
	(aVerifiedObject isKindOf: OPBPMNStartEventModel) ifFalse: [ ^ {  } ].
	hasIncomingMessageFlow := aVerifiedObject incoming anySatisfy: [ :eachFlow |
		eachFlow isKindOf: OPBPMNMessageFlowModel ].
	hasIncomingMessageFlow ifFalse: [ ^ {  } ].
	allowedTypes := {
		OPBPMNNodeType Receive .
		OPBPMNNodeType Multiple .
		OPBPMNNodeType ParallelMultiple }.
	(allowedTypes includes: aVerifiedObject type) ifTrue: [ ^ {  } ].
	^ { (OPBPMNValidationMessageError
		createFor: aVerifiedObject
		withValidation: self
		withText: '(SE04) ' , aVerifiedObject class name
			, ' can have incoming Message Flow only as Message, Multiple, or ParallelMultiple type.') }
]
