Class {
	#name : #SE04MessageOther,
	#superclass : #OPBPMNValidation,
	#category : #'OpenPonk-BPMN-Validation-Validation-Classes'
}

{ #category : #'as yet unclassified' }
SE04MessageOther class >> validateClass [
	^ OPBPMNStartEventModel.
]

{ #category : #verification }
SE04MessageOther >> validateObject: aVerifiedObject withModel: aVerifiedModel [

	(aVerifiedObject isKindOf: OPBPMNStartEventModel) ifTrue: [ 
		aVerifiedObject incoming size > 0 ifTrue: [ 
			aVerifiedObject type = OPBPMNNodeType Receive
			| (aVerifiedObject type = OPBPMNNodeType Multiple) ifFalse: [ 
				^ { (OPBPMNValidationMessageError
					   createFor: aVerifiedObject
					   withValidation: self
					   withText: '(SE04) ', aVerifiedObject class name
						   ,
						   ' can have incoming Message Flow only as Message or Multiple type.') } ] ] ].
	^ {  }
]
