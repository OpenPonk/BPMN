Class {
	#name : #PR06BlackBoxOutgoingMessage,
	#superclass : #OPBPMNValidation,
	#category : #'OpenPonk-BPMN-Validation-Validation-Classes'
}

{ #category : #'as yet unclassified' }
PR06BlackBoxOutgoingMessage class >> validateClass [
	^ OPBPMNPoolModel.
]

{ #category : #verification }
PR06BlackBoxOutgoingMessage >> validateObject: aVerifiedObject withModel: aVerifiedModel [
	
	(aVerifiedObject isKindOf: OPBPMNPoolModel ) ifTrue: [ 
		(aVerifiedObject outgoing size > 0) & (aVerifiedObject elements size >0) ifTrue: [ 
				^ { (OPBPMNValidationMessageError
					   createFor: aVerifiedObject
					   withValidation: self
					   withText: '(PR06) ', aVerifiedObject class name
						   ,
						   ' can have outgoing Message Flow only as Black-Box without elements inside.') } ] ].
	^ {  }
]
