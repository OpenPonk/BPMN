Class {
	#name : #AC01MessageReceive,
	#superclass : #OPBPMNValidation,
	#category : #'OpenPonk-BPMN-Validation-Validation-Classes'
}

{ #category : #'as yet unclassified' }
AC01MessageReceive class >> validateClass [
	^ OPBPMNActivityModel.
]

{ #category : #verification }
AC01MessageReceive >> validateObject: aVerifiedObject withModel: aVerifiedModel [

	| counter |
	(aVerifiedObject isKindOf: OPBPMNActivityModel) ifTrue: [ 
		aVerifiedObject type = OPBPMNNodeType Receive ifTrue: [ 
			counter := 0.
			aVerifiedObject incoming do: [ :each | (
				(each isKindOf: OPBPMNMessageFlowModel) ifTrue: [ counter := 1 ]) ] ].
			counter = 0 ifTrue: [ 
			^ { (OPBPMNValidationMessageError
				   createFor: aVerifiedObject
				   withValidation: self
				   withText: '(AC01) ' , aVerifiedObject class name
					   ,
					   ' of Message Receive type has to have incoming Message Flow.') } ] ].
	^ {  }
]
