"
I am a unit test class verifying the behavior of OPBPMNValidationController. I test the orchestration of validation execution across single objects and entire BPMN processes.
"
Class {
	#name : 'OPBPMNValidationControllerTest',
	#superclass : 'TestCase',
	#category : 'OpenPonk-BPMN-Validation-Tests-Controllers',
	#package : 'OpenPonk-BPMN-Validation-Tests',
	#tag : 'Controllers'
}

{ #category : 'tests' }
OPBPMNValidationControllerTest >> testGetValidatedObjects [

	| controller activity pool subprocess array model |
	controller := OPBPMNValidationController new.

	activity := OPBPMNActivityModel new.
	pool := OPBPMNPoolModel new.
	subprocess := OPBPMNSubProcessModel new.
	model := OPBPMNModel new.
	array := {
		         activity.
		         pool.
		         subprocess } asOrderedCollection.
	model addAll: array.

	self assert: (controller getValidateObjects: model) equals: array
]

{ #category : 'tests' }
OPBPMNValidationControllerTest >> testGetValidations [

	| controller validations |
	controller := OPBPMNValidationController new.
	validations := controller getValidations.
	self assert: (validations isKindOf: Collection).
	self denyEmpty: validations.
	self assert: (validations allSatisfy: [ :validationClass | validationClass packageTag name = 'Validation-Classes' ])
]

{ #category : 'tests' }
OPBPMNValidationControllerTest >> testValidate [

	| activity array model controller results dataO |
	activity := OPBPMNActivityModel new.
	dataO := OPBPMNDataObjectModel new.
	array := {
		         activity.
		         dataO }.
	model := OPBPMNModel new.
	model addAll: array.
	controller := OPBPMNValidationController new.
	results := controller validate: model.
	self assert: (results isKindOf: OPBPMNValidationResults).
	self assert: (results hasErrors: activity).
	self deny: (results hasErrors: dataO).
	self assert: (results hasWarnings: model).
	self deny: (results hasErrors: model)
]

{ #category : 'tests' }
OPBPMNValidationControllerTest >> testValidateProcess [
	| activity array model controller results dataObject startEvent endEvent |
	activity := OPBPMNActivityModel new.
	dataObject := OPBPMNDataObjectModel new.
	startEvent := OPBPMNStartEventModel new.
	endEvent := OPBPMNEndEventModel new.
	array := {
		activity.
		dataObject }.
	model := OPBPMNModel new.
	model addAll: array.
	controller := OPBPMNValidationController new.
	results := controller validateProcess: model.
	self
		assert: (results isKindOf: OPBPMNValidationResults)
		description: 'Validation results must be an instance of OPBPMNValidationResults'.
	self
		deny: (results hasErrors: activity)
		description: 'Process validation alone must not attach activity errors'.
	self
		deny: (results hasErrors: dataObject)
		description: 'Process validation must not report errors on data object'.
	self
		assert: (results hasWarnings: model)
		description: 'Model missing start and end events must have PR07 process warning'.
	self
		deny: (results hasErrors: model)
		description: 'Model with an activity must not have process errors'.

	model add: startEvent.
	model add: endEvent.
	results := controller validateProcess: model.
	self
		assert: (results isKindOf: OPBPMNValidationResults)
		description: 'Validation results must be an instance of OPBPMNValidationResults'.
	self
		deny: (results hasErrors: activity)
		description: 'Activity must not have process errors'.
	self
		deny: (results hasErrors: startEvent)
		description: 'Start event must not have process errors'.
	self
		deny: (results hasWarnings: model)
		description: 'Model with activity, start event, and end event must have no process warnings'.
	self
		deny: (results hasErrors: model)
		description: 'Model with activity, start event, and end event must have no process errors'
]

{ #category : 'tests' }
OPBPMNValidationControllerTest >> testValidateSingleObject [

	| activity array controller results |
	activity := OPBPMNActivityModel new.
	array := { activity }.
	controller := OPBPMNValidationController new.
	results := OPBPMNValidationResults new.
	controller
		validateSingleObject: activity
		withValidations: controller getValidations
		withModel: array
		withResults: results.
	self assert: (results isKindOf: OPBPMNValidationResults).
	self assert: (results hasErrors: activity)
]
