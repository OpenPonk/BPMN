"
Warns when a data object or text annotation is isolated from the process graph without any connecting data flow or association.
"
Class {
	#name : 'AN07UnconnectedArtifactOrData',
	#superclass : 'OPBPMNValidation',
	#category : 'OpenPonk-BPMN-Validation-Validation-Classes',
	#package : 'OpenPonk-BPMN-Validation',
	#tag : 'Validation-Classes'
}

{ #category : 'testing' }
AN07UnconnectedArtifactOrData class >> canValidate: aVerifiedObject [
	^ (aVerifiedObject isKindOf: OPBPMNDataObjectModel)
		or: [ aVerifiedObject isKindOf: OPBPMNAnnotationModel ]
]

{ #category : 'accessing' }
AN07UnconnectedArtifactOrData class >> validateClass [
	^ OPBPMNNodeModel
]

{ #category : 'verification' }
AN07UnconnectedArtifactOrData >> validateObject: aVerifiedObject withModel: aVerifiedModel [
	| hasConnection |
	(self class canValidate: aVerifiedObject) ifFalse: [ ^ {  } ].
	(aVerifiedObject isKindOf: OPBPMNDataObjectModel) ifTrue: [
		hasConnection := (aVerifiedObject incoming , aVerifiedObject outgoing) anySatisfy: [ :eachEdge |
			eachEdge isKindOf: OPBPMNDataFlowModel ].
		hasConnection ifFalse: [
			^ { (OPBPMNValidationMessageWarning
				createFor: aVerifiedObject
				withValidation: self
				withText: '(AN07) ' , aVerifiedObject class name
					, ' should be connected to a process element via Data Flow.') } ] ].
	(aVerifiedObject isKindOf: OPBPMNAnnotationModel) ifTrue: [
		hasConnection := (aVerifiedObject incoming , aVerifiedObject outgoing) anySatisfy: [ :eachEdge |
			eachEdge isKindOf: OPBPMNAssociationModel ].
		hasConnection ifFalse: [
			^ { (OPBPMNValidationMessageWarning
				createFor: aVerifiedObject
				withValidation: self
				withText: '(AN07) ' , aVerifiedObject class name
					, ' should be connected to a diagram element via Association.') } ] ].
	^ {  }
]
