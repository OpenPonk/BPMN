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
OPBPMNValidationFrameworkSettingsTest >> testBpmnValidationsCategoryCanBeOpenedInSpecSettings [

	| builder settingNode declaration specNode presenter |
	builder := SettingTreeBuilder new.
	OPBPMNValidationFrameworkSettings settingsOn: builder.
	settingNode := builder nodeList detect: [ :each | each name = #accessAC01MessageReceive ].
	declaration := settingNode settingDeclaration.
	self assert: declaration target identicalTo: AC01MessageReceive.
	self assert: declaration getSelector equals: #isEnabled.
	self assert: declaration setSelector equals: #isEnabled:.

	specNode := StSettingNode new
		            declaration: declaration;
		            yourself.
	presenter := specNode asPresenterOn: StSettingDetailPresenter new.
	presenter build.

	presenter value: false.
	self
		deny: AC01MessageReceive isEnabled
		description: 'Toggling Spec settings presenter to false should disable the BPMN validation rule'.
	presenter value: true.
	self
		assert: AC01MessageReceive isEnabled
		description: 'Toggling Spec settings presenter back to true should re-enable the BPMN validation rule'
]

{ #category : 'tests' }
OPBPMNValidationFrameworkSettingsTest >> testDescriptionForUsesClassCommentAndFallsBackWhenEmpty [

	| anonymousRuleClass |
	self assert: (OPBPMNValidationFrameworkSettings descriptionFor: AC01MessageReceive) equals: AC01MessageReceive comment trimBoth.
	anonymousRuleClass := OPBPMNValidation newAnonymousSubclass.
	self
		assert: (OPBPMNValidationFrameworkSettings descriptionFor: anonymousRuleClass)
		equals: 'Allow or deny execution of this BPMN validation.'
]

{ #category : 'tests' }
OPBPMNValidationFrameworkSettingsTest >> testDisabledValidationViaClassIsEnabledIsSkippedByController [

	| model activity controller enabledResults disabledResults |
	model := OPBPMNModel new.
	activity := OPBPMNActivityModel new.
	model add: activity.
	controller := OPBPMNValidationController new.

	enabledResults := controller validate: model.
	self
		assert: (enabledResults selectWarnings anySatisfy: [ :each | each validation class == AN05LabelValidation ])
		description: 'Enabled AN05LabelValidation should report warning on unlabeled activity'.
	self
		assert: (enabledResults results anySatisfy: [ :each | each validation == PR2347ProcessErrors ])
		description: 'Enabled PR2347ProcessErrors should report process-level findings on incomplete model'.

	AN05LabelValidation isEnabled: false.
	PR2347ProcessErrors isEnabled: false.
	disabledResults := controller validate: model.
	self
		deny: (disabledResults selectWarnings anySatisfy: [ :each | each validation class == AN05LabelValidation ])
		description: 'Disabled AN05LabelValidation must be skipped by OPBPMNValidationController'.
	self
		deny: (disabledResults results anySatisfy: [ :each | each validation == PR2347ProcessErrors ])
		description: 'Disabled PR2347ProcessErrors must be skipped by OPBPMNValidationController'
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

{ #category : 'tests' }
OPBPMNValidationFrameworkSettingsTest >> testSettingsOnDeclaresAllValidationRules [

	| method pragma builder nodes validationsGroup validationNodes expectedClasses actualClasses sampleDeclaration startupAction |
	method := OPBPMNValidationFrameworkSettings class >> #settingsOn:.
	pragma := method pragmaAt: #systemsettings.
	self deny: pragma identicalTo: nil.
	self assert: pragma selector equals: #systemsettings.

	builder := SettingTreeBuilder new.
	OPBPMNValidationFrameworkSettings settingsOn: builder.
	nodes := builder nodeList.

	validationsGroup := nodes detect: [ :each | each name = #bpmnValidations ].
	self assert: validationsGroup parentName equals: #openponk.
	self assert: validationsGroup item order equals: 230.
	self assert: validationsGroup item label equals: 'BPMN Validations'.

	validationNodes := nodes select: [ :each | each parentName = #bpmnValidations ].
	expectedClasses := (OPBPMNValidationController new getValidations reject: #isAbstract) asArray sorted: [ :first :second |
		                   first name <= second name ].
	self assert: validationNodes size equals: 36.
	actualClasses := validationNodes collect: [ :each | each settingDeclaration target ].
	self assert: actualClasses asArray equals: expectedClasses.

	validationNodes do: [ :settingNode |
			| declaration |
			declaration := settingNode settingDeclaration.
			self
				assert: declaration target isClass
				description: 'Setting target must be a class for Spec settings and export compatibility'.
			self assert: declaration getSelector equals: #isEnabled.
			self assert: declaration setSelector equals: #isEnabled:.
			self assert: declaration default description: 'Setting default value should be true'.
			self assert: declaration label equals: declaration target name.
			self assert: declaration description equals: declaration target comment trimBoth.
			self assert: declaration exportSettingAction identicalTo: nil ].

	sampleDeclaration := validationNodes first settingDeclaration.
	sampleDeclaration realValue: false.
	startupAction := sampleDeclaration exportSettingAction.
	self assert: (startupAction isKindOf: StartupAction) description: 'Modified setting should export a StartupAction'
]

{ #category : 'tests' }
OPBPMNValidationFrameworkSettingsTest >> testValidationClassIsEnabled [

	self assert: AN01FlowNodeIncomingFlow isEnabled description: 'Concrete validation rule should be enabled by default'.
	AN01FlowNodeIncomingFlow isEnabled: false.
	self deny: AN01FlowNodeIncomingFlow isEnabled description: 'Validation rule should report disabled after isEnabled: false'.
	self
		deny: (OPBPMNValidationFrameworkSettings getInstance getSettingFor: AN01FlowNodeIncomingFlow)
		description: 'Framework settings instance should reflect disabled validation rule'.
	AN01FlowNodeIncomingFlow isEnabled: true.
	self assert: AN01FlowNodeIncomingFlow isEnabled description: 'Validation rule should report enabled after isEnabled: true'
]
