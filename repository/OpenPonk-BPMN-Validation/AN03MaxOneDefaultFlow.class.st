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
	| outgoingSequenceFlows defaultCount canHaveDefaultFlow |
	(aVerifiedObject isKindOf: OPBPMNFlowNodeModel) ifFalse: [ ^ {  } ].
	outgoingSequenceFlows := aVerifiedObject outgoing select: [ :eachFlow |
		eachFlow isKindOf: OPBPMNFlowModel ].
	outgoingSequenceFlows ifEmpty: [ ^ {  } ].
	defaultCount := (outgoingSequenceFlows select: [ :eachFlow | eachFlow type = 'Default' ]) size.
	defaultCount isZero ifTrue: [ ^ {  } ].
	canHaveDefaultFlow := (aVerifiedObject isKindOf: OPBPMNEventModel) not and: [
		((aVerifiedObject isKindOf: OPBPMNGatewayModel) and: [
			aVerifiedObject type = OPBPMNNodeType Parallel
				or: [ aVerifiedObject type = OPBPMNNodeType Eventbased ] ]) not ].
	(canHaveDefaultFlow and: [ defaultCount = 1 and: [ outgoingSequenceFlows size > 1 ] ])
		ifTrue: [ ^ {  } ].
	^ { (OPBPMNValidationMessageError
		createFor: aVerifiedObject
		withValidation: self
		withText: '(AN03) ' , aVerifiedObject class name
			, ' could not have more than one Default Sequence Flow.') }
]
