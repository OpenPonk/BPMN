"
I am a validation rule verifying the structural correctness of incoming messages on catching Intermediate Events other than explicit Message Events.
"
Class {
	#name : 'IE03MessageReceiveOther',
	#superclass : 'OPBPMNValidation',
	#category : 'OpenPonk-BPMN-Validation-Validation-Classes',
	#package : 'OpenPonk-BPMN-Validation',
	#tag : 'Validation-Classes'
}

{ #category : 'testing' }
IE03MessageReceiveOther class >> canValidate: aVerifiedObject [
	^ (super canValidate: aVerifiedObject)
		or: [ aVerifiedObject isKindOf: OPBPMNBoundaryEventModel ]
]

{ #category : 'accessing' }
IE03MessageReceiveOther class >> validateClass [
	^ OPBPMNIntermediateEventModel.
]

{ #category : 'verification' }
IE03MessageReceiveOther >> validateObject: aVerifiedObject withModel: aVerifiedModel [
	| hasIncomingMessageFlow allowedTypes |
	(self class canValidate: aVerifiedObject) ifFalse: [ ^ {  } ].
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
		withText: '(IE03) ' , aVerifiedObject class name
			, ' can have incoming Message Flow only as Message, Multiple, or ParallelMultiple type.') }
]
