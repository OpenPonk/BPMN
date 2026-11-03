"
I am a validation rule that warns when an activity has multiple incoming sequence flows, recommending the use of a merging gateway instead to clarify execution semantics.
"
Class {
	#name : 'AC05ActivityMergingFlows',
	#superclass : 'OPBPMNValidation',
	#category : 'OpenPonk-BPMN-Validation-Validation-Classes',
	#package : 'OpenPonk-BPMN-Validation',
	#tag : 'Validation-Classes'
}

{ #category : 'testing' }
AC05ActivityMergingFlows class >> canValidate: aVerifiedObject [
	^ (super canValidate: aVerifiedObject)
		or: [ (aVerifiedObject isKindOf: OPBPMNSubProcessModel)
		or: [ aVerifiedObject isKindOf: OPBPMNCollapsedSubProcessModel ] ]
]

{ #category : 'accessing' }
AC05ActivityMergingFlows class >> validateClass [
	^ OPBPMNActivityModel.
]

{ #category : 'verification' }
AC05ActivityMergingFlows >> validateObject: aVerifiedObject withModel: aVerifiedModel [
	| incomingSequenceFlows outgoingSequenceFlows |
	(self class canValidate: aVerifiedObject) ifFalse: [ ^ {  } ].
	incomingSequenceFlows := aVerifiedObject incoming select: [ :eachFlow |
		eachFlow isKindOf: OPBPMNFlowModel ].
	outgoingSequenceFlows := aVerifiedObject outgoing select: [ :eachFlow |
		eachFlow isKindOf: OPBPMNFlowModel ].
	(incomingSequenceFlows size > 1 or: [ outgoingSequenceFlows size > 1 ]) ifTrue: [
		^ { (OPBPMNValidationMessageWarning
			createFor: aVerifiedObject
			withValidation: self
			withText: '(AC05) ' , aVerifiedObject class name
				, ' should not be used for merging or splitting flows.') } ].
	^ {  }
]
