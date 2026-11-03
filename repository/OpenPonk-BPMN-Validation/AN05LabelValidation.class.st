"
I am a validation rule ensuring that essential BPMN elements possess descriptive text labels for process clarity.
"
Class {
	#name : 'AN05LabelValidation',
	#superclass : 'OPBPMNValidation',
	#category : 'OpenPonk-BPMN-Validation-Validation-Classes',
	#package : 'OpenPonk-BPMN-Validation',
	#tag : 'Validation-Classes'
}

{ #category : 'accessing' }
AN05LabelValidation class >> validateClass [
	^ OPBPMNSemanticNodeModel.
]

{ #category : 'verification' }
AN05LabelValidation >> validateObject: aVerifiedObject withModel: aVerifiedModel [
	| requiresLabel outgoingSequenceFlows |
	(aVerifiedObject isKindOf: OPBPMNSemanticNodeModel) ifFalse: [ ^ {  } ].
	requiresLabel := true.
	((aVerifiedObject isKindOf: OPBPMNStartEventModel) and: [
		aVerifiedObject type = OPBPMNNodeType None ]) ifTrue: [
		requiresLabel := false ].
	(aVerifiedObject isKindOf: OPBPMNGatewayModel) ifTrue: [
		outgoingSequenceFlows := aVerifiedObject outgoing select: [ :eachFlow |
			eachFlow isKindOf: OPBPMNFlowModel ].
		(aVerifiedObject type = OPBPMNNodeType Parallel
			or: [ aVerifiedObject type = OPBPMNNodeType Eventbased
			or: [ outgoingSequenceFlows size <= 1 ] ]) ifTrue: [
			requiresLabel := false ] ].
	(requiresLabel and: [
		aVerifiedObject name isNil or: [ aVerifiedObject name trimBoth isEmpty ] ]) ifTrue: [
		^ { (OPBPMNValidationMessageWarning
			createFor: aVerifiedObject
			withValidation: self
			withText: '(AN05) ' , aVerifiedObject class name , ' should be labeled.') } ].
	^ {  }
]
