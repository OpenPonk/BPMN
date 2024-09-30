Class {
	#name : 'IE01MessageReceive',
	#superclass : 'OPBPMNValidation',
	#category : 'OpenPonk-BPMN-Validation-Validation-Classes',
	#package : 'OpenPonk-BPMN-Validation',
	#tag : 'Validation-Classes'
}

{ #category : 'as yet unclassified' }
IE01MessageReceive class >> validateClass [
	^ OPBPMNIntermediateEventModel.
]

{ #category : 'verification' }
IE01MessageReceive >> validateObject: aVerifiedObject withModel: aVerifiedModel [

	| counter |
	(aVerifiedObject isKindOf: OPBPMNIntermediateEventModel) ifTrue: [ 
		aVerifiedObject type = OPBPMNNodeType Receive ifTrue: [ 
			counter := 0.
			aVerifiedObject incoming do: [ :each | (
				(each isKindOf: OPBPMNMessageFlowModel) ifTrue: [ counter := 1 ]) ] ].
			counter = 0 ifTrue: [ 
			^ { (OPBPMNValidationMessageError
				   createFor: aVerifiedObject
				   withValidation: self
				   withText: '(IE01) ' , aVerifiedObject class name
					   ,
					   ' of Message Receive type has to have incoming Message Flow.') } ] ].
	^ {  }
]
