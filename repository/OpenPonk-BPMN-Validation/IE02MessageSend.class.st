"
I am a validation rule ensuring that a throwing Message Intermediate Event correctly defines outgoing message flows.
"
Class {
	#name : 'IE02MessageSend',
	#superclass : 'OPBPMNValidation',
	#category : 'OpenPonk-BPMN-Validation-Validation-Classes',
	#package : 'OpenPonk-BPMN-Validation',
	#tag : 'Validation-Classes'
}

{ #category : 'accessing' }
IE02MessageSend class >> validateClass [
	^ OPBPMNIntermediateEventModel.
]

{ #category : 'verification' }
IE02MessageSend >> validateObject: aVerifiedObject withModel: aVerifiedModel [
	(aVerifiedObject isKindOf: OPBPMNIntermediateEventModel) ifFalse: [ ^ {  } ].
	aVerifiedObject type = OPBPMNNodeType Send ifFalse: [ ^ {  } ].
	(aVerifiedObject outgoing anySatisfy: [ :eachFlow |
		eachFlow isKindOf: OPBPMNMessageFlowModel ]) ifTrue: [ ^ {  } ].
	^ { (OPBPMNValidationMessageError
		createFor: aVerifiedObject
		withValidation: self
		withText: '(IE02) ' , aVerifiedObject class name
			, ' of Message Send type has to have outgoing Message Flow.') }
]
