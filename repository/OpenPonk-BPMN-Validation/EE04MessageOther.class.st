Class {
	#name : 'EE04MessageOther',
	#superclass : 'OPBPMNValidation',
	#category : 'OpenPonk-BPMN-Validation-Validation-Classes',
	#package : 'OpenPonk-BPMN-Validation',
	#tag : 'Validation-Classes'
}

{ #category : 'as yet unclassified' }
EE04MessageOther class >> validateClass [
	^ OPBPMNEndEventModel.
]

{ #category : 'verification' }
EE04MessageOther >> validateObject: aVerifiedObject withModel: aVerifiedModel [

	(aVerifiedObject isKindOf: OPBPMNEndEventModel) ifTrue: [ 
		aVerifiedObject outgoing size > 0 ifTrue: [ 
			aVerifiedObject type = OPBPMNNodeType Send
			| (aVerifiedObject type = OPBPMNNodeType MultipleThrow) ifFalse: [ 
				^ { (OPBPMNValidationMessageError
					   createFor: aVerifiedObject
					   withValidation: self
					   withText: '(EE04) ', aVerifiedObject class name
						   ,
						   ' can have outgoing Message Flow only as Message or Multiple type.') } ] ] ].
	^ {  }
]
