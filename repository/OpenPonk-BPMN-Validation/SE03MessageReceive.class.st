"
I am a validation rule ensuring that a Message Start Event correctly defines incoming message flows.
"
Class {
	#name : 'SE03MessageReceive',
	#superclass : 'OPBPMNValidation',
	#category : 'OpenPonk-BPMN-Validation-Validation-Classes',
	#package : 'OpenPonk-BPMN-Validation',
	#tag : 'Validation-Classes'
}

{ #category : 'accessing' }
SE03MessageReceive class >> validateClass [
	^ OPBPMNStartEventModel.
]

{ #category : 'verification' }
SE03MessageReceive >> validateObject: aVerifiedObject withModel: aVerifiedModel [
	(aVerifiedObject isKindOf: OPBPMNStartEventModel) ifFalse: [ ^ {  } ].
	(aVerifiedObject type = OPBPMNNodeType Receive and: [
		aVerifiedObject incoming noneSatisfy: [ :each | each isKindOf: OPBPMNMessageFlowModel ] ])
		ifTrue: [
			^ { (OPBPMNValidationMessageError
				createFor: aVerifiedObject
				withValidation: self
				withText: '(SE03) ' , aVerifiedObject class name
					, ' of Message Receive type has to have incoming Message Flow.') } ].
	^ {  }
]
