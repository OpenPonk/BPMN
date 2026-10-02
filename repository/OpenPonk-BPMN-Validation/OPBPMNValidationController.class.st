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

{ #category : 'validating' }
OPBPMNValidationController >> validate: aValidateModel [

	| validateObjects validations results |
	
	validateObjects := self getValidateObjects: aValidateModel.
	validations := self getValidations select: [ :validation | 
					   OPBPMNValidationFrameworkSettings getInstance 
						   getSettingFor: validation ].
	results := OPBPMNValidationResults new.
	
	(aValidateModel isKindOf: OPBPMNModel) ifTrue: [ results addResults: (self validateProcess: aValidateModel) ].
	
	validateObjects do: [ :validateObject | 
		((validateObject isKindOf: OPBPMNPoolModel)
			or: [ (validateObject isKindOf: OPBPMNLaneModel)
			or: [ validateObject isKindOf: OPBPMNSubProcessModel ] ]) ifTrue: [ 
				results addResults: (self validate: validateObject) ].
		self
			validateSingleObject: validateObject
			withValidations: validations
			withModel: validateObjects
			withResults: results ].
	^ results
]

{ #category : 'validating' }
OPBPMNValidationController >> validateProcess: aValidateModel [

	| results validateObjects startEventCounter poolCounter activityCounter activityAlone |
	results := OPBPMNValidationResults new.
	activityAlone := 0.
	activityCounter := 0.
	poolCounter := 0.
	startEventCounter := 0.

	validateObjects := self getValidateObjects: aValidateModel.

	validateObjects do: [ :validateObject | 
		(validateObject isKindOf: OPBPMNPoolModel)
			ifTrue: [ 
				| poolElements |
				poolElements := validateObject hasLanes
					ifTrue: [ validateObject lanes flatCollect: [ :eachLane | eachLane elements ] ]
					ifFalse: [ validateObject elements ].
				(poolElements anySatisfy: [ :each | each isKindOf: OPBPMNActivityModel ])
					ifTrue: [ 
						poolCounter := poolCounter + 1.
						activityCounter := poolCounter ].
				poolElements do: [ :each | 
					(each isKindOf: OPBPMNStartEventModel) ifTrue: [ 
						startEventCounter := startEventCounter + 1 ] ] ]
			ifFalse: [ 
				(validateObject isKindOf: OPBPMNActivityModel) ifTrue: [ 
					activityAlone := 1 ].
				(validateObject isKindOf: OPBPMNStartEventModel) ifTrue: [ 
					startEventCounter := startEventCounter + 1 ] ] ].

	activityAlone = 0 & (activityCounter = 0) ifTrue: [ 
		results addResults: (PR2347ProcessErrors PR02ActivityCounterError: aValidateModel) ].
	activityAlone = 1 & (activityCounter > 0) | (activityCounter > 1)
		ifTrue: [ 
			results addResults: (PR2347ProcessErrors PR03MoreProcesses: aValidateModel) ]
		ifFalse: [ 
			activityAlone = 1 & (poolCounter > 0) ifTrue: [ 
				results addResults: (PR2347ProcessErrors PR04AllInsidePool: aValidateModel) ] ].
	startEventCounter = 0 ifTrue: [ 
		results addResults: (PR2347ProcessErrors PR07StartCounterError: aValidateModel) ].
	^ results
]

{ #category : 'as yet unclassified' }
OPBPMNValidationController >> validateSingleObject: aValidateObject withValidations: aValidations withModel: aValidatedModel withResults: aValidationsResults [

	^ aValidations do: [ :validations | 
		  aValidationsResults addResults:
			  (validations validate: aValidateObject withModel: aValidatedModel) ]
]
