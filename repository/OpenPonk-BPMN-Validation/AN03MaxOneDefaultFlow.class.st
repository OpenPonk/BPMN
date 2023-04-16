Class {
	#name : #AN03MaxOneDefaultFlow,
	#superclass : #OPBPMNValidation,
	#category : #'OpenPonk-BPMN-Validation-Validation-Classes'
}

{ #category : #'as yet unclassified' }
AN03MaxOneDefaultFlow class >> validateClass [
	^ OPBPMNFlowNodeModel.
]

{ #category : #verification }
AN03MaxOneDefaultFlow >> validateObject: aVerifiedObject withModel: aVerifiedModel [

	(aVerifiedObject isKindOf: OPBPMNFlowNodeModel) ifTrue: [ 
		aVerifiedObject outgoing size = 1 ifTrue: [ 
			aVerifiedObject outgoing do: [ :each | 
				(each isKindOf: OPBPMNFlowModel) ifTrue: [ 
					each type = 'Conditional' ifTrue: [ 
						^ { (OPBPMNValidationMessageError
							   createFor: aVerifiedObject
							   withValidation: self
							   withText: '(AN03) ' , aVerifiedObject class name
								   , ' could not have more than one Default Sequence Flow.') } ] ] ] ] ].
	^ {  }
]
