"
I am a validation rule ensuring that an activity or gateway defines at most one default outgoing sequence flow.
"
Class {
	#name : 'AN03MaxOneDefaultFlow',
	#superclass : 'OPBPMNValidation',
	#category : 'OpenPonk-BPMN-Validation-Validation-Classes',
	#package : 'OpenPonk-BPMN-Validation',
	#tag : 'Validation-Classes'
}

{ #category : 'accessing' }
AN03MaxOneDefaultFlow class >> validateClass [
	^ OPBPMNFlowNodeModel.
]

{ #category : 'verification' }
AN03MaxOneDefaultFlow >> validateObject: aVerifiedObject withModel: aVerifiedModel [

	| aCounter |
	aCounter := 0.
	(aVerifiedObject isKindOf: OPBPMNFlowNodeModel) ifFalse: [ ^ {  } ].
	aVerifiedObject outgoing ifEmpty: [ ^ {  } ].
	aVerifiedObject outgoing do: [ :each |
			(each isKindOf: OPBPMNFlowModel) ifTrue: [
				each type = 'Default' ifTrue: [ aCounter := aCounter + 1 ] ] ].
	(aCounter < 2 and: [
		 aVerifiedObject outgoing size > 1 or: [ aCounter isZero ] ])
		ifTrue: [ ^ {  } ].
		
	^ { (OPBPMNValidationMessageError
		   createFor: aVerifiedObject
		   withValidation: self
		   withText: '(AN03) ' , aVerifiedObject class name
			   , ' could not have more than one Default Sequence Flow.') }
]
