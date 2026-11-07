"
I am a validation rule checking whether a Send Task correctly defines outgoing message flows.
"
Class {
	#name : 'AC02MessageSend',
	#superclass : 'OPBPMNValidation',
	#category : 'OpenPonk-BPMN-Validation-Validation-Classes',
	#package : 'OpenPonk-BPMN-Validation',
	#tag : 'Validation-Classes'
}

{ #category : 'accessing' }
AC02MessageSend class >> validateClass [
	^ OPBPMNActivityModel.
]

{ #category : 'verification' }
AC02MessageSend >> validateObject: aVerifiedObject withModel: aVerifiedModel [
	(aVerifiedObject isKindOf: OPBPMNActivityModel) ifFalse: [ ^ {  } ].
	aVerifiedObject type = OPBPMNNodeType Send ifFalse: [ ^ {  } ].
	(aVerifiedObject outgoing anySatisfy: [ :each | each isKindOf: OPBPMNMessageFlowModel ])
		ifTrue: [ ^ {  } ].
	^ { (OPBPMNValidationMessageWarning
		createFor: aVerifiedObject
		withValidation: self
		withText: '(AC02) ' , aVerifiedObject class name
			, ' of Message Send type should have outgoing Message Flow.') }
]
