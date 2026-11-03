"
I am a validation rule enforcing constraints on multiple error boundary events attached to the same activity.
"
Class {
	#name : 'BE03BoundaryErrorSibling',
	#superclass : 'OPBPMNValidation',
	#category : 'OpenPonk-BPMN-Validation-Validation-Classes',
	#package : 'OpenPonk-BPMN-Validation',
	#tag : 'Validation-Classes'
}

{ #category : 'accessing' }
BE03BoundaryErrorSibling class >> validateClass [
	^ OPBPMNBoundaryEventModel.
]

{ #category : 'verification' }
BE03BoundaryErrorSibling >> validateObject: aVerifiedObject withModel: aVerifiedModel [
	(aVerifiedObject isKindOf: OPBPMNBoundaryEventModel) ifFalse: [ ^ {  } ].
	aVerifiedObject type = OPBPMNNodeType Error ifFalse: [ ^ {  } ].
	(aVerifiedObject owner isKindOf: OPBPMNSubProcessModel) ifFalse: [ ^ {  } ].
	(aVerifiedObject owner elements anySatisfy: [ :each |
		(each isKindOf: OPBPMNEndEventModel) and: [ each type = OPBPMNNodeType Error ] ])
		ifTrue: [ ^ {  } ].
	^ { (OPBPMNValidationMessageWarning
		createFor: aVerifiedObject
		withValidation: self
		withText: '(BE03) ' , aVerifiedObject class name
			, ' should have pair Error End Event in Sub-Process.') }
]
