"
I orchestrate the execution of BPMN validation rules. I gather the diagram elements, apply the corresponding validation checks, and aggregate the results.
"
Class {
	#name : 'OPBPMNValidationController',
	#superclass : 'Object',
	#category : 'OpenPonk-BPMN-Validation-Controllers',
	#package : 'OpenPonk-BPMN-Validation',
	#tag : 'Controllers'
}

{ #category : 'as yet unclassified' }
OPBPMNValidationController >> getValidateObjects: aValidateModel [
| verifiedObjects |
	verifiedObjects := aValidateModel nodes.
	
	^ verifiedObjects.
	
]

{ #category : 'as yet unclassified' }
OPBPMNValidationController >> getValidations [

	^ (self packageOrganizer packageNamed: 'OpenPonk-BPMN-Validation')
		  definedClasses select: [ :class |
		  class packageTag name = 'Validation-Classes' ]
]

{ #category : 'private' }
OPBPMNValidationController >> isActivityNode: aModelObject [
	^ (aModelObject isKindOf: OPBPMNActivityModel)
		or: [ (aModelObject isKindOf: OPBPMNSubProcessModel)
		or: [ aModelObject isKindOf: OPBPMNCollapsedSubProcessModel ] ]
]

{ #category : 'validating' }
OPBPMNValidationController >> validate: aValidateModel [
	| validateObjects validations results rootModel |
	validateObjects := self getValidateObjects: aValidateModel.
	validations := self getValidations select: [ :validation |
		OPBPMNValidationFrameworkSettings getInstance
			getSettingFor: validation ].
	results := OPBPMNValidationResults new.
	rootModel := (aValidateModel respondsTo: #rootOwner)
		ifTrue: [ aValidateModel rootOwner ]
		ifFalse: [ aValidateModel ].

	(aValidateModel isKindOf: OPBPMNModel) ifTrue: [
		results addResults: (self validateProcess: aValidateModel) ].

	validateObjects do: [ :validateObject |
		(self getValidateObjects: validateObject) isNotEmpty ifTrue: [
			results addResults: (self validate: validateObject) ].
		self
			validateSingleObject: validateObject
			withValidations: validations
			withModel: rootModel
			withResults: results ].
	^ results
]

{ #category : 'private' }
OPBPMNValidationController >> validateExpandedSubProcessesIn: aValidateModel into: aValidationResults [
	| subProcesses |
	subProcesses := aValidateModel allElements select: [ :eachElement |
		(eachElement isKindOf: OPBPMNSubProcessModel) and: [
			eachElement type ~= OPBPMNNodeType MarkerAdhoc ] ].
	subProcesses do: [ :eachSubProcess |
		| innerElements |
		innerElements := eachSubProcess elements reject: [ :eachChild |
			(eachChild isKindOf: OPBPMNEdgeModel) or: [
				eachChild isKindOf: OPBPMNBoundaryEventModel ] ].
		self
			validateProcessElements: innerElements
			forTarget: eachSubProcess
			into: aValidationResults ]
]

{ #category : 'validating' }
OPBPMNValidationController >> validateProcess: aValidateModel [
	| results directObjects pools rootElements rootProcessElements whiteBoxPools hasBlackBoxCollaboration |
	results := OPBPMNValidationResults new.
	directObjects := self getValidateObjects: aValidateModel.
	pools := directObjects select: [ :eachObject | eachObject isKindOf: OPBPMNPoolModel ].
	rootElements := directObjects reject: [ :eachObject | eachObject isKindOf: OPBPMNPoolModel ].
	rootProcessElements := rootElements select: [ :eachObject |
		(eachObject isKindOf: OPBPMNFlowNodeModel)
			or: [ eachObject isKindOf: OPBPMNDataObjectModel ] ].

	self validateExpandedSubProcessesIn: aValidateModel into: results.

	pools ifEmpty: [
		self
			validateProcessElements: rootProcessElements
			forTarget: aValidateModel
			into: results.
		^ results ].

	rootProcessElements ifNotEmpty: [
		results addResults: (PR2347ProcessErrors PR04AllInsidePool: aValidateModel) ].

	whiteBoxPools := pools reject: [ :eachPool | eachPool isBlackBox ].
	(whiteBoxPools isEmpty and: [ rootProcessElements isEmpty ]) ifTrue: [
		hasBlackBoxCollaboration := pools size > 1 and: [
			pools anySatisfy: [ :eachPool |
				(eachPool incoming , eachPool outgoing) anySatisfy: [ :eachEdge |
					eachEdge isKindOf: OPBPMNMessageFlowModel ] ] ].
		hasBlackBoxCollaboration ifFalse: [
			pools do: [ :eachEmptyPool |
				self
					validateProcessElements: #( )
					forTarget: eachEmptyPool
					into: results ] ].
		^ results ].

	whiteBoxPools do: [ :eachPool |
		| poolTopLevelElements |
		poolTopLevelElements := (eachPool elements reject: [ :eachChild |
			eachChild isKindOf: OPBPMNLaneModel ])
			, (eachPool lanes flatCollect: [ :eachLane | eachLane elements ]).
		self
			validateProcessElements: poolTopLevelElements
			forTarget: eachPool
			into: results ].
	^ results
]

{ #category : 'private' }
OPBPMNValidationController >> validateProcessElements: aCollectionOfElements forTarget: aTargetModel into: aValidationResults [
	| hasAnyActivity hasStartEvent hasEndEvent |
	hasAnyActivity := aCollectionOfElements anySatisfy: [ :eachElement |
		self isActivityNode: eachElement ].
	hasStartEvent := aCollectionOfElements anySatisfy: [ :eachElement |
		eachElement isKindOf: OPBPMNStartEventModel ].
	hasEndEvent := aCollectionOfElements anySatisfy: [ :eachElement |
		eachElement isKindOf: OPBPMNEndEventModel ].
	hasAnyActivity ifFalse: [
		aValidationResults addResults: (PR2347ProcessErrors PR02ActivityCounterError: aTargetModel) ].
	(hasStartEvent and: [ hasEndEvent ]) ifFalse: [
		aValidationResults addResults: (PR2347ProcessErrors PR07StartCounterError: aTargetModel) ]
]

{ #category : 'as yet unclassified' }
OPBPMNValidationController >> validateSingleObject: aValidateObject withValidations: aValidations withModel: aValidatedModel withResults: aValidationsResults [

	^ aValidations do: [ :validations | 
		  aValidationsResults addResults:
			  (validations validate: aValidateObject withModel: aValidatedModel) ]
]
