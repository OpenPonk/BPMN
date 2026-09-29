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
