"
Tests the validation rule toggle registry, lazy singleton initialization, unknown-rule defaults, and controller adherence to disabled validation rules while isolating global settings state across runs.
"
Class {
	#name : 'OPBPMNValidationFrameworkSettingsTest',
	#superclass : 'TestCase',
	#instVars : [
		'savedSettingsInstance'
	],
	#category : 'OpenPonk-BPMN-Validation-Tests-Settings',
	#package : 'OpenPonk-BPMN-Validation-Tests',
	#tag : 'Settings'
}

{ #category : 'running' }
OPBPMNValidationFrameworkSettingsTest >> setUp [

	super setUp.
	savedSettingsInstance := OPBPMNValidationFrameworkSettings instVarNamed: #settingsInstance.
	OPBPMNValidationFrameworkSettings instVarNamed: #settingsInstance put: nil
]

{ #category : 'running' }
OPBPMNValidationFrameworkSettingsTest >> tearDown [

	OPBPMNValidationFrameworkSettings instVarNamed: #settingsInstance put: savedSettingsInstance.
	savedSettingsInstance := nil.
	super tearDown
]

{ #category : 'tests' }
OPBPMNValidationFrameworkSettingsTest >> testGetInstanceLazilyInitializesAndReturnsSameSingleton [

	| firstInstance secondInstance |
	firstInstance := OPBPMNValidationFrameworkSettings getInstance.
	secondInstance := OPBPMNValidationFrameworkSettings getInstance.
	self assert: firstInstance class identicalTo: OPBPMNValidationFrameworkSettings.
	self assert: secondInstance identicalTo: firstInstance.
	self
		assert: (firstInstance getSettingFor: AN01FlowNodeIncomingFlow)
		description: 'Registered validation rule must be enabled by default'
]

{ #category : 'tests' }
OPBPMNValidationFrameworkSettingsTest >> testGetSettingForUnknownRuleDefaultsToTrue [

	| settingsInstance unknownRuleKey |
	settingsInstance := OPBPMNValidationFrameworkSettings getInstance.
	unknownRuleKey := Object.
	self assert: (settingsInstance getSettingFor: unknownRuleKey) description: 'Unregistered validation key must default to true'.
	settingsInstance setSettingFor: unknownRuleKey withValue: false.
	self deny: (settingsInstance getSettingFor: unknownRuleKey) description: 'Updated validation setting must reflect false value'
]

{ #category : 'tests' }
OPBPMNValidationFrameworkSettingsTest >> testSetSettingForDisablesProcessErrorsRuleDuringValidation [

	| settingsInstance model results |
	settingsInstance := OPBPMNValidationFrameworkSettings getInstance.
	settingsInstance setSettingFor: PR2347ProcessErrors withValue: false.
	model := OPBPMNModel new.
	results := OPBPMNValidationController new validate: model.
	self
		deny: (results results anySatisfy: [ :each | each validation == PR2347ProcessErrors ])
		description: 'Disabled PR2347ProcessErrors must suppress process-level PR02/PR04/PR07 validation results'
]

{ #category : 'tests' }
OPBPMNValidationFrameworkSettingsTest >> testSetSettingForDisablesRuleDuringValidation [

	| settingsInstance model activity results |
	settingsInstance := OPBPMNValidationFrameworkSettings getInstance.
	settingsInstance setSettingFor: AN05LabelValidation withValue: false.
	model := OPBPMNModel new.
	activity := OPBPMNActivityModel new.
	model add: activity.
	results := OPBPMNValidationController new validate: model.
	self
		deny: (results selectWarnings anySatisfy: [ :each | each validation class == AN05LabelValidation ])
		description: 'Disabled rule AN05LabelValidation must not emit warnings'
]
