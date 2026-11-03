"
I am a validation rule verifying that standard flow nodes have at least one outgoing sequence flow, preventing dead ends in the process.
"
Class {
	#name : 'AN02FlowNodeOutgoingFlow',
	#superclass : 'OPBPMNValidation',
	#category : 'OpenPonk-BPMN-Validation-Validation-Classes',
	#package : 'OpenPonk-BPMN-Validation',
	#tag : 'Validation-Classes'
}

{ #category : 'accessing' }
AN02FlowNodeOutgoingFlow class >> validateClass [
	^ OPBPMNFlowNodeModel.
]

{ #category : 'verification' }
AN02FlowNodeOutgoingFlow >> validateObject: aVerifiedObject withModel: aVerifiedModel [
	| hasOutgoingSequenceFlow |
	(aVerifiedObject isKindOf: OPBPMNFlowNodeModel) ifFalse: [ ^ {  } ].
	(aVerifiedObject isKindOf: OPBPMNEndEventModel) ifTrue: [ ^ {  } ].
	((aVerifiedObject isKindOf: OPBPMNIntermediateEventModel) and: [
		aVerifiedObject type = OPBPMNNodeType LinkThrow ]) ifTrue: [ ^ {  } ].
	hasOutgoingSequenceFlow := aVerifiedObject outgoing anySatisfy: [ :eachFlow |
		eachFlow isKindOf: OPBPMNFlowModel ].
	((self isCompensationActivity: aVerifiedObject)
		or: [ self isEventSubProcess: aVerifiedObject ]) ifTrue: [
		hasOutgoingSequenceFlow ifFalse: [ ^ {  } ].
		^ { (OPBPMNValidationMessageError
			createFor: aVerifiedObject
			withValidation: self
			withText: '(AN02) ' , aVerifiedObject class name
				, ' used as Compensation or Event Sub-Process cannot have outgoing Sequence Flow.') } ].
	((aVerifiedObject owner isKindOf: OPBPMNSubProcessModel) and: [
		aVerifiedObject owner type = OPBPMNNodeType MarkerAdhoc ]) ifTrue: [ ^ {  } ].
	hasOutgoingSequenceFlow ifTrue: [ ^ {  } ].
	^ { (OPBPMNValidationMessageError
		createFor: aVerifiedObject
		withValidation: self
		withText: '(AN02) ' , aVerifiedObject class name
			, ' must have outgoing Sequence Flow.') }
]
