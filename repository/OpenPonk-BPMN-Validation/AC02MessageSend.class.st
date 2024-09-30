Class {
	#name : 'AC02MessageSend',
	#superclass : 'OPBPMNValidation',
	#category : 'OpenPonk-BPMN-Validation-Validation-Classes',
	#package : 'OpenPonk-BPMN-Validation',
	#tag : 'Validation-Classes'
}

{ #category : 'as yet unclassified' }
AC02MessageSend class >> validateClass [
	^ OPBPMNActivityModel.
]

{ #category : 'verification' }
AC02MessageSend >> validateObject: aVerifiedObject withModel: aVerifiedModel [

	| counter |
	(aVerifiedObject isKindOf: OPBPMNActivityModel) ifTrue: [ 
		aVerifiedObject type = OPBPMNNodeType Send ifTrue: [ 
			counter := 0.
			aVerifiedObject outgoing do: [ :each | (
				(each isKindOf: OPBPMNMessageFlowModel) ifTrue: [ counter := 1 ]) ] ].
			counter = 0 ifTrue: [ 
			^ { (OPBPMNValidationMessageError
				   createFor: aVerifiedObject
				   withValidation: self
				   withText: '(AC02) ' , aVerifiedObject class name
					   ,
					   ' of Message Send type has to have outgoing Message Flow.') } ] ].
	^ {  }
]
