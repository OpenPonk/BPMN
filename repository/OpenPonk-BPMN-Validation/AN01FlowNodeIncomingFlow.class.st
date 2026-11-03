"
I am a validation rule verifying that standard flow nodes have at least one incoming sequence flow, ensuring the process path is reachable.
"
Class {
	#name : 'AN01FlowNodeIncomingFlow',
	#superclass : 'OPBPMNValidation',
	#category : 'OpenPonk-BPMN-Validation-Validation-Classes',
	#package : 'OpenPonk-BPMN-Validation',
	#tag : 'Validation-Classes'
}

{ #category : 'accessing' }
AN01FlowNodeIncomingFlow class >> validateClass [
	^ OPBPMNFlowNodeModel.
]

{ #category : 'verification' }
AN01FlowNodeIncomingFlow >> validateObject: aVerifiedObject withModel: aVerifiedModel [
	| hasIncomingSequenceFlow |
	(aVerifiedObject isKindOf: OPBPMNFlowNodeModel) ifFalse: [ ^ {  } ].
	(aVerifiedObject isKindOf: OPBPMNStartEventModel) ifTrue: [ ^ {  } ].
	((aVerifiedObject isKindOf: OPBPMNIntermediateEventModel) and: [
		aVerifiedObject type = OPBPMNNodeType Link ]) ifTrue: [ ^ {  } ].
	hasIncomingSequenceFlow := aVerifiedObject incoming anySatisfy: [ :eachFlow |
		eachFlow isKindOf: OPBPMNFlowModel ].
	((self isCompensationActivity: aVerifiedObject)
		or: [ self isEventSubProcess: aVerifiedObject ]) ifTrue: [
		hasIncomingSequenceFlow ifFalse: [ ^ {  } ].
		^ { (OPBPMNValidationMessageError
			createFor: aVerifiedObject
			withValidation: self
			withText: '(AN01) ' , aVerifiedObject class name
				, ' used as Compensation or Event Sub-Process cannot have incoming Sequence Flow.') } ].
	((aVerifiedObject owner isKindOf: OPBPMNSubProcessModel) and: [
		aVerifiedObject owner type = OPBPMNNodeType MarkerAdhoc ]) ifTrue: [ ^ {  } ].
	hasIncomingSequenceFlow ifTrue: [ ^ {  } ].
	^ { (OPBPMNValidationMessageError
		createFor: aVerifiedObject
		withValidation: self
		withText: '(AN01) ' , aVerifiedObject class name
			, ' must have incoming Sequence Flow.') }
]
