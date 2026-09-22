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
OPBPMNViewModelFormTest >> testPoolViewModelBindsLanesAndLaneNames [
	| model viewModel controller form |
	model := OPBPMNPoolModel new.
	model lanes: 2.
	viewModel := OPBPMNPoolViewModel new model: model.
	controller := OPBPMNPoolController new viewModel: viewModel.

	form := OPPropertiesForm new.
	form viewModel: controller.

	self assert: (form bindings anySatisfy: [ :eachBinding | eachBinding selector = #name ]).
	self assert: (form bindings anySatisfy: [ :eachBinding | eachBinding selector = #lanes ]).
	self assert: form bindings size equals: 4. "name + lanes + lane1 + lane2"
]

{ #category : 'tests' }
OPBPMNViewModelFormTest >> testPoolViewModelRebuildsLaneNamesOnLanesChange [
	| model viewModel controller form changeCmd |
	model := OPBPMNPoolModel new.
	model lanes: 1.
	viewModel := OPBPMNPoolViewModel new model: model.
	controller := OPBPMNPoolController new viewModel: viewModel.

	form := OPPropertiesForm new.
	form viewModel: controller.
	self assert: form bindings size equals: 3. "name + lanes + lane1"

	changeCmd := OPPropertyChangeCommand
		viewModel: controller
		selector: #lanes
		oldValue: 1
		newValue: 3.
	changeCmd execute.

	self assert: model lanes equals: 3.
	self assert: form bindings size equals: 5. "name + lanes + lane1 + lane2 + lane3"

	changeCmd undo.
	self assert: model lanes equals: 1.
	self assert: form bindings size equals: 3
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
OPBPMNViewModelFormTest >> testSubProcessViewModelBindsMultilineName [
	| model viewModel form |
	model := OPBPMNSubProcessModel new name: 'SubProcess Node'.
	viewModel := OPBPMNSubProcessViewModel new model: model.
	form := OPPropertiesForm new.
	form viewModel: viewModel.
	self assert: (form bindings anySatisfy: [ :eachBinding | eachBinding selector = #name ])
]

{ #category : 'tests' }
OPBPMNViewModelFormTest >> testUndoLaneCountPreservesCustomLaneNames [
	"Verify that shrinking lane count and subsequently performing undo restores custom lane names."
	| poolModel poolController form undoManager lanesBinding |
	undoManager := OPUndoManager new.
	poolModel := OPBPMNPoolModel new.
	poolModel lanes: 3.
	poolModel laneNames at: 3 put: 'Operator'.

	poolController := OPBPMNPoolController new.
	poolController viewModel: (OPBPMNPoolViewModel new model: poolModel).

	form := OPPropertiesForm new.
	form undoManager: undoManager.
	form viewModel: poolController.

	self assert: (poolModel laneNames at: 3) equals: 'Operator'.

	lanesBinding := form bindings detect: [ :eachBinding98 | eachBinding98 selector = #lanes ].
	lanesBinding writeModelValue: 2.

	self assert: poolModel lanes equals: 2.
	self assert: poolModel laneNames size equals: 2.

	"Undo reverts to 3 lanes and restores the original lane name"
	undoManager undo.
	self assert: poolModel lanes equals: 3.
	self assert: poolModel laneNames size equals: 3.
	self assert: (poolModel laneNames at: 3) equals: 'Operator'.

	"Redo reapplies the lane shrink operation"
	undoManager redo.
	self assert: poolModel lanes equals: 2.
	self assert: poolModel laneNames size equals: 2.

	"Repeated undo confirms complete reversibility"
	undoManager undo.
	self assert: poolModel lanes equals: 3.
	self assert: poolModel laneNames size equals: 3.
	self assert: (poolModel laneNames at: 3) equals: 'Operator'
]
