"
I am a validation rule ensuring that a Message End Event correctly defines outgoing message flows.
"
Class {
	#name : 'EE03MessageSend',
	#superclass : 'OPBPMNValidation',
	#category : 'OpenPonk-BPMN-Validation-Validation-Classes',
	#package : 'OpenPonk-BPMN-Validation',
	#tag : 'Validation-Classes'
}

{ #category : 'accessing' }
EE03MessageSend class >> validateClass [
	^ OPBPMNEndEventModel.
]

{ #category : 'verification' }
EE03MessageSend >> validateObject: aVerifiedObject withModel: aVerifiedModel [
	(aVerifiedObject isKindOf: OPBPMNEndEventModel) ifFalse: [ ^ {  } ].
	(aVerifiedObject type = OPBPMNNodeType Send and: [
		aVerifiedObject outgoing noneSatisfy: [ :each | each isKindOf: OPBPMNMessageFlowModel ] ])
		ifTrue: [
			^ { (OPBPMNValidationMessageError
				createFor: aVerifiedObject
				withValidation: self
				withText: '(EE03) ' , aVerifiedObject class name
					, ' of Message Send type has to have outgoing Message Flow.') } ].
	^ {  }
]
