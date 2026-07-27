Class {
	#name : 'OPBPMNValidationControllerTest',
	#superclass : 'TestCase',
	#category : 'OpenPonk-BPMN-Validation-Tests',
	#package : 'OpenPonk-BPMN-Validation',
	#tag : 'Tests'
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
	self deny: validations isEmpty.
	self assert: (validations allSatisfy: [ :validationClass |
			 validationClass packageTag name = 'Validation-Classes' ])
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

	| activity array model controller results dataO startE |
	activity := OPBPMNActivityModel new.
	dataO := OPBPMNDataObjectModel new.
	startE := OPBPMNStartEventModel new.
	array := {
		         activity.
		         dataO }.
	model := OPBPMNModel new.
	model addAll: array.
	controller := OPBPMNValidationController new.
	results := controller validateProcess: model.
	self assert: (results isKindOf: OPBPMNValidationResults).
	self deny: (results hasErrors: activity).
	self deny: (results hasErrors: dataO).
	self assert: (results hasWarnings: model).
	self deny: (results hasErrors: model).

	model add: startE.
	results := controller validateProcess: model.
	self assert: (results isKindOf: OPBPMNValidationResults).
	self deny: (results hasErrors: activity).
	self deny: (results hasErrors: startE).
	self deny: (results hasWarnings: model).
	self deny: (results hasErrors: model)
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
