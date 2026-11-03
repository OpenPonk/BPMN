"
I am a validation rule ensuring that a catching Message Intermediate Event correctly defines incoming message flows.
"
Class {
	#name : 'IE01MessageReceive',
	#superclass : 'OPBPMNValidation',
	#category : 'OpenPonk-BPMN-Validation-Validation-Classes',
	#package : 'OpenPonk-BPMN-Validation',
	#tag : 'Validation-Classes'
}

{ #category : 'testing' }
IE01MessageReceive class >> canValidate: aVerifiedObject [
	^ (super canValidate: aVerifiedObject)
		or: [ aVerifiedObject isKindOf: OPBPMNBoundaryEventModel ]
]

{ #category : 'accessing' }
IE01MessageReceive class >> validateClass [
	^ OPBPMNIntermediateEventModel.
]

{ #category : 'verification' }
IE01MessageReceive >> validateObject: aVerifiedObject withModel: aVerifiedModel [
	(self class canValidate: aVerifiedObject) ifFalse: [ ^ {  } ].
	aVerifiedObject type = OPBPMNNodeType Receive ifFalse: [ ^ {  } ].
	(aVerifiedObject incoming anySatisfy: [ :eachFlow |
		eachFlow isKindOf: OPBPMNMessageFlowModel ]) ifTrue: [ ^ {  } ].
	^ { (OPBPMNValidationMessageError
		createFor: aVerifiedObject
		withValidation: self
		withText: '(IE01) ' , aVerifiedObject class name
			, ' of Message Receive type has to have incoming Message Flow.') }
]
