"
I am a validation rule verifying the structural correctness of incoming messages on activities other than explicit Receive Tasks.
"
Class {
	#name : 'AC03MessageReceiveOther',
	#superclass : 'OPBPMNValidation',
	#category : 'OpenPonk-BPMN-Validation-Validation-Classes',
	#package : 'OpenPonk-BPMN-Validation',
	#tag : 'Validation-Classes'
}

{ #category : 'accessing' }
AC03MessageReceiveOther class >> validateClass [
	^ OPBPMNActivityModel.
]

{ #category : 'verification' }
AC03MessageReceiveOther >> validateObject: aVerifiedObject withModel: aVerifiedModel [
	| hasIncomingMessageFlow allowedTypes |
	(aVerifiedObject isKindOf: OPBPMNActivityModel) ifFalse: [ ^ {  } ].
	hasIncomingMessageFlow := aVerifiedObject incoming anySatisfy: [ :eachFlow |
		eachFlow isKindOf: OPBPMNMessageFlowModel ].
	hasIncomingMessageFlow ifFalse: [ ^ {  } ].
	allowedTypes := {
		OPBPMNNodeType Receive .
		OPBPMNNodeType Service .
		OPBPMNNodeType User .
		OPBPMNNodeType None }.
	(allowedTypes includes: aVerifiedObject type) ifTrue: [ ^ {  } ].
	^ { (OPBPMNValidationMessageError
		createFor: aVerifiedObject
		withValidation: self
		withText: '(AC03) ' , aVerifiedObject class name
			, ' of type ' , aVerifiedObject type asString
			, ' cannot have incoming Message Flow.') }
]
