Class {
	#name : #AN06OnlyConditionalFlow,
	#superclass : #OPBPMNValidation,
	#category : #'OpenPonk-BPMN-Validation-Validation-Classes'
}

{ #category : #'as yet unclassified' }
AN06OnlyConditionalFlow class >> validateClass [
	^ OPBPMNFlowNodeModel.
]

{ #category : #verification }
AN06OnlyConditionalFlow >> validateObject: aVerifiedObject withModel: aVerifiedModel [

	(aVerifiedObject isKindOf: OPBPMNFlowNodeModel) ifTrue: [ 
		aVerifiedObject outgoing size = 1 ifTrue: [ 
			aVerifiedObject outgoing do: [ :each | 
				(each isKindOf: OPBPMNFlowModel) ifTrue: [ 
					each type = 'Conditional' ifTrue: [ 
						^ { (OPBPMNValidationMessageError
							   createFor: aVerifiedObject
							   withValidation: self
							   withText: '(AN06) ' , aVerifiedObject class name
								   , ' could not have outgoing only Conditional Flow.') } ] ] ] ] ].
	^ {  }
]
