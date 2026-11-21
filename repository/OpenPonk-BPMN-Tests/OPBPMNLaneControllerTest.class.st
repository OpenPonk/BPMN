"
Verifies controller lifecycle, element migration between pools and lanes, and transactional undo/redo support for BPMN lanes.
"
Class {
	#name : 'OPBPMNLaneControllerTest',
	#superclass : 'OPBPMNNodeControllerTest',
	#category : 'OpenPonk-BPMN-Tests-Controllers',
	#package : 'OpenPonk-BPMN-Tests',
	#tag : 'Controllers'
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
OPBPMNLaneControllerTest >> testAddAsTargetForRejectsInvalidController [

	| poolModel laneModel laneController invalidController |
	poolModel := OPBPMNPoolModel new name: 'Order Fulfillment'.
	laneModel := OPBPMNLaneModel new name: 'Sales'.
	poolModel addLane: laneModel.
	diagramController model add: poolModel.
	diagramController showAllElements.

	laneController := diagramController controllerForModel: laneModel.
	invalidController := OPBPMNPoolController new.
	self should: [ laneController addAsTargetFor: invalidController onPosition: 0 @ 0 ] raise: Error
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
	self assert: taskController diagramElement roassalShape canvas identicalTo: diagramController canvas.

	laneController := OPBPMNLaneController new.
	poolController addAsTargetFor: laneController onPosition: 100 @ 100.
	laneModel := laneController model.
	self assertCollection: poolModel lanes includesAll: { laneModel }.
	self assert: taskModel owner equals: laneModel.
	self assert: taskController viewModel parentViewModel equals: laneController viewModel.
	self assert: taskController diagramElement owningElement equals: laneController diagramElement.
	self assert: taskController diagramElement roassalShape canvas identicalTo: diagramController canvas.

	diagramController undo.

	self assertEmpty: poolModel lanes.
	self deny: poolModel hasLanes description: 'Pool must not have lanes after undoing first lane addition'.
	self assert: taskModel owner equals: poolModel.
	self assert: taskController viewModel parentViewModel equals: poolController viewModel.
	self assert: taskController diagramElement owningElement equals: poolController diagramElement.
	self assert: taskController diagramElement roassalShape canvas identicalTo: diagramController canvas.

	diagramController redo.
	self assertCollection: poolModel lanes includesAll: { laneModel }.
	self assert: taskModel owner equals: laneModel.
	self assert: taskController viewModel parentViewModel equals: (diagramController controllerForModel: laneModel) viewModel.
	self assert: taskController diagramElement owningElement equals: (diagramController controllerForModel: laneModel) diagramElement.
	self assert: taskController diagramElement roassalShape canvas identicalTo: diagramController canvas
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

	self
		assert: (controller canBeTargetFor: OPBPMNLaneController new)
		description: 'Lane controller must accept another lane controller as drop target'
]

{ #category : 'tests' }
OPBPMNLaneControllerTest >> testCreateModelInDefaultsInsertBeforeToFalseWhenNil [

	| poolModel firstLaneModel secondLaneModel newLaneController |
	poolModel := OPBPMNPoolModel new name: 'Order Fulfillment'.
	firstLaneModel := OPBPMNLaneModel new name: 'Lane 1'.
	secondLaneModel := OPBPMNLaneModel new name: 'Lane 2'.
	poolModel
		addLane: firstLaneModel;
		addLane: secondLaneModel.
	diagramController model add: poolModel.

	newLaneController := OPBPMNLaneController new.
	newLaneController diagramController: diagramController.
	newLaneController configureInsertionTargetLane: firstLaneModel before: nil.
	newLaneController createModelIn: poolModel.

	self assert: (poolModel lanes collect: #name as: Array) equals: #( 'Lane 1' '' 'Lane 2' )
]

{ #category : 'tests' }
OPBPMNLaneControllerTest >> testDraggingLaneSeparatorOnCanvasUpdatesLaneHeightsAndSupportsUndoRedo [
	| poolModel firstLaneModel secondLaneModel firstTaskModel secondTaskModel poolController firstLaneController secondLaneController firstTaskController secondTaskController firstTaskInitialPosition secondTaskInitialPosition initialFirstHeight initialSecondHeight canvas selectable separatorPoint pixelPoint hitShape dragDelta |
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

	canvas := diagramController canvas.
	"Translate camera to verify no pixel-vs-space coordinate jump occurs on DragStart"
	canvas camera translateTo: 180 @ 120.

	selectable := firstLaneController roassalShape propertyAt: OPRSSelectable.
	selectable doHighlight: firstLaneController roassalShape.

	separatorPoint := firstLaneController diagramElement laneSeparator position.
	pixelPoint := canvas camera fromSpaceToPixel: separatorPoint.
	hitShape := canvas shapeWithAction: RSMouseLeftDragStart forPositionInPixels: pixelPoint.

	self assert: hitShape equals: firstLaneController diagramElement separatorHandle.

	dragDelta := 0 @ 40.
	"RSEventProcessor leaves position in pixels on DragStart, and converts to space with step on Dragging"
	hitShape announce: (RSMouseLeftDragStart new
		shape: hitShape;
		canvas: canvas;
		position: pixelPoint;
		yourself).
	hitShape announce: (RSMouseDragging new
		shape: hitShape;
		canvas: canvas;
		position: separatorPoint + dragDelta;
		step: dragDelta;
		yourself).
	hitShape announce: (RSMouseDragEnd new
		shape: hitShape;
		canvas: canvas;
		position: separatorPoint + dragDelta;
		yourself).

	self assert: firstLaneController diagramElement laneHeight equals: initialFirstHeight + 40.
	self assert: secondLaneController diagramElement laneHeight equals: initialSecondHeight - 40.
	self assert: hitShape position equals: firstLaneController diagramElement laneSeparator position.
	self assert: (firstTaskController diagramElement roassalShape position - firstTaskInitialPosition) equals: (0 @ 0).
	self assert: (secondTaskController diagramElement roassalShape position - secondTaskInitialPosition) equals: (0 @ 0).

	firstLaneController undoManager undo.
	self assert: firstLaneController diagramElement laneHeight equals: initialFirstHeight.
	self assert: secondLaneController diagramElement laneHeight equals: initialSecondHeight.
	self assert: hitShape position equals: firstLaneController diagramElement laneSeparator position.

	firstLaneController undoManager redo.
	self assert: firstLaneController diagramElement laneHeight equals: initialFirstHeight + 40.
	self assert: secondLaneController diagramElement laneHeight equals: initialSecondHeight - 40.
	self assert: hitShape position equals: firstLaneController diagramElement laneSeparator position
]

{ #category : 'tests' }
OPBPMNLaneControllerTest >> testDraggingLaneSeparatorRespectsMinimumLaneHeight [

	| poolModel firstLaneModel secondLaneModel poolController firstLaneController secondLaneController canvas selectable handle separatorPoint dragUpDelta dragDownDelta |
	poolModel := OPBPMNPoolModel new name: 'Order Fulfillment'.
	firstLaneModel := OPBPMNLaneModel new name: 'Sales'.
	secondLaneModel := OPBPMNLaneModel new name: 'Warehouse'.
	poolModel addLane: firstLaneModel.
	poolModel addLane: secondLaneModel.

	diagramController model add: poolModel.
	diagramController showAllElements.

	poolController := diagramController controllerForModel: poolModel.
	poolController modelChanged.

	firstLaneController := diagramController controllerForModel: firstLaneModel.
	secondLaneController := diagramController controllerForModel: secondLaneModel.

	canvas := diagramController canvas.
	selectable := secondLaneController roassalShape propertyAt: OPRSSelectable.
	selectable doHighlight: secondLaneController roassalShape.

	handle := firstLaneController diagramElement separatorHandle.
	self assert: handle class identicalTo: RSEllipse.
	self assert: handle canvas identicalTo: canvas.

	separatorPoint := firstLaneController diagramElement laneSeparator position.
	dragUpDelta := 0 @ -300.

	handle announce: (RSMouseLeftDragStart new
			 shape: handle;
			 canvas: canvas;
			 position: separatorPoint;
			 yourself).
	handle announce: (RSMouseDragging new
			 shape: handle;
			 canvas: canvas;
			 position: separatorPoint + dragUpDelta;
			 step: dragUpDelta;
			 yourself).
	handle announce: (RSMouseDragEnd new
			 shape: handle;
			 canvas: canvas;
			 position: separatorPoint + dragUpDelta;
			 yourself).

	self assert: firstLaneController diagramElement laneHeight equals: 50.
	self assert: secondLaneController diagramElement laneHeight equals: 390.

	"Verify handle can be dragged back down after clamping at minimumHeight"
	separatorPoint := firstLaneController diagramElement laneSeparator position.
	dragDownDelta := 0 @ 100.
	handle announce: (RSMouseLeftDragStart new
			 shape: handle;
			 canvas: canvas;
			 position: separatorPoint;
			 yourself).
	handle announce: (RSMouseDragging new
			 shape: handle;
			 canvas: canvas;
			 position: separatorPoint + dragDownDelta;
			 step: dragDownDelta;
			 yourself).
	handle announce: (RSMouseDragEnd new
			 shape: handle;
			 canvas: canvas;
			 position: separatorPoint + dragDownDelta;
			 yourself).

	self assert: firstLaneController diagramElement laneHeight equals: 150.
	self assert: secondLaneController diagramElement laneHeight equals: 290.

	firstLaneController undoManager undo.
	self assert: firstLaneController diagramElement laneHeight equals: 50.
	self assert: secondLaneController diagramElement laneHeight equals: 390.

	firstLaneController undoManager undo.
	self assert: firstLaneController diagramElement laneHeight equals: 220.
	self assert: secondLaneController diagramElement laneHeight equals: 220
]

{ #category : 'tests' }
OPBPMNLaneControllerTest >> testIntendedModelOfOwningDiagramElementFallsBackToOwner [

	| ownerActivityModel ownerActivityController orphanLaneModel orphanLaneController |
	ownerActivityModel := OPBPMNActivityModel new name: 'Detached Owner'.
	ownerActivityController := OPBPMNActivityController new.
	ownerActivityController
		diagramController: diagramController;
		model: ownerActivityModel.
	diagramController addController: ownerActivityController.

	orphanLaneModel := OPBPMNLaneModel new name: 'Orphan'.
	orphanLaneModel addedTo: ownerActivityModel.
	orphanLaneController := OPBPMNLaneController new.
	orphanLaneController
		diagramController: diagramController;
		model: orphanLaneModel.

	self assert: orphanLaneModel pool identicalTo: nil.
	self assert: orphanLaneController intendedModelOfOwningDiagramElement identicalTo: ownerActivityModel
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
OPBPMNLaneControllerTest >> testMoveSeparatorOnLastLaneIsNoOp [

	| poolModel firstLaneModel secondLaneModel secondLaneController initialHeight |
	poolModel := OPBPMNPoolModel new name: 'Order Fulfillment'.
	firstLaneModel := OPBPMNLaneModel new name: 'Sales'.
	secondLaneModel := OPBPMNLaneModel new name: 'Warehouse'.
	poolModel
		addLane: firstLaneModel;
		addLane: secondLaneModel.
	diagramController model add: poolModel.
	diagramController showAllElements.

	secondLaneController := diagramController controllerForModel: secondLaneModel.
	initialHeight := secondLaneController diagramElement laneHeight.
	secondLaneController undoManager clear.

	self assert: secondLaneController nextLaneController identicalTo: nil.
	secondLaneController moveSeparatorBy: 30.
	self assert: secondLaneController diagramElement laneHeight equals: initialHeight.
	self
		deny: secondLaneController undoManager canUndo
		description: 'Moving separator on the last lane must not record an undo command'
]

{ #category : 'tests' }
OPBPMNLaneControllerTest >> testNextLaneControllerReturnsNilWhenRemainingLanesAreHidden [

	| poolModel firstLaneModel hiddenLaneModel firstLaneController initialFirstHeight |
	poolModel := OPBPMNPoolModel new name: 'Order Fulfillment'.
	firstLaneModel := OPBPMNLaneModel new name: 'Sales'.
	hiddenLaneModel := OPBPMNLaneModel new name: 'Warehouse'.
	poolModel
		addLane: firstLaneModel;
		addLane: hiddenLaneModel.
	diagramController model add: poolModel.
	diagramController showAllElements.
	diagramController hideModelFromDiagram: hiddenLaneModel.

	firstLaneController := diagramController controllerForModel: firstLaneModel.
	initialFirstHeight := firstLaneController diagramElement laneHeight.
	firstLaneController undoManager clear.

	self assert: firstLaneController nextLaneController identicalTo: nil.
	firstLaneController moveSeparatorBy: 30.
	self assert: firstLaneController diagramElement laneHeight equals: initialFirstHeight.
	self
		deny: firstLaneController undoManager canUndo
		description: 'Moving separator with no visible next lane must not record an undo command'
]

{ #category : 'tests' }
OPBPMNLaneControllerTest >> testNextLaneControllerSkipsHiddenLanesAndMoveSeparatorResizesNextVisibleLane [

	| poolModel firstLaneModel hiddenLaneModel thirdLaneModel firstLaneController thirdLaneController initialFirstHeight initialThirdHeight |
	poolModel := OPBPMNPoolModel new name: 'Order Fulfillment'.
	firstLaneModel := OPBPMNLaneModel new name: 'Sales'.
	hiddenLaneModel := OPBPMNLaneModel new name: 'Quality'.
	thirdLaneModel := OPBPMNLaneModel new name: 'Warehouse'.
	poolModel
		addLane: firstLaneModel;
		addLane: hiddenLaneModel;
		addLane: thirdLaneModel.
	diagramController model add: poolModel.
	diagramController showAllElements.
	diagramController hideModelFromDiagram: hiddenLaneModel.

	firstLaneController := diagramController controllerForModel: firstLaneModel.
	thirdLaneController := diagramController controllerForModel: thirdLaneModel.
	initialFirstHeight := firstLaneController diagramElement laneHeight.
	initialThirdHeight := thirdLaneController diagramElement laneHeight.

	self assert: firstLaneController nextLaneController identicalTo: thirdLaneController.

	firstLaneController moveSeparatorBy: 30.
	self assert: firstLaneController diagramElement laneHeight equals: initialFirstHeight + 30.
	self assert: thirdLaneController diagramElement laneHeight equals: initialThirdHeight - 30.

	firstLaneController undoManager undo.
	self assert: firstLaneController diagramElement laneHeight equals: initialFirstHeight.
	self assert: thirdLaneController diagramElement laneHeight equals: initialThirdHeight
]

{ #category : 'tests' }
OPBPMNLaneControllerTest >> testNextLaneControllerWithDetachedAndOwnerFallback [

	| poolModel firstLaneModel secondLaneModel firstLaneController secondLaneController unlistedLaneModel unlistedLaneController detachedLaneModel detachedLaneController detachedViewModel |
	poolModel := OPBPMNPoolModel new name: 'Order Fulfillment'.
	firstLaneModel := OPBPMNLaneModel new name: 'Sales'.
	secondLaneModel := OPBPMNLaneModel new name: 'Warehouse'.
	poolModel
		addLane: firstLaneModel;
		addLane: secondLaneModel.
	diagramController model add: poolModel.
	diagramController showAllElements.

	firstLaneController := diagramController controllerForModel: firstLaneModel.
	secondLaneController := diagramController controllerForModel: secondLaneModel.
	firstLaneController viewModel parentViewModel.

	firstLaneModel addedTo: nil.
	self assert: firstLaneController nextLaneController identicalTo: secondLaneController.

	unlistedLaneModel := OPBPMNLaneModel new name: 'Unlisted'.
	unlistedLaneModel addedTo: poolModel.
	unlistedLaneController := OPBPMNLaneController new.
	unlistedLaneController
		diagramController: diagramController;
		model: unlistedLaneModel.
	self assert: unlistedLaneController nextLaneController identicalTo: nil.

	detachedLaneModel := OPBPMNLaneModel new name: 'Detached'.
	detachedViewModel := OPBPMNLaneViewModel new model: detachedLaneModel.
	detachedViewModel instVarNamed: #parentViewModel put: OPBPMNPoolViewModel new.
	detachedLaneController := OPBPMNLaneController new.
	detachedLaneController
		diagramController: diagramController;
		viewModel: detachedViewModel.
	self assert: detachedLaneController nextLaneController identicalTo: nil
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
	self assert: firstTaskController diagramElement roassalShape canvas identicalTo: diagramController canvas.

	diagramController removeModelElement: laneModel.

	self assertEmpty: poolModel lanes.
	self deny: poolModel hasLanes description: 'Pool must not have lanes after removing the last lane'.
	self assertCollection: poolModel elements includesAll: {
			firstTaskModel.
			secondTaskModel.
			annotationModel }.
	self assert: firstTaskModel owner equals: poolModel.
	self assert: secondTaskModel owner equals: poolModel.
	self assert: firstTaskController viewModel parentViewModel equals: poolController viewModel.
	self assertCollection: firstTaskModel outgoing includesAll: { flowModel }.
	self denyCollection: annotationModel associations includesAny: { laneAssociationModel }.
	self denyCollection: (diagramController controllers collect: #model) includesAny: { laneAssociationModel }.
	self
		deny: (diagramController hasControllerForModel: laneAssociationModel)
		description: 'Removed lane association controller must be unregistered'.
	self assertCollection: (diagramController controllers collect: #model) includesAll: { firstTaskModel }.
	self
		assert: (diagramController hasControllerForModel: firstTaskModel)
		description: 'Migrated task controller must stay registered in diagram controller'.
	self assert: firstTaskController diagramElement roassalShape canvas identicalTo: diagramController canvas.
	self assert: secondTaskController diagramElement roassalShape canvas identicalTo: diagramController canvas.
	self assert: firstTaskController diagramElement owningElement equals: poolController diagramElement.
	self assert: secondTaskController diagramElement owningElement equals: poolController diagramElement.

	diagramController undo.
	self assertCollection: poolModel lanes includesAll: { laneModel }.
	self assert: firstTaskModel owner equals: laneModel.
	self assert: secondTaskModel owner equals: laneModel.
	restoredLaneController := diagramController controllerForModel: laneModel.
	self assert: firstTaskController viewModel parentViewModel equals: restoredLaneController viewModel.
	self assert: firstTaskController diagramElement roassalShape canvas identicalTo: diagramController canvas.
	self assert: firstTaskController diagramElement owningElement equals: restoredLaneController diagramElement.
	self assert: secondTaskController diagramElement owningElement equals: restoredLaneController diagramElement.
	self assertCollection: annotationModel associations includesAll: { laneAssociationModel }.
	self assertCollection: (diagramController controllers collect: #model) includesAll: { laneAssociationModel }.
	self
		assert: (diagramController hasControllerForModel: laneAssociationModel)
		description: 'Undoing lane removal must restore lane association controller'.

	diagramController redo.

	self assertEmpty: poolModel lanes.
	self deny: poolModel hasLanes description: 'Pool must not have lanes after redoing last lane removal'.
	self assert: firstTaskModel owner equals: poolModel.
	self assert: secondTaskModel owner equals: poolModel.
	self assert: firstTaskController diagramElement roassalShape canvas identicalTo: diagramController canvas.
	self assert: firstTaskController diagramElement owningElement equals: poolController diagramElement.
	self assert: secondTaskController diagramElement owningElement equals: poolController diagramElement
]
