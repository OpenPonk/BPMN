Class {
	#name : 'EE03MessageSend',
	#superclass : 'OPBPMNValidation',
	#category : 'OpenPonk-BPMN-Validation-Validation-Classes',
	#package : 'OpenPonk-BPMN-Validation',
	#tag : 'Validation-Classes'
}

{ #category : 'as yet unclassified' }
EE03MessageSend class >> validateClass [
	^ OPBPMNEndEventModel.
]

{ #category : 'verification' }
EE03MessageSend >> validateObject: aVerifiedObject withModel: aVerifiedModel [

	(aVerifiedObject isKindOf: OPBPMNEndEventModel) ifTrue: [ 
		aVerifiedObject type = OPBPMNNodeType Send
		& (aVerifiedObject outgoing size = 0) ifTrue: [ 
			^ { (OPBPMNValidationMessageError
				   createFor: aVerifiedObject
				   withValidation: self
				   withText: '(EE03) ' , aVerifiedObject class name
					   ,
					   ' of Message Send type has to have outgoing Message Flow.') } ] ].
	^ {  }
]
