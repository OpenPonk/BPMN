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

{ #category : 'accessing' }
OPBPMNValidationFrameworkSettings class >> getInstance [
	settingsInstance ifNil: [ settingsInstance := self new. ].
	^ settingsInstance.
]

{ #category : 'accessing' }
OPBPMNValidationFrameworkSettings class >> settingsInstance [
 	settingsInstance ifNil: [ settingsInstance := self new. ].
	^ settingsInstance.
]

{ #category : 'access' }
OPBPMNValidationFrameworkSettings >> getSettingFor: aVerificationClass [
	(settings includesKey: aVerificationClass) ifFalse: [ settings add: (aVerificationClass -> true) ].
	^ settings at: aVerificationClass.
]

{ #category : 'access' }
OPBPMNValidationFrameworkSettings >> initialize [
	| controller |
	controller := OPBPMNValidationController new.
	settings := Dictionary new.
	controller getValidations do: [ :class | settings add: (class -> true). ]
]

{ #category : 'access' }
OPBPMNValidationFrameworkSettings >> setSettingFor: aVerificationClass withValue: aValue [
	settings at: aVerificationClass put: aValue.
]
