"
I am a validation rule ensuring that a boundary event has exactly one outgoing sequence flow to define its exception or compensation path.
"
Class {
	#name : 'BE02OneSequenceFlow',
	#superclass : 'OPBPMNValidation',
	#category : 'OpenPonk-BPMN-Validation-Validation-Classes',
	#package : 'OpenPonk-BPMN-Validation',
	#tag : 'Validation-Classes'
}

{ #category : 'accessing' }
BE02OneSequenceFlow class >> validateClass [
	^ OPBPMNBoundaryEventModel.
]

{ #category : 'verification' }
BE02OneSequenceFlow >> validateObject: aVerifiedObject withModel: aVerifiedModel [
	| outgoingSequenceFlows isCompensation hasCompensationAssociation |
	(aVerifiedObject isKindOf: OPBPMNBoundaryEventModel) ifFalse: [ ^ {  } ].
	outgoingSequenceFlows := aVerifiedObject outgoing select: [ :eachFlow |
		eachFlow isKindOf: OPBPMNFlowModel ].
	isCompensation := aVerifiedObject type = OPBPMNNodeType CatchCompensation
		or: [ aVerifiedObject type = OPBPMNNodeType Compensation ].
	isCompensation ifTrue: [
		outgoingSequenceFlows ifNotEmpty: [
			^ { (OPBPMNValidationMessageError
				createFor: aVerifiedObject
				withValidation: self
				withText: '(BE02) ' , aVerifiedObject class name
					, ' of Compensation type cannot have outgoing Sequence Flow.') } ].
		hasCompensationAssociation := aVerifiedObject outgoing anySatisfy: [ :eachEdge |
			(eachEdge isKindOf: OPBPMNAssociationModel) and: [
				(eachEdge target isKindOf: OPBPMNActivityModel)
					or: [ (eachEdge target isKindOf: OPBPMNSubProcessModel)
					or: [ eachEdge target isKindOf: OPBPMNCollapsedSubProcessModel ] ] ] ].
		hasCompensationAssociation ifTrue: [ ^ {  } ].
		^ { (OPBPMNValidationMessageError
			createFor: aVerifiedObject
			withValidation: self
			withText: '(BE02) ' , aVerifiedObject class name
				, ' of Compensation type must have outgoing Association to a compensation Activity.') } ].
	outgoingSequenceFlows size ~= 1 ifTrue: [
		^ { (OPBPMNValidationMessageError
			createFor: aVerifiedObject
			withValidation: self
			withText: '(BE02) ' , aVerifiedObject class name
				, ' must have exactly one outgoing Sequence Flow (except Compensation type).') } ].
	^ {  }
]
