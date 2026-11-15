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
	self assert: validations class identicalTo: Set.
	self denyEmpty: validations.
	self
		assertCollection: (validations collect: [ :validationClass | validationClass packageTag name ])
		hasSameElements: #( 'Validation-Classes' ).
	self assertCollection: validations includesAll: {
			AN01FlowNodeIncomingFlow.
			GW02Splitting.
			PR2347ProcessErrors }
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
	self assert: results class identicalTo: OPBPMNValidationResults.
	self assert: (results hasErrors: activity) description: 'Unconnected activity must produce validation errors'.
	self deny: (results hasErrors: dataO) description: 'Data object must not produce validation errors'.
	self assert: (results hasWarnings: model) description: 'Model without start and end events must produce process warning'.
	self deny: (results hasErrors: model) description: 'Model with activity must not produce process errors'.
	self assertCollection: (results selectErrors collect: [ :each | each validation class ]) hasSameElements: {
			AN01FlowNodeIncomingFlow.
			AN02FlowNodeOutgoingFlow }.
	self
		assertCollection: (results selectWarnings collect: [ :each | each validation class -> each objectReference ])
		hasSameElements: {
				(AN05LabelValidation -> activity).
				(AN05LabelValidation -> dataO).
				(AN07UnconnectedArtifactOrData -> dataO).
				(PR2347ProcessErrors class -> model) }
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
	self assert: results class identicalTo: OPBPMNValidationResults.
	self deny: (results hasErrors: activity) description: 'Process validation alone must not attach activity errors'.
	self deny: (results hasErrors: dataObject) description: 'Process validation must not report errors on data object'.
	self assert: (results hasWarnings: model) description: 'Model missing start and end events must have PR07 process warning'.
	self deny: (results hasErrors: model) description: 'Model with an activity must not have process errors'.
	self
		assertCollection: (results selectWarnings collect: [ :each | each validation -> each objectReference ])
		hasSameElements: { (PR2347ProcessErrors -> model) }.

	model add: startEvent.
	model add: endEvent.
	results := controller validateProcess: model.
	self assert: results class identicalTo: OPBPMNValidationResults.
	self deny: (results hasErrors: activity) description: 'Activity must not have process errors'.
	self deny: (results hasErrors: startEvent) description: 'Start event must not have process errors'.
	self
		deny: (results hasWarnings: model)
		description: 'Model with activity, start event, and end event must have no process warnings'.
	self deny: (results hasErrors: model) description: 'Model with activity, start event, and end event must have no process errors'.
	self assertEmpty: results results
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
	self assert: results class identicalTo: OPBPMNValidationResults.
	self assert: (results hasErrors: activity) description: 'Unconnected activity must produce validation errors'.
	self assertCollection: (results selectErrors collect: [ :each | each validation class ]) hasSameElements: {
			AN01FlowNodeIncomingFlow.
			AN02FlowNodeOutgoingFlow }
]
