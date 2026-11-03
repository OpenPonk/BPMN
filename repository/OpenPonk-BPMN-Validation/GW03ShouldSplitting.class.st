"
I am a validation rule recommending that nodes with multiple outgoing flows should use a splitting gateway to clarify branching logic.
"
Class {
	#name : 'GW03ShouldSplitting',
	#superclass : 'OPBPMNValidation',
	#category : 'OpenPonk-BPMN-Validation-Validation-Classes',
	#package : 'OpenPonk-BPMN-Validation',
	#tag : 'Validation-Classes'
}

{ #category : 'accessing' }
GW03ShouldSplitting class >> validateClass [
	^ OPBPMNGatewayModel.
]

{ #category : 'verification' }
GW03ShouldSplitting >> validateObject: aVerifiedObject withModel: aVerifiedModel [
	| incomingSequenceFlows outgoingSequenceFlows |
	(aVerifiedObject isKindOf: OPBPMNGatewayModel) ifFalse: [ ^ {  } ].
	incomingSequenceFlows := aVerifiedObject incoming select: [ :each | each isKindOf: OPBPMNFlowModel ].
	outgoingSequenceFlows := aVerifiedObject outgoing select: [ :each | each isKindOf: OPBPMNFlowModel ].
	(incomingSequenceFlows size > 1 and: [ outgoingSequenceFlows size > 1 ]) ifTrue: [
		^ { (OPBPMNValidationMessageWarning
			createFor: aVerifiedObject
			withValidation: self
			withText: '(GW03) ' , aVerifiedObject class name
				, ' should be either merging or splitting.') } ].
	^ {  }
]
