Class {
	#name : 'OPBPMNLaneControllerTest',
	#superclass : 'OPBPMNNodeControllerTest',
	#category : 'OpenPonk-BPMN-Tests',
	#package : 'OpenPonk-BPMN',
	#tag : 'Tests'
}

{ #category : 'constants' }
OPBPMNLaneControllerTest >> controllerClass [
	^ OPBPMNLaneController
]

{ #category : 'constants' }
OPBPMNLaneControllerTest >> creationTargetControllerClass [
	^ OPBPMNPoolController
]

{ #category : 'constants' }
OPBPMNLaneControllerTest >> creationTargetModelClass [
	^ OPBPMNPoolModel
]

{ #category : 'accessing' }
OPBPMNLaneControllerTest >> diagramElementClass [
	^ OPBPMNLaneShape
]

{ #category : 'constants' }
OPBPMNLaneControllerTest >> modelClass [
	^ OPBPMNLaneModel
]

{ #category : 'tests' }
OPBPMNLaneControllerTest >> testAddFirstLaneMigratesPoolElementsToLaneShapeAndSupportsUndoRedo [
	| poolModel taskModel poolController taskController laneController laneModel |
	poolModel := OPBPMNPoolModel new name: 'Order Fulfillment'.
	taskModel := OPBPMNActivityModel new name: 'Process Order'.
	poolModel add: taskModel.
	diagramController model add: poolModel.
	diagramController showAllElements.

	poolController := diagramController controllerForModel: poolModel.
	taskController := diagramController controllerForModel: taskModel.

	self assert: taskController diagramElement owningElement equals: poolController diagramElement.
	self assert: taskController diagramElement isRendered.

	laneController := OPBPMNLaneController new.
	poolController addAsTargetFor: laneController onPosition: 100 @ 100.
	laneModel := laneController model.

	self assert: (poolModel lanes includes: laneModel).
	self assert: taskModel owner equals: laneModel.
	self assert: taskController viewModel parentViewModel equals: laneController viewModel.
	self assert: taskController diagramElement owningElement equals: laneController diagramElement.
	self assert: taskController diagramElement isRendered.

	diagramController undo.

	self deny: poolModel hasLanes.
	self assert: taskModel owner equals: poolModel.
	self assert: taskController viewModel parentViewModel equals: poolController viewModel.
	self assert: taskController diagramElement owningElement equals: poolController diagramElement.
	self assert: taskController diagramElement isRendered.

	diagramController redo.

	self assert: (poolModel lanes includes: laneModel).
	self assert: taskModel owner equals: laneModel.
	self assert: taskController viewModel parentViewModel equals: (diagramController controllerForModel: laneModel) viewModel.
	self assert: taskController diagramElement owningElement equals: (diagramController controllerForModel: laneModel) diagramElement.
	self assert: taskController diagramElement isRendered
]

{ #category : 'tests' }
OPBPMNLaneControllerTest >> testAddLaneTargetingExistingLaneInsertsBeforeOrAfterBasedOnPosition [
	| poolModel firstLaneModel secondLaneModel newLaneControllerBefore newLaneControllerAfter poolController poolShape clickAboveCenter clickBelowCenter |
	poolModel := OPBPMNPoolModel new name: 'Process Pool'.
	firstLaneModel := OPBPMNLaneModel new name: 'Lane 1'.
	secondLaneModel := OPBPMNLaneModel new name: 'Lane 2'.
	poolModel addLane: firstLaneModel.
	poolModel addLane: secondLaneModel.
	diagramController model add: poolModel.

	poolController := OPBPMNPoolController new.
	poolController diagramController: diagramController.
	poolController model: poolModel.
	diagramController addController: poolController.
	poolController
		createDiagramElement;
		renderDiagramElement.
	diagramController showAllElements.
	poolController modelChanged.

	controller := diagramController controllerForModel: secondLaneModel.
	poolShape := poolController diagramElement.

	clickAboveCenter := controller diagramElement roassalShape position - (0 @ 30).
	newLaneControllerBefore := OPBPMNLaneController new.
	controller addAsTargetFor: newLaneControllerBefore onPosition: clickAboveCenter.

	self assert: (poolModel lanes collect: [ :eachLane | eachLane name ]) asArray
		equals: #('Lane 1' '' 'Lane 2').

	clickBelowCenter := controller diagramElement roassalShape position + (0 @ 30).
	newLaneControllerAfter := OPBPMNLaneController new.
	controller addAsTargetFor: newLaneControllerAfter onPosition: clickBelowCenter.

	self assert: (poolModel lanes collect: [ :eachLane | eachLane name ]) asArray
		equals: #('Lane 1' '' 'Lane 2' '')
]

{ #category : 'tests' }
OPBPMNLaneControllerTest >> testCanBeTargetForLaneController [
	self assert: (controller canBeTargetFor: OPBPMNLaneController new)
]

{ #category : 'tests' }
OPBPMNLaneControllerTest >> testMoveLaneSeparatorUpdatesLaneHeightsAndSupportsUndoRedo [
	| poolModel firstLaneModel secondLaneModel firstTaskModel secondTaskModel poolController firstLaneController secondLaneController firstTaskController secondTaskController firstTaskInitialPosition secondTaskInitialPosition initialFirstHeight initialSecondHeight accumulatedDelta |
	poolModel := OPBPMNPoolModel new name: 'Order Fulfillment'.
	firstLaneModel := OPBPMNLaneModel new name: 'Sales'.
	secondLaneModel := OPBPMNLaneModel new name: 'Warehouse'.
	firstTaskModel := OPBPMNActivityModel new name: 'Check Stock'.
	secondTaskModel := OPBPMNActivityModel new name: 'Ship Items'.

	firstLaneModel add: firstTaskModel.
	secondLaneModel add: secondTaskModel.
	poolModel addLane: firstLaneModel.
	poolModel addLane: secondLaneModel.

	diagramController model add: poolModel.
	diagramController showAllElements.

	poolController := diagramController controllerForModel: poolModel.
	poolController modelChanged.

	firstLaneController := diagramController controllerForModel: firstLaneModel.
	secondLaneController := diagramController controllerForModel: secondLaneModel.
	firstTaskController := diagramController controllerForModel: firstTaskModel.
	secondTaskController := diagramController controllerForModel: secondTaskModel.

	firstTaskInitialPosition := firstTaskController diagramElement roassalShape position copy.
	secondTaskInitialPosition := secondTaskController diagramElement roassalShape position copy.

	initialFirstHeight := firstLaneController diagramElement laneHeight.
	initialSecondHeight := secondLaneController diagramElement laneHeight.
	self assert: initialFirstHeight equals: 220.
	self assert: initialSecondHeight equals: 220.

	accumulatedDelta := 30.
	firstLaneController moveSeparatorBy: accumulatedDelta.

	self assert: firstLaneController diagramElement laneHeight equals: initialFirstHeight + accumulatedDelta.
	self assert: secondLaneController diagramElement laneHeight equals: initialSecondHeight - accumulatedDelta.
	self assert: (firstTaskController diagramElement roassalShape position - firstTaskInitialPosition) equals: (0 @ 0).
	self assert: (secondTaskController diagramElement roassalShape position - secondTaskInitialPosition) equals: (0 @ 0).

	firstLaneController undoManager undo.
	self assert: firstLaneController diagramElement laneHeight equals: initialFirstHeight.
	self assert: secondLaneController diagramElement laneHeight equals: initialSecondHeight.

	firstLaneController undoManager redo.
	self assert: firstLaneController diagramElement laneHeight equals: initialFirstHeight + accumulatedDelta.
	self assert: secondLaneController diagramElement laneHeight equals: initialSecondHeight - accumulatedDelta
]

{ #category : 'tests' }
OPBPMNLaneControllerTest >> testRemoveLastLaneMigratesContainedElementsToPoolAndSupportsUndoRedo [
	| poolModel laneModel firstTaskModel secondTaskModel flowModel annotationModel laneAssociationModel poolController firstTaskController secondTaskController restoredLaneController |
	poolModel := OPBPMNPoolModel new name: 'Order Fulfillment'.
	laneModel := OPBPMNLaneModel new name: 'Sales'.
	firstTaskModel := OPBPMNActivityModel new name: 'Check Stock'.
	secondTaskModel := OPBPMNActivityModel new name: 'Ship Order'.
	flowModel := (OPBPMNFlowModel from: firstTaskModel to: secondTaskModel)
		name: '';
		type: 'Normal';
		yourself.
	firstTaskModel addFlow: flowModel.
	secondTaskModel addFlow: flowModel.
	annotationModel := OPBPMNAnnotationModel new text: 'Lane Note'.
	laneAssociationModel := OPBPMNAssociationModel new
		source: annotationModel;
		target: laneModel;
		yourself.
	annotationModel addAssociation: laneAssociationModel.
	laneModel addAssociation: laneAssociationModel.

	poolModel addLane: laneModel.
	laneModel
		add: firstTaskModel;
		add: secondTaskModel;
		add: annotationModel.
	diagramController model add: poolModel.
	diagramController showAllElements.

	poolController := diagramController controllerForModel: poolModel.
	controller := diagramController controllerForModel: laneModel.
	firstTaskController := diagramController controllerForModel: firstTaskModel.
	secondTaskController := diagramController controllerForModel: secondTaskModel.

	self assert: firstTaskController diagramElement owningElement equals: controller diagramElement.
	self assert: secondTaskController diagramElement owningElement equals: controller diagramElement.
	self assert: firstTaskController diagramElement isRendered.

	diagramController removeModelElement: laneModel.

	self deny: poolModel hasLanes.
	self assertCollection: poolModel elements includesAll: { firstTaskModel . secondTaskModel . annotationModel }.
	self assert: firstTaskModel owner equals: poolModel.
	self assert: secondTaskModel owner equals: poolModel.
	self assert: firstTaskController viewModel parentViewModel equals: poolController viewModel.
	self assertCollection: firstTaskModel outgoing includesAll: { flowModel }.
	self denyCollection: annotationModel associations includesAny: { laneAssociationModel }.
	self deny: (diagramController hasControllerForModel: laneAssociationModel).
	self assert: (diagramController hasControllerForModel: firstTaskModel).
	self assert: firstTaskController diagramElement isRendered.
	self assert: secondTaskController diagramElement isRendered.
	self assert: firstTaskController diagramElement owningElement equals: poolController diagramElement.
	self assert: secondTaskController diagramElement owningElement equals: poolController diagramElement.

	diagramController undo.

	self assert: (poolModel lanes includes: laneModel).
	self assert: firstTaskModel owner equals: laneModel.
	self assert: secondTaskModel owner equals: laneModel.
	restoredLaneController := diagramController controllerForModel: laneModel.
	self assert: firstTaskController viewModel parentViewModel equals: restoredLaneController viewModel.
	self assert: firstTaskController diagramElement isRendered.
	self assert: firstTaskController diagramElement owningElement equals: restoredLaneController diagramElement.
	self assert: secondTaskController diagramElement owningElement equals: restoredLaneController diagramElement.
	self assertCollection: annotationModel associations includesAll: { laneAssociationModel }.
	self assert: (diagramController hasControllerForModel: laneAssociationModel).

	diagramController redo.

	self deny: poolModel hasLanes.
	self assert: firstTaskModel owner equals: poolModel.
	self assert: secondTaskModel owner equals: poolModel.
	self assert: firstTaskController diagramElement isRendered.
	self assert: firstTaskController diagramElement owningElement equals: poolController diagramElement.
	self assert: secondTaskController diagramElement owningElement equals: poolController diagramElement
]
