"
I am the abstract base class for specific BPMN validation rules. I define the interface for validating diagram objects against the BPMN specification.
"
Class {
	#name : 'OPBPMNValidation',
	#superclass : 'Object',
	#category : 'OpenPonk-BPMN-Validation-Settings',
	#package : 'OpenPonk-BPMN-Validation',
	#tag : 'Settings'
}

{ #category : 'testing' }
OPBPMNValidation class >> canValidate: aVerifiedObject [
	"^ aVerifiedObject class = self validateClass."
	^ aVerifiedObject isKindOf: self validateClass.
]

{ #category : 'instance creation' }
OPBPMNValidation class >> new [
	^ self shouldNotImplement.
]

{ #category : 'as yet unclassified' }
OPBPMNValidation class >> validate: aVerifiedObject withModel: aVerifiedModel [
	| verification |
	(self canValidate: aVerifiedObject) ifFalse: [ ^ {} ].
	verification := self basicNew.
	^ verification validateObject: aVerifiedObject withModel: aVerifiedModel.
]

{ #category : 'accessing' }
OPBPMNValidation class >> validateClass [
	^ nil.
]

{ #category : 'testing' }
OPBPMNValidation >> isCompensationActivity: aModelObject [
	aModelObject type = OPBPMNNodeType MarkerCompensation ifTrue: [ ^ true ].
	^ aModelObject incoming anySatisfy: [ :eachEdge |
		(eachEdge isKindOf: OPBPMNAssociationModel) and: [
			(eachEdge source isKindOf: OPBPMNBoundaryEventModel) and: [
				eachEdge source type = OPBPMNNodeType CatchCompensation
					or: [ eachEdge source type = OPBPMNNodeType Compensation ] ] ] ]
]

{ #category : 'testing' }
OPBPMNValidation >> isEventSubProcess: aModelObject [
	| eventStartTypes hasSequenceFlow |
	(aModelObject isKindOf: OPBPMNSubProcessModel) ifFalse: [ ^ false ].
	eventStartTypes := {
		OPBPMNNodeType Error .
		OPBPMNNodeType Escalation .
		OPBPMNNodeType Compensation }.
	(aModelObject elements anySatisfy: [ :eachChild |
		(eachChild isKindOf: OPBPMNStartEventModel) and: [
			eachChild isNonInterrupting or: [
				eventStartTypes includes: eachChild type ] ] ]) ifTrue: [ ^ true ].
	hasSequenceFlow := (aModelObject incoming , aModelObject outgoing) anySatisfy: [ :eachFlow |
		eachFlow isKindOf: OPBPMNFlowModel ].
	hasSequenceFlow ifTrue: [ ^ false ].
	^ aModelObject elements anySatisfy: [ :eachChild |
		(eachChild isKindOf: OPBPMNStartEventModel) and: [
			eachChild type ~= OPBPMNNodeType None ] ]
]

{ #category : 'verification' }
OPBPMNValidation >> validateObject: aVerifiedObject withModel: aVerifiedModel [
	self subclassResponsibility.
]
