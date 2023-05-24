Class {
	#name : #BE02OneSequenceFlow,
	#superclass : #OPBPMNValidation,
	#category : #'OpenPonk-BPMN-Validation-Validation-Classes'
}

{ #category : #'as yet unclassified' }
BE02OneSequenceFlow class >> validateClass [
	^ OPBPMNBoundaryEventModel.
]

{ #category : #verification }
BE02OneSequenceFlow >> validateObject: aVerifiedObject withModel: aVerifiedModel [

	(aVerifiedObject isKindOf: OPBPMNBoundaryEventModel) ifTrue: [ 
		(aVerifiedObject outgoing size) ~= 1 ifTrue: [ 
			((aVerifiedObject type = OPBPMNNodeType CatchCompensation)
			| (aVerifiedObject type = OPBPMNNodeType Compensation))
			 ifFalse: [ 
				^ { (OPBPMNValidationMessageError
					   createFor: aVerifiedObject
					   withValidation: self
					   withText: '(BE02) ', aVerifiedObject class name
						   ,
						   ' must have exactly one outgoing Sequence Flow (except Compensation type).') } ] ] ].
	^ {  }
]
