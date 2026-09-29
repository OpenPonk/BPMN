"
I am a unit test class verifying the behavior of OPBPMNPoolController, specifically testing parent assignments, structural containment, and figure refreshes.
"
Class {
	#name : 'OPBPMNPoolControllerTest',
	#superclass : 'OPBPMNSemanticNodeControllerTest',
	#category : 'OpenPonk-BPMN-Tests',
	#package : 'OpenPonk-BPMN',
	#tag : 'Tests'
}

{ #category : 'constants' }
OPBPMNPoolControllerTest class >> diagramElementClass [
	^ OPBPMNPoolShape
]

{ #category : 'constants' }
OPBPMNPoolControllerTest >> controllerClass [
	^ OPBPMNPoolController 
]

{ #category : 'constants' }
OPBPMNPoolControllerTest >> modelClass [
	^ OPBPMNPoolModel 
]

{ #category : 'tests' }
OPBPMNPoolControllerTest >> testAddLaneAsTargetAlignsWithinPoolAndSupportsUndoRedo [
	"Verify that adding a lane from palette positions it within the pool and supports undo/redo without errors."
	| poolModel poolShape laneController laneShape undoManager expectedLaneWidth expectedLaneHeight expectedLaneCenterX expectedLaneCenterY |
	poolModel := OPBPMNPoolModel new name: 'Order Fulfillment'.
	diagramController model add: poolModel.
	controller model: poolModel.
	diagramController addController: controller.
	controller
		createDiagramElement;
		renderDiagramElement.
	diagramController showAllElements.
	

	poolShape := controller diagramElement.
	undoManager := diagramController undoManager.
	undoManager ifNil: [
		diagramController projectController ifNotNil: [ :projectController |
			projectController instVarNamed: #undoManager put: OPUndoManager new.
			undoManager := diagramController undoManager ] ].

	laneController := OPBPMNLaneController new.
	controller addAsTargetFor: laneController onPosition: (100 @ 100).

	laneShape := laneController diagramElement.
	self assert: laneShape isRendered.
	expectedLaneWidth := poolShape roassalShape width - poolShape nameAreaWidth.
	expectedLaneHeight := poolShape roassalShape height.
	expectedLaneCenterX := poolShape roassalShape position x - (poolShape roassalShape width / 2) + poolShape nameAreaWidth + (expectedLaneWidth / 2).
	expectedLaneCenterY := poolShape roassalShape position y.

	self assert: laneShape roassalShape position x equals: expectedLaneCenterX.
	self assert: laneShape roassalShape position y equals: expectedLaneCenterY.
	self assert: laneShape roassalShape extent equals: expectedLaneWidth @ expectedLaneHeight.

	undoManager undo.
	self assert: poolModel lanes isEmpty.
	self assert: poolShape laneShapes isEmpty.

	undoManager redo.
	self assert: poolModel lanes size equals: 1.
	self assert: poolShape laneShapes size equals: 1.
	self assert: poolShape laneShapes first roassalShape position x equals: expectedLaneCenterX
]

{ #category : 'tests' }
OPBPMNPoolControllerTest >> testAddingLaneDoesNotDisplaceFlowNodesInExistingLanes [
	| poolModel salesLaneModel warehouseLaneModel taskModel poolShape salesLaneShape taskShape initialTaskOffset newLaneController finalTaskOffset |
	poolModel := OPBPMNPoolModel new name: 'Order Fulfillment'.
	salesLaneModel := OPBPMNLaneModel new name: 'Sales'.
	warehouseLaneModel := OPBPMNLaneModel new name: 'Warehouse'.
	taskModel := OPBPMNActivityModel new name: 'Check Stock'.

	salesLaneModel add: taskModel.
	poolModel addLane: salesLaneModel.
	poolModel addLane: warehouseLaneModel.

	diagramController model add: poolModel.
	controller model: poolModel.
	diagramController addController: controller.
	controller
		createDiagramElement;
		renderDiagramElement.
	diagramController showAllElements.
	

	poolShape := controller diagramElement.
	salesLaneShape := (diagramController controllerForModel: salesLaneModel) diagramElement.
	taskShape := (diagramController controllerForModel: taskModel) diagramElement.

	initialTaskOffset := taskShape roassalShape position - ((salesLaneShape roassalShape position x - (salesLaneShape roassalShape width / 2)) @ (salesLaneShape roassalShape position y - (salesLaneShape roassalShape height / 2))).

	newLaneController := OPBPMNLaneController new.
	controller addAsTargetFor: newLaneController onPosition: (100 @ 800).

	finalTaskOffset := taskShape roassalShape position - ((salesLaneShape roassalShape position x - (salesLaneShape roassalShape width / 2)) @ (salesLaneShape roassalShape position y - (salesLaneShape roassalShape height / 2))).

	self assert: finalTaskOffset equals: initialTaskOffset
]

{ #category : 'tests' }
OPBPMNPoolControllerTest >> testAddingLaneInMiddleDisplacesFlowNodesInSubsequentLanes [
	| poolModel firstLaneModel secondLaneModel newLaneModel taskModel secondLaneController taskController initialTaskPosition expectedTaskPosition |
	poolModel := OPBPMNPoolModel new name: 'Order Fulfillment'.
	firstLaneModel := OPBPMNLaneModel new name: 'Sales'.
	secondLaneModel := OPBPMNLaneModel new name: 'Warehouse'.
	taskModel := OPBPMNActivityModel new name: 'Check Stock'.
	secondLaneModel add: taskModel.
	poolModel addLane: firstLaneModel.
	poolModel addLane: secondLaneModel.

	diagramController model add: poolModel.
	controller model: poolModel.
	diagramController addController: controller.
	controller
		createDiagramElement;
		renderDiagramElement.
	diagramController showAllElements.
	

	secondLaneController := diagramController controllerForModel: secondLaneModel.
	taskController := diagramController controllerForModel: taskModel.
	initialTaskPosition := taskController diagramElement roassalShape position copy.

	"Insert new lane at index 2 (between Sales and Warehouse)"
	newLaneModel := OPBPMNLaneModel new name: 'Marketing'.
	poolModel addLane: newLaneModel before: secondLaneModel.
	diagramController showAllElements.
	

	expectedTaskPosition := initialTaskPosition + (0 @ 220).

	self 
		assert: taskController diagramElement roassalShape position 
		equals: expectedTaskPosition
]

{ #category : 'tests' }
OPBPMNPoolControllerTest >> testAssignmentToParent [
	"not by pool"
]

{ #category : 'tests - targeting' }
OPBPMNPoolControllerTest >> testCanBeTargetForLaneControllerEvenWhenPoolHasLanes [
	| poolModel laneController |
	poolModel := OPBPMNPoolModel new name: 'TestPool'.
	poolModel addLane: (OPBPMNLaneModel new name: 'ExistingLane').
	controller model: poolModel.
	laneController := OPBPMNLaneController new.
	self assert: (controller canBeTargetFor: laneController)
]

{ #category : 'tests - targeting' }
OPBPMNPoolControllerTest >> testCannotBeTargetForFlowNodeWhenPoolHasLanes [
	| poolModel laneModel activityController |
	poolModel := OPBPMNPoolModel new name: 'TestPool'.
	laneModel := OPBPMNLaneModel new name: 'TestLane'.
	poolModel addLane: laneModel.
	controller model: poolModel.
	activityController := OPBPMNActivityController new.
	self deny: (controller canBeTargetFor: activityController)
]

{ #category : 'tests' }
OPBPMNPoolControllerTest >> testFigureRefresh [

	| text |
	controller createModelIn: diagramController model.
	diagramController addController: controller.
	controller
		createDiagramElement;
		renderDiagramElement.
	self assert: controller diagramElement nameLabel text equals: ''.
	controller model name: 'new name'.
	
	text := controller diagramElement nameLabel text.
	self assert:
		((text last: 8) = 'new name' or: [ (text first: 8) = 'new name' ])
]

{ #category : 'tests' }
OPBPMNPoolControllerTest >> testFlowNodesDisplacedWhenLaneRelocatedInLayout [

	| poolModel firstLaneModel secondLaneModel taskModel secondLaneController taskController initialTaskPosition lanePositionDelta expectedTaskPosition initialLanePosition |
	poolModel := OPBPMNPoolModel new name: 'Order Fulfillment'.
	firstLaneModel := OPBPMNLaneModel new name: 'Sales'.
	secondLaneModel := OPBPMNLaneModel new name: 'Warehouse'.
	taskModel := OPBPMNActivityModel new name: 'Ship Goods'.
	secondLaneModel add: taskModel.
	poolModel addLane: firstLaneModel.
	poolModel addLane: secondLaneModel.
	diagramController model add: poolModel.
	controller model: poolModel.
	diagramController addController: controller.
	controller
		createDiagramElement;
		renderDiagramElement.
	diagramController showAllElements.
	

	secondLaneController := diagramController controllerForModel: secondLaneModel.
	taskController := diagramController controllerForModel: taskModel.
	initialLanePosition := secondLaneController diagramElement roassalShape position.
	initialTaskPosition := taskController diagramElement roassalShape position.

	poolModel removeLane: firstLaneModel.

	lanePositionDelta := secondLaneController diagramElement roassalShape position - initialLanePosition.
	expectedTaskPosition := initialTaskPosition + lanePositionDelta.
	self assert: lanePositionDelta y equals: -220.
	self assert: taskController diagramElement roassalShape position equals: expectedTaskPosition
]

{ #category : 'tests' }
OPBPMNPoolControllerTest >> testMovingPoolDragsAllContainedLanes [
	| poolModel laneModel poolShape laneController laneShape initialLanePosition dragDelta |
	poolModel := OPBPMNPoolModel new name: 'Order Fulfillment'.
	laneModel := OPBPMNLaneModel new name: 'Sales'.
	poolModel addLane: laneModel.
	diagramController model add: poolModel.
	controller model: poolModel.
	diagramController addController: controller.
	controller
		createDiagramElement;
		renderDiagramElement.
	diagramController showAllElements.
	

	laneController := diagramController controllerForModel: laneModel.
	poolShape := controller diagramElement.
	laneShape := laneController diagramElement roassalShape.
	initialLanePosition := laneShape position copy.

	self deny: (poolShape innerDraggableRoassalShapes includes: laneShape).

	dragDelta := 50 @ 30.
	poolShape roassalShape translateBy: dragDelta.

	self assert: laneShape position equals: initialLanePosition + dragDelta
]

{ #category : 'tests' }
OPBPMNPoolControllerTest >> testPoolExpandsDownwardsWhenAddingSubsequentLanes [
	| poolModel firstLaneModel secondLaneModel poolShape initialHeight newHeight initialCenter newCenter |
	poolModel := OPBPMNPoolModel new name: 'Order Fulfillment'.
	firstLaneModel := OPBPMNLaneModel new name: 'Sales'.
	poolModel addLane: firstLaneModel.
	diagramController model add: poolModel.
	controller model: poolModel.
	diagramController addController: controller.
	controller
		createDiagramElement;
		renderDiagramElement.
	diagramController showAllElements.

	poolShape := controller diagramElement.
	initialHeight := poolShape roassalShape height.
	initialCenter := poolShape roassalShape position.

	secondLaneModel := OPBPMNLaneModel new name: 'Warehouse'.
	poolModel addLane: secondLaneModel.
	diagramController showAllElements.

	newHeight := poolShape roassalShape height.
	newCenter := poolShape roassalShape position.
	self assert: newHeight equals: initialHeight + 220.
	self assert: newCenter y equals: initialCenter y + (220 / 2)
]

{ #category : 'tests' }
OPBPMNPoolControllerTest >> testPoolShrinksUpwardsWhenRemovingLaneWithRemainingLanes [
	| poolModel firstLaneModel secondLaneModel poolShape initialHeight newHeight initialCenter newCenter |
	poolModel := OPBPMNPoolModel new name: 'Order Fulfillment'.
	firstLaneModel := OPBPMNLaneModel new name: 'Sales'.
	secondLaneModel := OPBPMNLaneModel new name: 'Warehouse'.
	poolModel addLane: firstLaneModel.
	poolModel addLane: secondLaneModel.
	diagramController model add: poolModel.
	controller model: poolModel.
	diagramController addController: controller.
	controller
		createDiagramElement;
		renderDiagramElement.
	diagramController showAllElements.
	
	
	poolShape := controller diagramElement.
	initialHeight := poolShape roassalShape height.
	initialCenter := poolShape roassalShape position.
	
	poolModel removeLane: secondLaneModel.
	
	
	newHeight := poolShape roassalShape height.
	newCenter := poolShape roassalShape position.
	self assert: newHeight equals: initialHeight - 220.
	self assert: newCenter y equals: initialCenter y - (220 / 2)
]

{ #category : 'tests' }
OPBPMNPoolControllerTest >> testRemovingLaneInMiddleDisplacesFlowNodesUpwardInSubsequentLanes [
	| poolModel firstLaneModel secondLaneModel thirdLaneModel taskModel thirdLaneController taskController initialTaskPosition expectedTaskPosition |
	poolModel := OPBPMNPoolModel new name: 'Order Fulfillment'.
	firstLaneModel := OPBPMNLaneModel new name: 'Sales'.
	secondLaneModel := OPBPMNLaneModel new name: 'Quality'.
	thirdLaneModel := OPBPMNLaneModel new name: 'Warehouse'.
	taskModel := OPBPMNActivityModel new name: 'Ship Goods'.
	thirdLaneModel add: taskModel.
	poolModel addLane: firstLaneModel.
	poolModel addLane: secondLaneModel.
	poolModel addLane: thirdLaneModel.

	diagramController model add: poolModel.
	controller model: poolModel.
	diagramController addController: controller.
	controller
		createDiagramElement;
		renderDiagramElement.
	diagramController showAllElements.
	

	thirdLaneController := diagramController controllerForModel: thirdLaneModel.
	taskController := diagramController controllerForModel: taskModel.
	initialTaskPosition := taskController diagramElement roassalShape position copy.

	"Remove middle lane (Quality)"
	poolModel removeLane: secondLaneModel.
	

	expectedTaskPosition := initialTaskPosition - (0 @ 220).

	self 
		assert: taskController diagramElement roassalShape position 
		equals: expectedTaskPosition
]

{ #category : 'tests - resizing' }
OPBPMNPoolControllerTest >> testResizingPoolFromLeftEdgeDoesNotDisplaceFlowNodesInLane [
	| poolModel laneModel taskModel poolShape taskShape initialTaskPosition resizableInteraction leftHandle dragEvent |
	poolModel := OPBPMNPoolModel new name: 'Order Fulfillment'.
	laneModel := OPBPMNLaneModel new name: 'Sales'.
	taskModel := OPBPMNActivityModel new name: 'Check Stock'.
	laneModel add: taskModel.
	poolModel addLane: laneModel.

	diagramController model add: poolModel.
	controller model: poolModel.
	diagramController addController: controller.
	controller
		createDiagramElement;
		renderDiagramElement.
	diagramController showAllElements.

	poolShape := controller diagramElement.
	taskShape := (diagramController controllerForModel: taskModel) diagramElement.
	initialTaskPosition := taskShape roassalShape position copy.

	resizableInteraction := poolShape roassalShape propertyAt: OPRSResizable ifAbsent: [ nil ].
	self assert: resizableInteraction isNotNil.
	resizableInteraction showHandles: (RSSelectionChangedEvent new
		shape: poolShape roassalShape;
		canvas: poolShape roassalShape canvas;
		yourself).
	leftHandle := resizableInteraction handles
		detect: [ :eachHandle |
			eachHandle model ifNotNil: [ :handleModel |
				(handleModel respondsTo: #key) and: [ handleModel key = #leftCenter ] ] ifNil: [ false ] ]
		ifNone: [ nil ].
	self assert: leftHandle isNotNil.

	resizableInteraction handleDragStarted: nil.
	leftHandle position: (leftHandle position x - 80) @ leftHandle position y.
	dragEvent := RSMouseDragging new
		shape: leftHandle;
		position: leftHandle position;
		step: (-80 @ 0);
		yourself.
	resizableInteraction updateCurrentShape: dragEvent.
	resizableInteraction handleDragEnded: nil.

	self assert: taskShape roassalShape position equals: initialTaskPosition
]

{ #category : 'tests' }
OPBPMNPoolControllerTest >> testResizingPoolPreservesFlowNodesPositions [
	| poolModel firstLaneModel secondLaneModel firstTaskModel secondTaskModel poolShape firstLaneShape secondLaneShape firstTaskShape secondTaskShape firstTaskInitialPosition secondTaskInitialPosition resizableInteraction bottomCenterHandle dragEvent |
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
	controller model: poolModel.
	diagramController addController: controller.
	controller
		createDiagramElement;
		renderDiagramElement.
	diagramController showAllElements.
	

	poolShape := controller diagramElement.
	firstLaneShape := (diagramController controllerForModel: firstLaneModel) diagramElement.
	secondLaneShape := (diagramController controllerForModel: secondLaneModel) diagramElement.
	firstTaskShape := (diagramController controllerForModel: firstTaskModel) diagramElement.
	secondTaskShape := (diagramController controllerForModel: secondTaskModel) diagramElement.

	firstTaskInitialPosition := firstTaskShape roassalShape position copy.
	secondTaskInitialPosition := secondTaskShape roassalShape position copy.

	resizableInteraction := poolShape roassalShape propertyAt: OPRSResizable ifAbsent: [ nil ].
	self assert: resizableInteraction isNotNil description: 'Pool must have OPRSResizable interaction attached'.

	resizableInteraction showHandles: (RSSelectionChangedEvent new shape: poolShape roassalShape; canvas: poolShape roassalShape canvas; yourself).
	bottomCenterHandle := resizableInteraction handles
		detect: [ :eachHandle |
			eachHandle model ifNotNil: [ :handleModel |
				(handleModel respondsTo: #key) and: [ handleModel key = #bottomCenter ] ] ifNil: [ false ] ]
		ifNone: [ nil ].
	self assert: bottomCenterHandle isNotNil description: 'bottomCenter handle must be present on resizable pool'.

	resizableInteraction handleDragStarted: nil.
	bottomCenterHandle position: (bottomCenterHandle position x @ (bottomCenterHandle position y + 100)).
	dragEvent := RSMouseDragging new
		shape: bottomCenterHandle;
		position: bottomCenterHandle position;
		step: (0 @ 100);
		yourself.
	resizableInteraction updateCurrentShape: dragEvent.
	resizableInteraction handleDragEnded: nil.

	self assert: (firstTaskShape roassalShape position - firstTaskInitialPosition) equals: (0 @ 0).
	self assert: (secondTaskShape roassalShape position - secondTaskInitialPosition) equals: (0 @ 0)
]

{ #category : 'tests - resizing' }
OPBPMNPoolControllerTest >> testResizingPoolRelocatesLanes [
	| poolModel firstLaneModel secondLaneModel poolShape firstLaneController firstLaneShape initialFirstLaneHeight |
	poolModel := OPBPMNPoolModel new name: 'Order Fulfillment'.
	firstLaneModel := OPBPMNLaneModel new name: 'Sales'.
	secondLaneModel := OPBPMNLaneModel new name: 'Warehouse'.
	poolModel addLane: firstLaneModel.
	poolModel addLane: secondLaneModel.
	diagramController model add: poolModel.
	controller model: poolModel.
	diagramController addController: controller.
	controller
		createDiagramElement;
		renderDiagramElement.
	diagramController showAllElements.

	poolShape := controller diagramElement.
	poolShape layoutLanes.
	firstLaneController := diagramController controllerForModel: firstLaneModel.
	firstLaneShape := firstLaneController diagramElement roassalShape.
	initialFirstLaneHeight := firstLaneShape height.

	poolShape roassalShape extent: poolShape roassalShape width @ (poolShape roassalShape height + 100).
	poolShape roassalShape announce: (RSExtentChangedEvent new shape: poolShape roassalShape; oldExtent: poolShape roassalShape extent).

	"V Režimu A si pruhy zachovávají svou nastavenou výšku a nedeformují se proporcionálně"
	self assert: firstLaneShape height equals: initialFirstLaneHeight
]

{ #category : 'tests' }
OPBPMNPoolControllerTest >> testResizingPoolWidthPreservesFlowNodesDistanceFromLaneLeftEdge [
	| poolModel laneModel taskModel poolShape laneShape taskShape initialDistance laneLeftAfterResize |
	poolModel := OPBPMNPoolModel new name: 'Order Fulfillment'.
	laneModel := OPBPMNLaneModel new name: 'Sales'.
	taskModel := OPBPMNActivityModel new name: 'Process Order'.
	laneModel add: taskModel.
	poolModel addLane: laneModel.
	diagramController model add: poolModel.
	controller model: poolModel.
	diagramController addController: controller.
	controller
		createDiagramElement;
		renderDiagramElement.
	diagramController showAllElements.
	

	poolShape := controller diagramElement.
	laneShape := (diagramController controllerForModel: laneModel) diagramElement.
	taskShape := (diagramController controllerForModel: taskModel) diagramElement.

	initialDistance := taskShape roassalShape position x - (laneShape roassalShape position x - (laneShape roassalShape width / 2)).

	poolShape roassalShape
		extent: (poolShape roassalShape width + 100) @ poolShape roassalShape height;
		translateTo: (poolShape roassalShape position x + 50) @ poolShape roassalShape position y.
	poolShape layoutLanes.

	laneLeftAfterResize := laneShape roassalShape position x - (laneShape roassalShape width / 2).
	self assert: (taskShape roassalShape position x - laneLeftAfterResize) equals: initialDistance
]
