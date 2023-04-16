Class {
	#name : #AC04MessageSendOther,
	#superclass : #OPBPMNValidation,
	#category : #'OpenPonk-BPMN-Validation-Validation-Classes'
}

{ #category : #'as yet unclassified' }
AC04MessageSendOther class >> validateClass [
	^ OPBPMNActivityModel.
]

{ #category : #verification }
AC04MessageSendOther >> validateObject: aVerifiedObject withModel: aVerifiedModel [
	| counter |
	(aVerifiedObject isKindOf: OPBPMNActivityModel) ifTrue: [ 
		counter := 0.
		aVerifiedObject outgoing do: [ :each | (
			(each isKindOf: OPBPMNMessageFlowModel) ifTrue: [ counter := 1 ]) ] ].
		counter = 1 ifTrue: [ 
			aVerifiedObject type = OPBPMNNodeType Send
			| (aVerifiedObject type = OPBPMNNodeType Multiple) ifFalse: [ 
				^ { (OPBPMNValidationMessageError
					   createFor: aVerifiedObject
					   withValidation: self
					   withText: '(AC04) ', aVerifiedObject class name
						   ,
						   ' can have outgoing Message Flow only as Message Send type.') } ] ].
	^ {  }
]
