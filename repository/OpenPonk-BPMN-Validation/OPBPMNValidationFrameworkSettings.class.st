"
I act as a registry for configuring the BPMN validation framework. I manage user settings, such as enabling or disabling specific validation rules.
"
Class {
	#name : 'OPBPMNValidationFrameworkSettings',
	#superclass : 'Object',
	#instVars : [
		'settings'
	],
	#classInstVars : [
		'settingsInstance'
	],
	#category : 'OpenPonk-BPMN-Validation-Settings',
	#package : 'OpenPonk-BPMN-Validation',
	#tag : 'Settings'
}

{ #category : 'settings' }
OPBPMNValidationFrameworkSettings class >> addSettingsFor: aValidationClasses to: aBuilder inGroup: aGroupSymbol [

	((aValidationClasses reject: #isAbstract) sorted: [ :first :second | first name <= second name ]) do: [ :validationClass |
			| settingName |
			settingName := (String streamContents: [ :stream |
					                stream << 'access'.
					                stream << validationClass name ]) asSymbol.
			(aBuilder setting: settingName)
				parent: aGroupSymbol;
				target: validationClass;
				getSelector: #isEnabled;
				setSelector: #isEnabled:;
				default: true;
				label: validationClass name;
				description: (self descriptionFor: validationClass) ]
]

{ #category : 'settings' }
OPBPMNValidationFrameworkSettings class >> descriptionFor: aValidationClass [

	| comment |
	comment := aValidationClass comment trimBoth.
	^ comment ifEmpty: [ 'Allow or deny execution of this BPMN validation.' ]
]

{ #category : 'accessing' }
OPBPMNValidationFrameworkSettings class >> getInstance [
	settingsInstance ifNil: [ settingsInstance := self new. ].
	^ settingsInstance.
]

{ #category : 'settings' }
OPBPMNValidationFrameworkSettings class >> settingsOn: aBuilder [

	<systemsettings>
	(aBuilder group: #bpmnValidations)
		label: 'BPMN Validations';
		parent: #openponk;
		order: 230.
	self addSettingsFor: OPBPMNValidationController new getValidations to: aBuilder inGroup: #bpmnValidations
]

{ #category : 'access' }
OPBPMNValidationFrameworkSettings >> getSettingFor: aVerificationClass [
	(settings includesKey: aVerificationClass) ifFalse: [ settings add: (aVerificationClass -> true) ].
	^ settings at: aVerificationClass.
]

{ #category : 'initialization' }
OPBPMNValidationFrameworkSettings >> initialize [

	| controller |
	super initialize.

	controller := OPBPMNValidationController new.
	settings := Dictionary new.
	controller getValidations do: [ :class | settings add: class -> true ]
]

{ #category : 'access' }
OPBPMNValidationFrameworkSettings >> setSettingFor: aVerificationClass withValue: aValue [
	settings at: aVerificationClass put: aValue.
]
