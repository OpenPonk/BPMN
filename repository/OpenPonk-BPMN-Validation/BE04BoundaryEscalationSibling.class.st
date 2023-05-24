Class {
	#name : #BE04BoundaryEscalationSibling,
	#superclass : #OPBPMNValidation,
	#category : #'OpenPonk-BPMN-Validation-Validation-Classes'
}

{ #category : #'as yet unclassified' }
BE04BoundaryEscalationSibling class >> validateClass [
	^ OPBPMNBoundaryEventModel.
]

{ #category : #verification }
BE04BoundaryEscalationSibling >> validateObject: aVerifiedObject withModel: aVerifiedModel [
	| counter |
	(aVerifiedObject isKindOf: OPBPMNBoundaryEventModel) ifTrue: [ 
		(aVerifiedObject type = OPBPMNNodeType Escalation) ifTrue: [ 
		counter := 0.
		aVerifiedObject owner elements do: [ :each | (
			(each isKindOf: OPBPMNEndEventModel) | (each isKindOf: OPBPMNIntermediateEventModel) ifTrue: [ 
				(each type = OPBPMNNodeType EscalationThrow ) ifTrue: [
				
				counter := 1 ]]) ].
		counter = 0 ifTrue: [ 
				^ { (OPBPMNValidationMessageWarning
					   createFor: aVerifiedObject
					   withValidation: self
					   withText: '(BE04) ', aVerifiedObject class name
						   ,
						   ' should have pair Throw Escalation Intermediate/End Event in Sub-Process.') } ] ]].
	^ {  }
]
