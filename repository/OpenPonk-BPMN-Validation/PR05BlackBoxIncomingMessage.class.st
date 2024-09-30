Class {
	#name : 'PR05BlackBoxIncomingMessage',
	#superclass : 'OPBPMNValidation',
	#category : 'OpenPonk-BPMN-Validation-Validation-Classes',
	#package : 'OpenPonk-BPMN-Validation',
	#tag : 'Validation-Classes'
}

{ #category : 'as yet unclassified' }
PR05BlackBoxIncomingMessage class >> validateClass [
	^ OPBPMNPoolModel.
]

{ #category : 'verification' }
PR05BlackBoxIncomingMessage >> validateObject: aVerifiedObject withModel: aVerifiedModel [
	
	(aVerifiedObject isKindOf: OPBPMNPoolModel ) ifTrue: [ 
		(aVerifiedObject incoming size > 0) & (aVerifiedObject elements size >0) ifTrue: [ 
				^ { (OPBPMNValidationMessageError
					   createFor: aVerifiedObject
					   withValidation: self
					   withText: '(PR05) ', aVerifiedObject class name
						   ,
						   ' can have incoming Message Flow only as Black-Box without elements inside.') } ] ].
	^ {  }
]
