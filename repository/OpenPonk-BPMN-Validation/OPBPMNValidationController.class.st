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
		  class tags asSet includes: 'Validation-Classes' ]
]

{ #category : 'as yet unclassified' }
OPBPMNValidationController >> validate: aValidateModel [

	| validateObjects validations results |
	
	validateObjects := self getValidateObjects: aValidateModel.
	validations := self getValidations select: [ :validation | 
		               OPBPMNValidationFrameworkSettings getInstance 
			               getSettingFor: validation ].
	results := OPBPMNValidationResults new.
	
	(aValidateModel isKindOf: OPBPMNModel) ifTrue: [ results addResults: (self validateProcess: aValidateModel) ].
	
	validateObjects do: [ :validateObject | 
		(validateObject isKindOf: OPBPMNPoolModel)
		| (validateObject isKindOf: OPBPMNSubProcessModel) ifTrue: [ 
			results addResults: (self validate: validateObject) ].
		self
			validateSingleObject: validateObject
			withValidations: validations
			withModel: validateObjects
			withResults: results ].
	^ results
]

{ #category : 'as yet unclassified' }
OPBPMNValidationController >> validateProcess: aValidateModel [

	| results validateObjects startEventCounter poolCounter activityCounter activityAlone |
	results := OPBPMNValidationResults new.
	activityAlone := 0. "1 alone"
	activityCounter := 0. "1 inOneProcess,  in 2 Processes..."
	poolCounter := 0. "1 oneProcess, 2 moreProcesses"
	startEventCounter := 0. "1 alone, 2 inProcess, 3 inMoreProcesses"

	validateObjects := self getValidateObjects: aValidateModel.

	validateObjects do: [ :validateObject | 
		(validateObject isKindOf: OPBPMNPoolModel)
			ifTrue: [ 
				poolCounter := poolCounter + 1.
				validateObject elements do: [ :each | 
					(each isKindOf: OPBPMNActivityModel) & (activityCounter = 0) 
						ifTrue: [ activityCounter := 1 ].
					(each isKindOf: OPBPMNActivityModel) & (poolCounter > 1)
					& (activityCounter > 0) ifTrue: [ activityCounter := 2 ].
					(each isKindOf: OPBPMNStartEventModel) ifTrue: [ 
						startEventCounter := startEventCounter + 1 ] ] ]
			ifFalse: [ 
				(validateObject isKindOf: OPBPMNActivityModel) ifTrue: [ 
					activityAlone := 1 ].
				(validateObject isKindOf: OPBPMNStartEventModel) ifTrue: [ 
					startEventCounter := startEventCounter + 1 ] ] ].

"Results:"
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
