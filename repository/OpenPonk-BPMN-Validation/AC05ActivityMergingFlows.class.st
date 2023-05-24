Class {
	#name : #AC05ActivityMergingFlows,
	#superclass : #OPBPMNValidation,
	#category : #'OpenPonk-BPMN-Validation-Validation-Classes'
}

{ #category : #'as yet unclassified' }
AC05ActivityMergingFlows class >> validateClass [
	^ OPBPMNActivityModel.
]

{ #category : #verification }
AC05ActivityMergingFlows >> validateObject: aVerifiedObject withModel: aVerifiedModel [
	| counterIn counterOut |
	(aVerifiedObject isKindOf: OPBPMNActivityModel) ifTrue: [ 
		counterIn := 0.
		counterOut := 0.
		aVerifiedObject incoming do: [ :each | (
			(each isKindOf: OPBPMNFlowModel) 
				ifTrue: [  counterIn := counterIn + 1 ]) ].
		aVerifiedObject outgoing do: [ :each | (
			(each isKindOf: OPBPMNFlowModel) 
				ifTrue: [  counterOut := counterOut + 1 ]) ].
		(counterIn > 1) | (counterOut > 1) ifTrue: [ 
			^ { (OPBPMNValidationMessageWarning
				   createFor: aVerifiedObject
				   withValidation: self
				   withText: '(AC05) ' , aVerifiedObject class name
					   , ' should not be used for merging or splitting flows.') } ] ].
	^ {  }
]
