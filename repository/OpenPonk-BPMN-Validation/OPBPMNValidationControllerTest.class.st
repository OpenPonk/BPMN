Class {
	#name : 'OPBPMNValidationControllerTest',
	#superclass : 'TestCase',
	#category : 'OpenPonk-BPMN-Validation-Tests',
	#package : 'OpenPonk-BPMN-Validation',
	#tag : 'Tests'
}

{ #category : 'tests' }
OPBPMNValidationControllerTest >> testGetValidatedObjects [
	| controller validations activity pool subprocess array model collection |
	controller := OPBPMNValidationController new.

	activity := OPBPMNActivityModel new.
	pool := OPBPMNPoolModel new.
	subprocess := OPBPMNSubProcessModel new.
	model := OPBPMNModel new.
	array := { activity. pool. subprocess. } asOrderedCollection.
	model addAll: array.
	
	self assert: (controller getValidateObjects: model) equals: array.
]

{ #category : 'tests' }
OPBPMNValidationControllerTest >> testGetValidations [

	| controller validations |
	controller := OPBPMNValidationController new.
	validations := controller getValidations.
	self assert: (validations isKindOf: Collection).
	self assert: validations isEmpty equals: false.

	self
		assert: (validations allSatisfy: [ :validationClass |
				 validationClass packageTag name = 'Validation-Classes' ])
		equals: true
]

{ #category : 'tests' }
OPBPMNValidationControllerTest >> testValidate [
	| activity array model controller results dataO |
	activity := OPBPMNActivityModel new.
	dataO := OPBPMNDataObjectModel  new.
	array :=  { activity. dataO }.
	model := OPBPMNModel new.
	model addAll: array.
	controller := OPBPMNValidationController new.
	results := controller validate: model.
	self assert: (results isKindOf: OPBPMNValidationResults) equals: true.
	self assert: (results hasErrors: activity) equals: true.
	self assert: (results hasErrors: dataO) equals: false.
	self assert: (results hasWarnings: model) equals: true.
	self assert: (results hasErrors: model) equals: false.
]

{ #category : 'tests' }
OPBPMNValidationControllerTest >> testValidateProcess [
	| activity array model controller results dataO startE |
	activity := OPBPMNActivityModel new.
	dataO := OPBPMNDataObjectModel  new.
	startE := OPBPMNStartEventModel new.
	array :=  { activity. dataO }.
	model := OPBPMNModel new.
	model addAll: array.
	controller := OPBPMNValidationController new.
	results := controller validateProcess: model.
	self assert: (results isKindOf: OPBPMNValidationResults) equals: true.
	self assert: (results hasErrors: activity) equals: false.
	self assert: (results hasErrors: dataO) equals: false.
	self assert: (results hasWarnings: model) equals: true.
	self assert: (results hasErrors: model) equals: false.
	
	model add: startE.
	results := controller validateProcess: model.
	self assert: (results isKindOf: OPBPMNValidationResults) equals: true.
	self assert: (results hasErrors: activity) equals: false.
	self assert: (results hasErrors: startE) equals: false.
	self assert: (results hasWarnings: model) equals: false.
	self assert: (results hasErrors: model) equals: false.
	
	
]

{ #category : 'tests' }
OPBPMNValidationControllerTest >> testValidateSingleObject [
	| activity array model controller results |
	activity := OPBPMNActivityModel new.
	array :=  { activity }.
	controller := OPBPMNValidationController new.
	results := OPBPMNValidationResults new.
	controller validateSingleObject: activity withValidations: controller getValidations withModel: array  withResults: results.
	self assert: (results isKindOf: OPBPMNValidationResults) equals: true.
	self assert: (results hasErrors: activity) equals: true.
]
