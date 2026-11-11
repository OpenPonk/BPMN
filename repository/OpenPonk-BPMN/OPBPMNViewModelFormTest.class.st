"
Tests dynamic property form generation, field bindings, and validation for BPMN view models.
"
Class {
	#name : 'OPBPMNViewModelFormTest',
	#superclass : 'TestCase',
	#category : 'OpenPonk-BPMN-Tests',
	#package : 'OpenPonk-BPMN',
	#tag : 'Tests'
}

{ #category : 'tests' }
OPBPMNViewModelFormTest >> testActivityViewModelBindsMultilineName [
	| model viewModel form |
	model := OPBPMNActivityModel new name: 'Process Task'.
	viewModel := OPBPMNActivityViewModel new model: model.
	form := OPPropertiesForm new.
	form viewModel: viewModel.
	self assert: (form bindings anySatisfy: [ :eachBinding | eachBinding selector = #name ])
]

{ #category : 'tests' }
OPBPMNViewModelFormTest >> testActivityViewModelRebuildsFormOnTypeChange [
	| model viewModel controller form initialCount newCount |
	model := OPBPMNActivityModel new.
	model type: OPBPMNNodeType User.
	viewModel := OPBPMNActivityViewModel new model: model.
	controller := OPBPMNActivityController new viewModel: viewModel.

	form := OPPropertiesForm new.
	form viewModel: controller.
	initialCount := form bindings size.

	controller propertyNamed: #type put: OPBPMNNodeType Service.
	newCount := form bindings size.

	self assert: initialCount equals: 3.
	self assert: newCount equals: 5.
	self assert: (form bindings anySatisfy: [ :eachBinding | eachBinding selector = #executableAttribute ])
]

{ #category : 'tests' }
OPBPMNViewModelFormTest >> testActivityViewModelRebuildsFormOnUndo [
	| model viewModel controller form changeCmd |
	model := OPBPMNActivityModel new.
	model type: OPBPMNNodeType User.
	viewModel := OPBPMNActivityViewModel new model: model.
	controller := OPBPMNActivityController new viewModel: viewModel.

	form := OPPropertiesForm new.
	form viewModel: controller.

	changeCmd := OPPropertyChangeCommand
		viewModel: controller
		selector: #type
		oldValue: OPBPMNNodeType User
		newValue: OPBPMNNodeType Service.

	changeCmd execute.
	self assert: form bindings size equals: 5.

	changeCmd undo.
	self assert: form bindings size equals: 3.
	self deny: (form bindings anySatisfy: [ :eachBinding | eachBinding selector = #executableAttribute ])
]

{ #category : 'tests' }
OPBPMNViewModelFormTest >> testAnnotationViewModelReportsAssociationsAsChildrenModels [
	| annotationModel activityModel associationModel annotationViewModel reportedChildren |
	annotationModel := OPBPMNAnnotationModel new.
	activityModel := OPBPMNActivityModel new.
	associationModel := OPBPMNAssociationModel new
		source: annotationModel;
		target: activityModel;
		yourself.
	annotationModel addAssociation: associationModel.
	activityModel addAssociation: associationModel.
	annotationViewModel := OPBPMNAnnotationViewModel new model: annotationModel.
	reportedChildren := annotationViewModel childrenModels.
	self assertCollection: reportedChildren includesAll: { associationModel }
]

{ #category : 'tests' }
OPBPMNViewModelFormTest >> testAssociationViewModelBindsAssociationDirection [
	| model viewModel form |
	model := OPBPMNAssociationModel new.
	viewModel := OPBPMNAssociationViewModel new model: model.
	form := OPPropertiesForm new.
	form viewModel: viewModel.
	self assert: (form bindings anySatisfy: [ :eachBinding | eachBinding selector = #associationDirection ])
]

{ #category : 'tests' }
OPBPMNViewModelFormTest >> testBoundaryEventViewModelBindsTypeAndIsNonInterrupting [
	| model viewModel form |
	model := OPBPMNBoundaryEventModel new.
	viewModel := OPBPMNBoundaryEventViewModel new model: model.
	form := OPPropertiesForm new.
	form viewModel: viewModel.
	self assert: (form bindings anySatisfy: [ :eachBinding | eachBinding selector = #type ]).
	self assert: (form bindings anySatisfy: [ :eachBinding | eachBinding selector = #isNonInterrupting ])
]

{ #category : 'tests' }
OPBPMNViewModelFormTest >> testCollapsedSubProcessViewModelBindsTypeAndIsCallActivity [
	| model viewModel form |
	model := OPBPMNCollapsedSubProcessModel new.
	viewModel := OPBPMNCollapsedSubProcessViewModel new model: model.
	form := OPPropertiesForm new.
	form viewModel: viewModel.
	self assert: (form bindings anySatisfy: [ :eachBinding | eachBinding selector = #type ]).
	self assert: (form bindings anySatisfy: [ :eachBinding | eachBinding selector = #isCallActivity ])
]

{ #category : 'tests' }
OPBPMNViewModelFormTest >> testDataObjectViewModelBindsType [
	| model viewModel form |
	model := OPBPMNDataObjectModel new.
	viewModel := OPBPMNDataObjectViewModel new model: model.
	form := OPPropertiesForm new.
	form viewModel: viewModel.
	self assert: (form bindings anySatisfy: [ :eachBinding | eachBinding selector = #type ])
]

{ #category : 'tests' }
OPBPMNViewModelFormTest >> testEndEventViewModelBindsExecutableAttributesWhenSendType [
	| model viewModel controller form |
	model := OPBPMNEndEventModel new.
	model type: OPBPMNNodeType None.
	viewModel := OPBPMNEndEventViewModel new model: model.
	controller := OPBPMNEndEventController new viewModel: viewModel.
	form := OPPropertiesForm new.
	form viewModel: controller.

	self assert: (form bindings anySatisfy: [ :eachBinding | eachBinding selector = #name ]).
	self assert: (form bindings anySatisfy: [ :eachBinding | eachBinding selector = #type ]).
	self deny: (form bindings anySatisfy: [ :eachBinding | eachBinding selector = #executableAttribute ]).

	controller propertyNamed: #type put: OPBPMNNodeType Send.
	self assert: (form bindings anySatisfy: [ :eachBinding | eachBinding selector = #executableAttribute ]).
	self assert: (form bindings anySatisfy: [ :eachBinding | eachBinding selector = #executableAttributeValue ])
]

{ #category : 'tests' }
OPBPMNViewModelFormTest >> testFlowViewModelBindsType [
	| model viewModel form |
	model := OPBPMNFlowModel new.
	viewModel := OPBPMNFlowViewModel new model: model.
	form := OPPropertiesForm new.
	form viewModel: viewModel.
	self assert: (form bindings anySatisfy: [ :eachBinding | eachBinding selector = #type ])
]

{ #category : 'tests' }
OPBPMNViewModelFormTest >> testGatewayViewModelBindsType [
	| model viewModel form |
	model := OPBPMNGatewayModel new.
	viewModel := OPBPMNGatewayViewModel new model: model.
	form := OPPropertiesForm new.
	form viewModel: viewModel.
	self assert: (form bindings anySatisfy: [ :eachBinding | eachBinding selector = #type ])
]

{ #category : 'tests' }
OPBPMNViewModelFormTest >> testIntermediateEventViewModelBindsTimerAndSendFieldsConditionally [
	| model viewModel controller form changeCmd |
	model := OPBPMNIntermediateEventModel new.
	model type: OPBPMNNodeType None.
	viewModel := OPBPMNIntermediateEventViewModel new model: model.
	controller := OPBPMNIntermediateEventController new viewModel: viewModel.
	form := OPPropertiesForm new.
	form viewModel: controller.

	self assert: (form bindings anySatisfy: [ :eachBinding | eachBinding selector = #name ]).
	self assert: (form bindings anySatisfy: [ :eachBinding | eachBinding selector = #type ]).
	self deny: (form bindings anySatisfy: [ :eachBinding | eachBinding selector = #timerType ]).
	self deny: (form bindings anySatisfy: [ :eachBinding | eachBinding selector = #executableAttribute ]).

	changeCmd := OPPropertyChangeCommand
		viewModel: controller
		selector: #type
		oldValue: OPBPMNNodeType None
		newValue: OPBPMNNodeType Timer.
	changeCmd execute.
	self assert: (form bindings anySatisfy: [ :eachBinding | eachBinding selector = #timerType ]).
	self assert: (form bindings anySatisfy: [ :eachBinding | eachBinding selector = #timerValue ]).

	changeCmd undo.
	self deny: (form bindings anySatisfy: [ :eachBinding | eachBinding selector = #timerType ]).

	changeCmd := OPPropertyChangeCommand
		viewModel: controller
		selector: #type
		oldValue: OPBPMNNodeType None
		newValue: OPBPMNNodeType Send.
	changeCmd execute.
	self assert: (form bindings anySatisfy: [ :eachBinding | eachBinding selector = #executableAttribute ]).
	self assert: (form bindings anySatisfy: [ :eachBinding | eachBinding selector = #executableAttributeValue ]).
	self deny: (form bindings anySatisfy: [ :eachBinding | eachBinding selector = #timerType ])
]

{ #category : 'tests' }
OPBPMNViewModelFormTest >> testPoolViewModelBindsNameOnly [
	| poolModel poolViewModel poolController form |
	poolModel := OPBPMNPoolModel new name: 'Corporate Pool'.
	poolViewModel := OPBPMNPoolViewModel new model: poolModel.
	poolController := OPBPMNPoolController new viewModel: poolViewModel.

	form := OPPropertiesForm new.
	form viewModel: poolController.

	self assert: (form bindings anySatisfy: [ :eachBinding | eachBinding selector = #name ]).
	self deny: (form bindings anySatisfy: [ :eachBinding | eachBinding selector = #lanes ]).
	self assert: form bindings size equals: 1
]

{ #category : 'tests' }
OPBPMNViewModelFormTest >> testSemanticNodeViewModelsProvideTypeIconsWithoutModelDependency [
	| viewModelClasses |
	viewModelClasses := {
		OPBPMNActivityViewModel.
		OPBPMNBoundaryEventViewModel.
		OPBPMNCollapsedSubProcessViewModel.
		OPBPMNDataObjectViewModel.
		OPBPMNEndEventViewModel.
		OPBPMNGatewayViewModel.
		OPBPMNIntermediateEventViewModel.
		OPBPMNStartEventViewModel.
		OPBPMNSubProcessViewModel }.
	viewModelClasses do: [ :eachViewModelClass |
		| viewModel form capturedDropList capturedItems iconBlock |
		viewModel := eachViewModelClass new.
		viewModel model: eachViewModelClass modelClass new.
		form := Mock new.
		capturedDropList := Mock new.
		capturedItems := #().
		iconBlock := nil.
		(form stub bindDroplist: Any property: #type items: Any) will: [ :labelArg :propertyArg :itemsArg |
			capturedItems := itemsArg.
			capturedDropList ].
		(capturedDropList stub displayIcon: Any) will: [ :aBlock |
			iconBlock := aBlock.
			capturedDropList ].
		viewModel buildEditorForm: form.
		self denyEmpty: capturedItems.
		self assert: iconBlock isNotNil.
		capturedItems do: [ :eachType |
			| icon expectedIcon |
			icon := iconBlock value: eachType.
			expectedIcon := viewModel typeIconFor: eachType.
			self assert: icon isForm.
			self assert: icon width > 10.
			self assert: icon bits equals: expectedIcon bits ] ]
]

{ #category : 'tests' }
OPBPMNViewModelFormTest >> testStartEventViewModelBindsTypeAndConditionalTimerFields [
	| model viewModel controller form |
	model := OPBPMNStartEventModel new.
	model type: OPBPMNNodeType None.
	viewModel := OPBPMNStartEventViewModel new model: model.
	controller := OPBPMNStartEventController new viewModel: viewModel.
	form := OPPropertiesForm new.
	form viewModel: controller.

	self assert: (form bindings anySatisfy: [ :eachBinding | eachBinding selector = #name ]).
	self assert: (form bindings anySatisfy: [ :eachBinding | eachBinding selector = #type ]).
	self assert: (form bindings anySatisfy: [ :eachBinding | eachBinding selector = #isNonInterrupting ]).
	self deny: (form bindings anySatisfy: [ :eachBinding | eachBinding selector = #timerType ]).

	controller propertyNamed: #type put: OPBPMNNodeType Timer.
	self assert: (form bindings anySatisfy: [ :eachBinding | eachBinding selector = #timerType ]).
	self assert: (form bindings anySatisfy: [ :eachBinding | eachBinding selector = #timerValue ])
]

{ #category : 'tests' }
OPBPMNViewModelFormTest >> testSubProcessAndBoundaryEventViewModelsBindAllProperties [
	| subModel subViewModel subForm boundaryModel boundaryViewModel boundaryController boundaryForm |
	subModel := OPBPMNSubProcessModel new name: 'Expanded'.
	subViewModel := OPBPMNSubProcessViewModel new model: subModel.
	subForm := OPPropertiesForm new.
	subForm viewModel: subViewModel.
	self
		assert: (subForm bindings anySatisfy: [ :eachBinding | eachBinding selector = #type ])
		description: 'Expanded subprocess view model must bind Marker (#type) in properties form'.

	boundaryModel := OPBPMNBoundaryEventModel new.
	boundaryModel type: OPBPMNNodeType Error.
	boundaryViewModel := OPBPMNBoundaryEventViewModel new model: boundaryModel.
	boundaryController := OPBPMNBoundaryEventController new viewModel: boundaryViewModel.
	boundaryForm := OPPropertiesForm new.
	boundaryForm viewModel: boundaryController.
	self deny: (boundaryForm bindings anySatisfy: [ :eachBinding | eachBinding selector = #timerType ]).

	boundaryController propertyNamed: #type put: OPBPMNNodeType Timer.
	self
		assert: (boundaryForm bindings anySatisfy: [ :eachBinding | eachBinding selector = #timerType ])
		description: 'Boundary event view model must rebuild form and bind timerType when switched to Timer'.
	self
		assert: (boundaryForm bindings anySatisfy: [ :eachBinding | eachBinding selector = #timerValue ])
		description: 'Boundary event view model must bind timerValue when switched to Timer'
]

{ #category : 'tests' }
OPBPMNViewModelFormTest >> testSubProcessViewModelBindsMultilineName [
	| model viewModel form |
	model := OPBPMNSubProcessModel new name: 'SubProcess Node'.
	viewModel := OPBPMNSubProcessViewModel new model: model.
	form := OPPropertiesForm new.
	form viewModel: viewModel.
	self assert: (form bindings anySatisfy: [ :eachBinding | eachBinding selector = #name ])
]

{ #category : 'tests' }
OPBPMNViewModelFormTest >> testSubProcessViewModelEssentialChildrenModelsIncludesNestedNodesAndIncomingAssociations [
	| subProcess nestedSubProcess innerTask externalAnnotation incomingAssociation viewModel essential |
	subProcess := OPBPMNSubProcessModel new name: 'Outer SubProcess'.
	nestedSubProcess := OPBPMNSubProcessModel new name: 'Nested SubProcess'.
	innerTask := OPBPMNActivityModel new name: 'Deep Task'.
	nestedSubProcess add: innerTask.
	subProcess add: nestedSubProcess.

	externalAnnotation := OPBPMNAnnotationModel new text: 'Note'.
	incomingAssociation := OPBPMNAssociationModel new
		source: externalAnnotation;
		target: innerTask;
		yourself.
	externalAnnotation addAssociation: incomingAssociation.
	innerTask addAssociation: incomingAssociation.

	viewModel := OPBPMNSubProcessViewModel new model: subProcess.
	essential := viewModel essentialChildrenModels.

	self assertCollection: essential includesAll: { nestedSubProcess . innerTask . incomingAssociation }
]
