"
I am a validation rule ensuring that outgoing message flows from a black-box pool originate from the pool boundary rather than from hidden internal elements.
"
Class {
	#name : 'PR06BlackBoxOutgoingMessage',
	#superclass : 'OPBPMNValidation',
	#category : 'OpenPonk-BPMN-Validation-Validation-Classes',
	#package : 'OpenPonk-BPMN-Validation',
	#tag : 'Validation-Classes'
}

{ #category : 'accessing' }
PR06BlackBoxOutgoingMessage class >> validateClass [
	^ OPBPMNPoolModel.
]

{ #category : 'verification' }
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
