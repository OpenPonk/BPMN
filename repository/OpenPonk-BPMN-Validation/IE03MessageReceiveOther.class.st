Class {
	#name : #IE03MessageReceiveOther,
	#superclass : #OPBPMNValidation,
	#category : #'OpenPonk-BPMN-Validation-Validation-Classes'
}

{ #category : #'as yet unclassified' }
IE03MessageReceiveOther class >> validateClass [
	^ OPBPMNIntermediateEventModel.
]

{ #category : #verification }
IE03MessageReceiveOther >> validateObject: aVerifiedObject withModel: aVerifiedModel [
	| counter |
	(aVerifiedObject isKindOf: OPBPMNIntermediateEventModel) ifTrue: [ 
		counter := 0.
		aVerifiedObject incoming do: [ :each | (
			(each isKindOf: OPBPMNMessageFlowModel) ifTrue: [ counter := 1 ]) ] ].
		counter = 1 ifTrue: [ 
			aVerifiedObject type = OPBPMNNodeType Receive
			| (aVerifiedObject type = OPBPMNNodeType Multiple) ifFalse: [ 
				^ { (OPBPMNValidationMessageError
					   createFor: aVerifiedObject
					   withValidation: self
					   withText: '(IE03) ', aVerifiedObject class name
						   ,
						   ' can have incoming Message Flow only as Message or Multiple type.') } ] ].
	^ {  }
]
