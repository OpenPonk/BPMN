Class {
	#name : #BE03BoundaryErrorSibling,
	#superclass : #OPBPMNValidation,
	#category : #'OpenPonk-BPMN-Validation-Validation-Classes'
}

{ #category : #'as yet unclassified' }
BE03BoundaryErrorSibling class >> validateClass [
	^ OPBPMNBoundaryEventModel.
]

{ #category : #verification }
BE03BoundaryErrorSibling >> validateObject: aVerifiedObject withModel: aVerifiedModel [
	| counter |
	(aVerifiedObject isKindOf: OPBPMNBoundaryEventModel) ifTrue: [ 
		(aVerifiedObject type = OPBPMNNodeType Error) ifTrue: [ 
		counter := 0.
		aVerifiedObject owner elements do: [ :each | (
			(each isKindOf: OPBPMNEndEventModel) ifTrue: [ 
				(each type = OPBPMNNodeType Error) ifTrue: [
				
				counter := 1 ]]) ].
		counter = 0 ifTrue: [ 
				^ { (OPBPMNValidationMessageWarning
					   createFor: aVerifiedObject
					   withValidation: self
					   withText: '(BE03) ', aVerifiedObject class name
						   ,
						   ' should have pair Error End Event in Sub-Process.') } ] ]].
	^ {  }
]
