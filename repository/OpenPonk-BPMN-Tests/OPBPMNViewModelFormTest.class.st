"
Tests dynamic property form generation, field bindings, and validation for BPMN view models.
"
Class {
	#name : 'OPBPMNViewModelFormTest',
	#superclass : 'TestCase',
	#category : 'OpenPonk-BPMN-Tests-ViewModels',
	#package : 'OpenPonk-BPMN-Tests',
	#tag : 'ViewModels'
}

{ #category : 'tests' }
OPBPMNViewModelFormTest >> testActivityViewModelBindsMultilineName [

	| model viewModel form |
	model := OPBPMNActivityModel new name: 'Process Task'.
	viewModel := OPBPMNActivityViewModel new model: model.
	form := OPPropertiesForm new.
	form viewModel: viewModel.
	self assert: (form bindings collect: #selector as: Array) equals: #( #name #type #isCallActivity ).
	self assert: (form bindings collect: #class as: Array) equals: {
			OPFormTextBinding.
			OPFormDropListBinding.
			OPFormCheckboxBinding }.
	self assert: (form bindings collect: [ :eachBinding | eachBinding presenter class ] as: Array) equals: {
			SpTextPresenter.
			SpDropListPresenter.
			SpCheckBoxPresenter }
]

{ #category : 'tests' }
OPBPMNViewModelFormTest >> testActivityViewModelRebuildsFormOnTypeChange [

	| model viewModel controller form |
	model := OPBPMNActivityModel new.
	model type: OPBPMNNodeType User.
	viewModel := OPBPMNActivityViewModel new model: model.
	controller := OPBPMNActivityController new viewModel: viewModel.

	form := OPPropertiesForm new.
	form viewModel: controller.
	self assert: (form bindings collect: #selector as: Array) equals: #( #name #type #isCallActivity ).
	self assert: (form bindings collect: #class as: Array) equals: {
			OPFormTextBinding.
			OPFormDropListBinding.
			OPFormCheckboxBinding }.
	self assert: (form bindings collect: [ :eachBinding | eachBinding presenter class ] as: Array) equals: {
			SpTextPresenter.
			SpDropListPresenter.
			SpCheckBoxPresenter }.

	controller propertyNamed: #type put: OPBPMNNodeType Service.
	self
		assert: (form bindings collect: #selector as: Array)
		equals: #( #name #type #isCallActivity #executableAttribute #executableAttributeValue ).
	self assert: (form bindings collect: #class as: Array) equals: {
			OPFormTextBinding.
			OPFormDropListBinding.
			OPFormCheckboxBinding.
			OPFormTextBinding.
			OPFormTextBinding }.
	self assert: (form bindings collect: [ :eachBinding | eachBinding presenter class ] as: Array) equals: {
			SpTextPresenter.
			SpDropListPresenter.
			SpCheckBoxPresenter.
			SpTextInputFieldPresenter.
			SpTextInputFieldPresenter }
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
	self
		assert: (form bindings collect: #selector as: Array)
		equals: #( #name #type #isCallActivity #executableAttribute #executableAttributeValue ).
	self assert: (form bindings collect: #class as: Array) equals: {
			OPFormTextBinding.
			OPFormDropListBinding.
			OPFormCheckboxBinding.
			OPFormTextBinding.
			OPFormTextBinding }.

	changeCmd undo.
	self assert: (form bindings collect: #selector as: Array) equals: #( #name #type #isCallActivity ).
	self assert: (form bindings collect: #class as: Array) equals: {
			OPFormTextBinding.
			OPFormDropListBinding.
			OPFormCheckboxBinding }
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
	self assert: (form bindings collect: #selector as: Array) equals: #( #name #associationDirection ).
	self assert: (form bindings collect: #class as: Array) equals: {
			OPFormTextBinding.
			OPFormDropListBinding }.
	self assert: (form bindings collect: [ :eachBinding | eachBinding presenter class ] as: Array) equals: {
			SpTextInputFieldPresenter.
			SpDropListPresenter }
]

{ #category : 'tests' }
OPBPMNViewModelFormTest >> testBoundaryEventViewModelBindsTypeAndIsNonInterrupting [

	| model viewModel form |
	model := OPBPMNBoundaryEventModel new.
	viewModel := OPBPMNBoundaryEventViewModel new model: model.
	form := OPPropertiesForm new.
	form viewModel: viewModel.
	self assert: (form bindings collect: #selector as: Array) equals: #( #name #type #isNonInterrupting ).
	self assert: (form bindings collect: #class as: Array) equals: {
			OPFormTextBinding.
			OPFormDropListBinding.
			OPFormCheckboxBinding }.
	self assert: (form bindings collect: [ :eachBinding | eachBinding presenter class ] as: Array) equals: {
			SpTextInputFieldPresenter.
			SpDropListPresenter.
			SpCheckBoxPresenter }
]

{ #category : 'tests' }
OPBPMNViewModelFormTest >> testCollapsedSubProcessViewModelBindsTypeAndIsCallActivity [

	| model viewModel form |
	model := OPBPMNCollapsedSubProcessModel new.
	viewModel := OPBPMNCollapsedSubProcessViewModel new model: model.
	form := OPPropertiesForm new.
	form viewModel: viewModel.
	self assert: (form bindings collect: #selector as: Array) equals: #( #name #type #isCallActivity ).
	self assert: (form bindings collect: #class as: Array) equals: {
			OPFormTextBinding.
			OPFormDropListBinding.
			OPFormCheckboxBinding }.
	self assert: (form bindings collect: [ :eachBinding | eachBinding presenter class ] as: Array) equals: {
			SpTextPresenter.
			SpDropListPresenter.
			SpCheckBoxPresenter }
]

{ #category : 'tests' }
OPBPMNViewModelFormTest >> testDataObjectViewModelBindsType [

	| model viewModel form |
	model := OPBPMNDataObjectModel new.
	viewModel := OPBPMNDataObjectViewModel new model: model.
	form := OPPropertiesForm new.
	form viewModel: viewModel.
	self assert: (form bindings collect: #selector as: Array) equals: #( #name #type ).
	self assert: (form bindings collect: #class as: Array) equals: {
			OPFormTextBinding.
			OPFormDropListBinding }.
	self assert: (form bindings collect: [ :eachBinding | eachBinding presenter class ] as: Array) equals: {
			SpTextPresenter.
			SpDropListPresenter }
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

	self assert: (form bindings collect: #selector as: Array) equals: #( #name #type ).
	self assert: (form bindings collect: #class as: Array) equals: {
			OPFormTextBinding.
			OPFormDropListBinding }.
	self assert: (form bindings collect: [ :eachBinding | eachBinding presenter class ] as: Array) equals: {
			SpTextInputFieldPresenter.
			SpDropListPresenter }.

	controller propertyNamed: #type put: OPBPMNNodeType Send.
	self assert: (form bindings collect: #selector as: Array) equals: #( #name #type #executableAttribute #executableAttributeValue ).
	self assert: (form bindings collect: #class as: Array) equals: {
			OPFormTextBinding.
			OPFormDropListBinding.
			OPFormTextBinding.
			OPFormTextBinding }.
	self assert: (form bindings collect: [ :eachBinding | eachBinding presenter class ] as: Array) equals: {
			SpTextInputFieldPresenter.
			SpDropListPresenter.
			SpTextInputFieldPresenter.
			SpTextInputFieldPresenter }
]

{ #category : 'tests' }
OPBPMNViewModelFormTest >> testFlowViewModelBindsType [

	| model viewModel form |
	model := OPBPMNFlowModel new.
	viewModel := OPBPMNFlowViewModel new model: model.
	form := OPPropertiesForm new.
	form viewModel: viewModel.
	self assert: (form bindings collect: #selector as: Array) equals: #( #name #type ).
	self assert: (form bindings collect: #class as: Array) equals: {
			OPFormTextBinding.
			OPFormDropListBinding }.
	self assert: (form bindings collect: [ :eachBinding | eachBinding presenter class ] as: Array) equals: {
			SpTextInputFieldPresenter.
			SpDropListPresenter }
]

{ #category : 'tests' }
OPBPMNViewModelFormTest >> testGatewayViewModelBindsType [

	| model viewModel form |
	model := OPBPMNGatewayModel new.
	viewModel := OPBPMNGatewayViewModel new model: model.
	form := OPPropertiesForm new.
	form viewModel: viewModel.
	self assert: (form bindings collect: #selector as: Array) equals: #( #name #type ).
	self assert: (form bindings collect: #class as: Array) equals: {
			OPFormTextBinding.
			OPFormDropListBinding }.
	self assert: (form bindings collect: [ :eachBinding | eachBinding presenter class ] as: Array) equals: {
			SpTextInputFieldPresenter.
			SpDropListPresenter }
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

	self assert: (form bindings collect: #selector as: Array) equals: #( #name #type ).
	self assert: (form bindings collect: [ :eachBinding | eachBinding presenter class ] as: Array) equals: {
			SpTextInputFieldPresenter.
			SpDropListPresenter }.

	changeCmd := OPPropertyChangeCommand
		             viewModel: controller
		             selector: #type
		             oldValue: OPBPMNNodeType None
		             newValue: OPBPMNNodeType Timer.
	changeCmd execute.
	self assert: (form bindings collect: #selector as: Array) equals: #( #name #type #timerType #timerValue ).
	self assert: (form bindings collect: #class as: Array) equals: {
			OPFormTextBinding.
			OPFormDropListBinding.
			OPFormDropListBinding.
			OPFormTextBinding }.
	self assert: (form bindings collect: [ :eachBinding | eachBinding presenter class ] as: Array) equals: {
			SpTextInputFieldPresenter.
			SpDropListPresenter.
			SpDropListPresenter.
			SpTextInputFieldPresenter }.

	changeCmd undo.
	self assert: (form bindings collect: #selector as: Array) equals: #( #name #type ).

	changeCmd := OPPropertyChangeCommand
		             viewModel: controller
		             selector: #type
		             oldValue: OPBPMNNodeType None
		             newValue: OPBPMNNodeType Send.
	changeCmd execute.
	self assert: (form bindings collect: #selector as: Array) equals: #( #name #type #executableAttribute #executableAttributeValue ).
	self assert: (form bindings collect: #class as: Array) equals: {
			OPFormTextBinding.
			OPFormDropListBinding.
			OPFormTextBinding.
			OPFormTextBinding }.
	self assert: (form bindings collect: [ :eachBinding | eachBinding presenter class ] as: Array) equals: {
			SpTextInputFieldPresenter.
			SpDropListPresenter.
			SpTextInputFieldPresenter.
			SpTextInputFieldPresenter }
]

{ #category : 'tests' }
OPBPMNViewModelFormTest >> testPoolViewModelBindsNameOnly [

	| poolModel poolViewModel poolController form |
	poolModel := OPBPMNPoolModel new name: 'Corporate Pool'.
	poolViewModel := OPBPMNPoolViewModel new model: poolModel.
	poolController := OPBPMNPoolController new viewModel: poolViewModel.

	form := OPPropertiesForm new.
	form viewModel: poolController.

	self assert: (form bindings collect: #selector as: Array) equals: #( #name ).
	self assert: (form bindings collect: #class as: Array) equals: { OPFormTextBinding }.
	self
		assert: (form bindings collect: [ :eachBinding | eachBinding presenter class ] as: Array)
		equals: { SpTextInputFieldPresenter }
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
			capturedItems := #(  ).
			iconBlock := nil.
			(form stub bindDroplist: Any property: #type items: Any) will: [ :labelArg :propertyArg :itemsArg |
					capturedItems := itemsArg.
					capturedDropList ].
			(capturedDropList stub displayIcon: Any) will: [ :aBlock |
					iconBlock := aBlock.
					capturedDropList ].
			viewModel buildEditorForm: form.
			self denyEmpty: capturedItems.
			self deny: iconBlock identicalTo: nil.
			capturedItems do: [ :eachType |
					| icon expectedIcon |
					icon := iconBlock value: eachType.
					expectedIcon := viewModel typeIconFor: eachType.
					self assert: icon class identicalTo: Form.
					self assert: icon extent equals: expectedIcon extent.
					self deny: icon extent equals: 0 @ 0.
					self assert: icon depth equals: 32.
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

	self assert: (form bindings collect: #selector as: Array) equals: #( #name #type #isNonInterrupting ).
	self assert: (form bindings collect: #class as: Array) equals: {
			OPFormTextBinding.
			OPFormDropListBinding.
			OPFormCheckboxBinding }.
	self assert: (form bindings collect: [ :eachBinding | eachBinding presenter class ] as: Array) equals: {
			SpTextInputFieldPresenter.
			SpDropListPresenter.
			SpCheckBoxPresenter }.

	controller propertyNamed: #type put: OPBPMNNodeType Timer.
	self assert: (form bindings collect: #selector as: Array) equals: #( #name #type #isNonInterrupting #timerType #timerValue ).
	self assert: (form bindings collect: #class as: Array) equals: {
			OPFormTextBinding.
			OPFormDropListBinding.
			OPFormCheckboxBinding.
			OPFormDropListBinding.
			OPFormTextBinding }.
	self assert: (form bindings collect: [ :eachBinding | eachBinding presenter class ] as: Array) equals: {
			SpTextInputFieldPresenter.
			SpDropListPresenter.
			SpCheckBoxPresenter.
			SpDropListPresenter.
			SpTextInputFieldPresenter }
]

{ #category : 'tests' }
OPBPMNViewModelFormTest >> testSubProcessAndBoundaryEventViewModelsBindAllProperties [

	| subModel subViewModel subForm boundaryModel boundaryViewModel boundaryController boundaryForm |
	subModel := OPBPMNSubProcessModel new name: 'Expanded'.
	subViewModel := OPBPMNSubProcessViewModel new model: subModel.
	subForm := OPPropertiesForm new.
	subForm viewModel: subViewModel.
	self assert: (subForm bindings collect: #selector as: Array) equals: #( #name #type ).
	self assert: (subForm bindings collect: #class as: Array) equals: {
			OPFormTextBinding.
			OPFormDropListBinding }.
	self assert: (subForm bindings collect: [ :eachBinding | eachBinding presenter class ] as: Array) equals: {
			SpTextPresenter.
			SpDropListPresenter }.

	boundaryModel := OPBPMNBoundaryEventModel new.
	boundaryModel type: OPBPMNNodeType Error.
	boundaryViewModel := OPBPMNBoundaryEventViewModel new model: boundaryModel.
	boundaryController := OPBPMNBoundaryEventController new viewModel: boundaryViewModel.
	boundaryForm := OPPropertiesForm new.
	boundaryForm viewModel: boundaryController.
	self assert: (boundaryForm bindings collect: #selector as: Array) equals: #( #name #type #isNonInterrupting ).
	self assert: (boundaryForm bindings collect: #class as: Array) equals: {
			OPFormTextBinding.
			OPFormDropListBinding.
			OPFormCheckboxBinding }.

	boundaryController propertyNamed: #type put: OPBPMNNodeType Timer.
	self
		assert: (boundaryForm bindings collect: #selector as: Array)
		equals: #( #name #type #isNonInterrupting #timerType #timerValue ).
	self assert: (boundaryForm bindings collect: #class as: Array) equals: {
			OPFormTextBinding.
			OPFormDropListBinding.
			OPFormCheckboxBinding.
			OPFormDropListBinding.
			OPFormTextBinding }.
	self assert: (boundaryForm bindings collect: [ :eachBinding | eachBinding presenter class ] as: Array) equals: {
			SpTextInputFieldPresenter.
			SpDropListPresenter.
			SpCheckBoxPresenter.
			SpDropListPresenter.
			SpTextInputFieldPresenter }
]

{ #category : 'tests' }
OPBPMNViewModelFormTest >> testSubProcessViewModelAllChildrenModelsAndInnerDependentElements [

	| project projectController registry subProcess nestedSubProcess innerTask externalAnnotation incomingAssociation subProcessViewModel innerTaskViewModel |
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

	project := OPProject named: 'BPMNSubProcess'.
	projectController := OPProjectController forProject: project.
	registry := projectController viewModelRegistry.
	subProcessViewModel := registry viewModelFor: subProcess.
	innerTaskViewModel := registry viewModelFor: innerTask.

	self assertCollection: subProcessViewModel childrenModels hasSameElements: { nestedSubProcess }.
	self assertCollection: subProcessViewModel allChildrenModels hasSameElements: {
			nestedSubProcess.
			innerTask }.
	self assertCollection: innerTaskViewModel dependentElements includesAll: { incomingAssociation }
]

{ #category : 'tests' }
OPBPMNViewModelFormTest >> testSubProcessViewModelBindsMultilineName [

	| model viewModel form |
	model := OPBPMNSubProcessModel new name: 'SubProcess Node'.
	viewModel := OPBPMNSubProcessViewModel new model: model.
	form := OPPropertiesForm new.
	form viewModel: viewModel.
	self assert: (form bindings collect: #selector as: Array) equals: #( #name #type ).
	self assert: (form bindings collect: #class as: Array) equals: {
			OPFormTextBinding.
			OPFormDropListBinding }.
	self assert: (form bindings collect: [ :eachBinding | eachBinding presenter class ] as: Array) equals: {
			SpTextPresenter.
			SpDropListPresenter }
]
