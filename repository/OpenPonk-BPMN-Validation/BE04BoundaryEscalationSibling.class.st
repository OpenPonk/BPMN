"
I am a validation rule enforcing constraints on multiple escalation boundary events attached to the same activity.
"
Class {
	#name : 'BE04BoundaryEscalationSibling',
	#superclass : 'OPBPMNValidation',
	#category : 'OpenPonk-BPMN-Validation-Validation-Classes',
	#package : 'OpenPonk-BPMN-Validation',
	#tag : 'Validation-Classes'
}

{ #category : 'accessing' }
BE04BoundaryEscalationSibling class >> validateClass [
	^ OPBPMNBoundaryEventModel.
]

{ #category : 'verification' }
BE04BoundaryEscalationSibling >> validateObject: aVerifiedObject withModel: aVerifiedModel [
	(aVerifiedObject isKindOf: OPBPMNBoundaryEventModel) ifFalse: [ ^ {  } ].
	aVerifiedObject type = OPBPMNNodeType Escalation ifFalse: [ ^ {  } ].
	(aVerifiedObject owner isKindOf: OPBPMNSubProcessModel) ifFalse: [ ^ {  } ].
	(aVerifiedObject owner elements anySatisfy: [ :each |
		((each isKindOf: OPBPMNEndEventModel) or: [ each isKindOf: OPBPMNIntermediateEventModel ])
			and: [ each type = OPBPMNNodeType EscalationThrow ] ])
		ifTrue: [ ^ {  } ].
	^ { (OPBPMNValidationMessageWarning
		createFor: aVerifiedObject
		withValidation: self
		withText: '(BE04) ' , aVerifiedObject class name
			, ' should have pair Throw Escalation Intermediate/End Event in Sub-Process.') }
]
