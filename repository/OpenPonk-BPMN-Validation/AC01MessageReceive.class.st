"
I am a validation rule checking whether a Receive Task correctly defines incoming message flows according to the BPMN specification.
"
Class {
	#name : 'AC01MessageReceive',
	#superclass : 'OPBPMNValidation',
	#category : 'OpenPonk-BPMN-Validation-Validation-Classes',
	#package : 'OpenPonk-BPMN-Validation',
	#tag : 'Validation-Classes'
}

{ #category : 'accessing' }
AC01MessageReceive class >> validateClass [
	^ OPBPMNActivityModel.
]

{ #category : 'verification' }
AC01MessageReceive >> validateObject: aVerifiedObject withModel: aVerifiedModel [
	(aVerifiedObject isKindOf: OPBPMNActivityModel) ifFalse: [ ^ {  } ].
	aVerifiedObject type = OPBPMNNodeType Receive ifFalse: [ ^ {  } ].
	(aVerifiedObject incoming anySatisfy: [ :each | each isKindOf: OPBPMNMessageFlowModel ])
		ifTrue: [ ^ {  } ].
	^ { (OPBPMNValidationMessageWarning
		createFor: aVerifiedObject
		withValidation: self
		withText: '(AC01) ' , aVerifiedObject class name
			, ' of Message Receive type should have incoming Message Flow.') }
]
