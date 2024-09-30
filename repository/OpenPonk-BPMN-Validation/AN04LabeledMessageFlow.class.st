Class {
	#name : 'AN04LabeledMessageFlow',
	#superclass : 'OPBPMNValidation',
	#category : 'OpenPonk-BPMN-Validation-Validation-Classes',
	#package : 'OpenPonk-BPMN-Validation',
	#tag : 'Validation-Classes'
}

{ #category : 'as yet unclassified' }
AN04LabeledMessageFlow class >> validateClass [
	^ OPBPMNNodeModel.
]

{ #category : 'verification' }
AN04LabeledMessageFlow >> validateObject: aVerifiedObject withModel: aVerifiedModel [

	| counter |
	counter := 0.
	aVerifiedObject outgoing do: [ :each | 
		(each isKindOf: OPBPMNMessageFlowModel) ifTrue: [ 
			(each name = '') ifTrue: [ counter := 1 ] ] ].
	counter = 1 ifTrue: [ 
		^ { (OPBPMNValidationMessageWarning
			   createFor: aVerifiedObject
			   withValidation: self
			   withText: '(AN04) ' , aVerifiedObject class name
				   , ' outgoing Message Flow should be labeled.') } ].
	^ {  }
]
