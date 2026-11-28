"
Verifies visual rendering, header orientation, and label interaction behavior for BPMN pool shapes.
"
Class {
	#name : 'OPBPMNPoolShapeTest',
	#superclass : 'TestCase',
	#category : 'OpenPonk-BPMN-Tests-DiagramElements',
	#package : 'OpenPonk-BPMN-Tests',
	#tag : 'DiagramElements'
}

{ #category : 'tests - interactions' }
OPBPMNPoolShapeTest >> testClickingNameLabelForwardsClickToRoassalShape [

	| poolShape forwardedEvents nameLabel |
	poolShape := OPBPMNPoolShape new.
	poolShape renderIn: RSCanvas new.
	nameLabel := poolShape instVarNamed: #nameLabel.
	forwardedEvents := OrderedCollection new.
	poolShape roassalShape when: RSMouseClick do: [ :eachEvent | forwardedEvents add: eachEvent ] for: self.
	nameLabel announce: (RSMouseClick new
			 shape: nameLabel;
			 yourself).
	self assert: forwardedEvents size equals: 1.
	self assert: forwardedEvents first shape identicalTo: poolShape roassalShape
]

{ #category : 'tests - lifecycle' }
OPBPMNPoolShapeTest >> testIsRemovingRenderIsFalseDuringExtentAdjustmentAndTrueDuringRemoveRender [

	| canvas poolModel lane1Model lane2Model poolShape laneShape1 laneShape2 observedDuringResize observedDuringRemove |
	canvas := RSCanvas new.
	poolModel := OPBPMNPoolModel new name: 'Pool'.
	lane1Model := OPBPMNLaneModel new name: 'Lane 1'.
	lane2Model := OPBPMNLaneModel new name: 'Lane 2'.
	poolModel
		addLane: lane1Model;
		addLane: lane2Model.

	poolShape := OPBPMNPoolShape new
		             modelElement: poolModel;
		             bounds: (OPNodeBounds withPosition: 0 @ 0 extent: 600 @ 440);
		             renderIn: canvas;
		             yourself.
	laneShape1 := OPBPMNLaneShape in: poolShape forModelElement: lane1Model.
	laneShape2 := OPBPMNLaneShape in: poolShape forModelElement: lane2Model.
	laneShape1 renderIn: canvas.
	laneShape2 renderIn: canvas.
	poolShape layoutLanes.

	observedDuringResize := true.
	poolShape roassalShape when: RSExtentChangedEvent do: [ observedDuringResize := poolShape isRemovingRender ] for: self.
	poolShape resizeToRectangle: (Rectangle center: 0 @ 0 extent: 600 @ 500).
	self deny: observedDuringResize description: 'Pool must not report removing render while resizing'.
	self deny: poolShape isRemovingRender description: 'Pool must not report removing render after resize'.

	observedDuringRemove := false.
	laneShape1 announcer
		when: OPDiagramElementRenderRemovedAnnouncement
		do: [ observedDuringRemove := poolShape isRemovingRender ]
		for: self.
	poolShape removeRender.
	self assert: observedDuringRemove description: 'Pool must report removing render while removing its render'.
	self deny: poolShape isRemovingRender description: 'Pool must reset isRemovingRender after removeRender finishes'
]

{ #category : 'tests - moving' }
OPBPMNPoolShapeTest >> testMovingPoolDoesNotChangeLaneHeights [

	| poolModel lane1Model lane2Model poolShape laneShape1 laneShape2 initialSeparatorY |
	poolModel := OPBPMNPoolModel new name: 'Pool'.
	lane1Model := OPBPMNLaneModel new name: 'Lane 1'.
	lane2Model := OPBPMNLaneModel new name: 'Lane 2'.
	poolModel addLane: lane1Model.
	poolModel addLane: lane2Model.

	poolShape := OPBPMNPoolShape new.
	poolShape modelElement: poolModel.
	poolShape bounds: (OPNodeBounds withPosition: 0 @ 0 extent: 600 @ 440).
	poolShape renderIn: RSCanvas new.

	laneShape1 := OPBPMNLaneShape new.
	laneShape1 modelElement: lane1Model.

	laneShape2 := OPBPMNLaneShape new.
	laneShape2 modelElement: lane2Model.

	poolShape ownedElements
		add: laneShape1;
		add: laneShape2.
	laneShape1 owningElement: poolShape.
	laneShape2 owningElement: poolShape.
	laneShape1 renderIn: poolShape canvas.
	laneShape2 renderIn: poolShape canvas.
	poolShape layoutLanes.

	initialSeparatorY := laneShape1 roassalShape encompassingRectangle bottom.

	"Simulate moving the pool on the canvas by 50 @ 50 without changing its extent"
	poolShape roassalShape translateTo: 50 @ 50.

	self assert: laneShape1 laneHeight equals: 220.
	self assert: laneShape2 laneHeight equals: 220.
	self assert: laneShape1 roassalShape encompassingRectangle bottom closeTo: initialSeparatorY + 50.
	self assert: laneShape2 roassalShape encompassingRectangle top closeTo: initialSeparatorY + 50
]

{ #category : 'tests - rendering' }
OPBPMNPoolShapeTest >> testPoolMinimumHeightBorderColorStrokeColorAndUnrenderedGuards [

	| poolShape canvas |
	poolShape := OPBPMNPoolShape new
		             modelElement: (OPBPMNPoolModel new
				              name: nil;
				              yourself);
		             yourself.
	self assert: OPBPMNPoolShape minimumHeight equals: 50.
	self assert: poolShape minimumHeight equals: 50.
	self assert: poolShape borderColor equals: Color black.

	poolShape
		strokeColor: Color red;
		adjustExtentToLanes;
		handlePositionChanged;
		updateNameArea;
		updateRenderFromBounds;
		resizeToRectangle: (0 @ 0 corner: 600 @ 200);
		adoptOwnedElementsIntoLane: OPBPMNLaneShape new.
	self deny: poolShape isRendered description: 'Unrendered pool guards must leave pool unrendered'.

	poolShape
		bounds: (OPNodeBounds withPosition: 100 @ 100 extent: 600 @ 200);
		updateRenderFromBounds.
	self deny: poolShape isRendered description: 'Updating render from bounds before render must leave pool unrendered'.
	self assert: poolShape bounds equals: (OPNodeBounds withPosition: 100 @ 100 extent: 600 @ 200).

	canvas := RSCanvas new.
	poolShape renderIn: canvas.
	self assert: (poolShape instVarNamed: #nameLabel) text equals: ''.

	poolShape strokeColor: Color red.
	self assert: poolShape borderColor equals: Color red.
	self assert: poolShape roassalShape borderColor equals: Color red.
	self assert: (poolShape instVarNamed: #nameAreaSeparator) color equals: Color red
]

{ #category : 'tests - rendering' }
OPBPMNPoolShapeTest >> testPoolSelectionDraggableInteractionIncludesInnerShapes [

	| canvas poolModel laneModel poolShape laneShape taskShape interaction draggedInnerShapes |
	canvas := RSCanvas new.
	poolModel := OPBPMNPoolModel new name: 'Pool'.
	laneModel := OPBPMNLaneModel new name: 'Lane 1'.
	poolModel addLane: laneModel.

	poolShape := OPBPMNPoolShape new
		             modelElement: poolModel;
		             renderIn: canvas;
		             yourself.
	laneShape := OPBPMNLaneShape in: poolShape forModelElement: laneModel.
	laneShape renderIn: canvas.
	taskShape := OPBPMNActivityShape in: laneShape forModelElement: (OPBPMNActivityModel new
			              name: 'Task';
			              yourself).
	taskShape renderIn: canvas.

	interaction := poolShape roassalShape propertyAt: OPRSSelectionDraggable.
	draggedInnerShapes := interaction shapesToDragInside: poolShape roassalShape.
	self assertCollection: draggedInnerShapes hasSameElements: { taskShape roassalShape }
]

{ #category : 'tests - resizing' }
OPBPMNPoolShapeTest >> testRemovingLaneShrinksPoolToRemainingLaneHeight [
	| poolModel lane1Model lane2Model poolShape laneShape1 laneShape2 |
	poolModel := OPBPMNPoolModel new name: 'Pool'.
	lane1Model := OPBPMNLaneModel new name: 'Lane 1'.
	lane2Model := OPBPMNLaneModel new name: 'Lane 2'.
	poolModel addLane: lane1Model.
	poolModel addLane: lane2Model.
	poolShape := OPBPMNPoolShape new.
	poolShape modelElement: poolModel.
	poolShape bounds: (OPNodeBounds withPosition: 0 @ 0 extent: 600 @ 320).
	poolShape renderIn: RSCanvas new.
	laneShape1 := OPBPMNLaneShape new.
	laneShape1 modelElement: lane1Model.
	laneShape2 := OPBPMNLaneShape new.
	laneShape2 modelElement: lane2Model.
	poolShape ownedElements
		add: laneShape1;
		add: laneShape2.
	laneShape1 owningElement: poolShape.
	laneShape2 owningElement: poolShape.
	laneShape1 renderIn: poolShape canvas.
	laneShape2 renderIn: poolShape canvas.
	laneShape1 laneHeight: 220.
	laneShape2 laneHeight: 100.
	poolShape adjustExtentToLanes.

	self assert: poolShape roassalShape height closeTo: 320 precision: 0.5.

	"Simulate removal of Lane 1 render from pool"
	laneShape1 removeRender.

	self assert: poolShape roassalShape height closeTo: 100 precision: 0.5
]

{ #category : 'tests - rendering' }
OPBPMNPoolShapeTest >> testResizeToRectangleWithoutLastRectangleAndProportionalLaneScaling [

	| canvas poolModel lane1Model lane2Model poolShape laneShape1 laneShape2 |
	canvas := RSCanvas new.
	poolModel := OPBPMNPoolModel new name: 'Pool'.
	lane1Model := OPBPMNLaneModel new name: 'Lane 1'.
	lane2Model := OPBPMNLaneModel new name: 'Lane 2'.
	poolModel
		addLane: lane1Model;
		addLane: lane2Model.

	poolShape := OPBPMNPoolShape new
		             modelElement: poolModel;
		             bounds: (OPNodeBounds withPosition: 0 @ 0 extent: 600 @ 440);
		             renderIn: canvas;
		             yourself.
	laneShape1 := OPBPMNLaneShape in: poolShape forModelElement: lane1Model.
	laneShape2 := OPBPMNLaneShape in: poolShape forModelElement: lane2Model.
	laneShape1 renderIn: canvas.
	laneShape2 renderIn: canvas.
	poolShape layoutLanes.

	poolShape lastRectangle: nil.
	poolShape resizeToRectangle: (Rectangle center: 0 @ 0 extent: 600 @ 660).

	self assert: poolShape roassalShape extent equals: 600 @ 660.
	self assert: laneShape1 laneHeight closeTo: 330 precision: 0.5.
	self assert: laneShape2 laneHeight closeTo: 330 precision: 0.5
]

{ #category : 'tests - resizing' }
OPBPMNPoolShapeTest >> testResizingPoolBottomEdgePastMinimumLaneHeightAndBackPreservesLaneHeight [

	| poolModel lane1Model lane2Model poolShape laneShape1 laneShape2 |
	poolModel := OPBPMNPoolModel new name: 'Pool'.
	lane1Model := OPBPMNLaneModel new name: 'Lane 1'.
	lane2Model := OPBPMNLaneModel new name: 'Lane 2'.
	poolModel addLane: lane1Model.
	poolModel addLane: lane2Model.
	poolShape := OPBPMNPoolShape new.
	poolShape modelElement: poolModel.
	poolShape bounds: (OPNodeBounds withPosition: 0 @ 0 extent: 600 @ 440).
	poolShape renderIn: RSCanvas new.
	laneShape1 := OPBPMNLaneShape new.
	laneShape1 modelElement: lane1Model.
	laneShape2 := OPBPMNLaneShape new.
	laneShape2 modelElement: lane2Model.
	poolShape ownedElements
		add: laneShape1;
		add: laneShape2.
	laneShape1 owningElement: poolShape.
	laneShape2 owningElement: poolShape.
	laneShape1 renderIn: poolShape canvas.
	laneShape2 renderIn: poolShape canvas.
	poolShape layoutLanes.
	"Shrink pool via bottom edge by 200 px (height from 440 to 240, bottom from 220 to 20)"
	poolShape roassalShape extent: 600 @ 240.
	poolShape roassalShape translateTo: 0 @ -100.
	"Expand back by 200 px (bottom back to 220)"
	poolShape roassalShape extent: 600 @ 440.
	poolShape roassalShape translateTo: 0 @ 0.
	self assert: laneShape2 laneHeight equals: 220.
	self assert: laneShape1 laneHeight equals: 220.
	self assert: laneShape2 roassalShape encompassingRectangle bottom closeTo: poolShape roassalShape encompassingRectangle bottom
]

{ #category : 'tests - resizing' }
OPBPMNPoolShapeTest >> testResizingPoolFromBottomEdgeExpandsLastLaneAndPreservesOtherLanes [

	| poolModel lane1Model lane2Model poolShape laneShape1 laneShape2 initialSeparatorY |
	poolModel := OPBPMNPoolModel new name: 'Pool'.
	lane1Model := OPBPMNLaneModel new name: 'Lane 1'.
	lane2Model := OPBPMNLaneModel new name: 'Lane 2'.
	poolModel addLane: lane1Model.
	poolModel addLane: lane2Model.

	poolShape := OPBPMNPoolShape new.
	poolShape modelElement: poolModel.
	poolShape bounds: (OPNodeBounds withPosition: 0 @ 0 extent: 600 @ 440).
	poolShape renderIn: RSCanvas new.

	laneShape1 := OPBPMNLaneShape new.
	laneShape1 modelElement: lane1Model.

	laneShape2 := OPBPMNLaneShape new.
	laneShape2 modelElement: lane2Model.

	poolShape ownedElements
		add: laneShape1;
		add: laneShape2.
	laneShape1 owningElement: poolShape.
	laneShape2 owningElement: poolShape.
	laneShape1 renderIn: poolShape canvas.
	laneShape2 renderIn: poolShape canvas.
	poolShape layoutLanes.

	initialSeparatorY := laneShape1 roassalShape encompassingRectangle bottom.
	self assert: initialSeparatorY closeTo: 0.

	"Simulate dragging the bottom edge in Roassal (moving bottom from 220 to 320 by 100 px downward)"
	poolShape roassalShape extent: 600 @ 540.
	poolShape roassalShape translateTo: 0 @ 50.

	self assert: laneShape1 laneHeight equals: 220.
	self assert: laneShape2 laneHeight equals: 320.
	self assert: laneShape1 roassalShape encompassingRectangle bottom closeTo: initialSeparatorY.
	self assert: laneShape2 roassalShape encompassingRectangle top closeTo: initialSeparatorY.
	self assert: laneShape2 roassalShape encompassingRectangle bottom closeTo: 320
]

{ #category : 'tests - resizing' }
OPBPMNPoolShapeTest >> testResizingPoolFromTopEdgeExpandsFirstLaneAndPreservesSeparatorPosition [

	| poolModel lane1Model lane2Model poolShape laneShape1 laneShape2 initialSeparatorY |
	poolModel := OPBPMNPoolModel new name: 'Pool'.
	lane1Model := OPBPMNLaneModel new name: 'Lane 1'.
	lane2Model := OPBPMNLaneModel new name: 'Lane 2'.
	poolModel addLane: lane1Model.
	poolModel addLane: lane2Model.

	poolShape := OPBPMNPoolShape new.
	poolShape modelElement: poolModel.
	poolShape bounds: (OPNodeBounds withPosition: 0 @ 0 extent: 600 @ 440).
	poolShape renderIn: RSCanvas new.

	laneShape1 := OPBPMNLaneShape new.
	laneShape1 modelElement: lane1Model.

	laneShape2 := OPBPMNLaneShape new.
	laneShape2 modelElement: lane2Model.

	poolShape ownedElements
		add: laneShape1;
		add: laneShape2.
	laneShape1 owningElement: poolShape.
	laneShape2 owningElement: poolShape.
	laneShape1 renderIn: poolShape canvas.
	laneShape2 renderIn: poolShape canvas.
	poolShape layoutLanes.

	initialSeparatorY := laneShape1 roassalShape encompassingRectangle bottom.
	self assert: initialSeparatorY closeTo: 0.

	"Simulate dragging the top edge in Roassal (moving top from -220 to -320 by 100 px upward)"
	poolShape roassalShape extent: 600 @ 540.
	poolShape roassalShape translateTo: 0 @ -50.

	self assert: laneShape1 laneHeight equals: 320.
	self assert: laneShape2 laneHeight equals: 220.
	self assert: laneShape1 roassalShape encompassingRectangle bottom closeTo: initialSeparatorY.
	self assert: laneShape2 roassalShape encompassingRectangle top closeTo: initialSeparatorY.
	self assert: laneShape2 roassalShape encompassingRectangle bottom closeTo: 220
]

{ #category : 'tests - resizing' }
OPBPMNPoolShapeTest >> testResizingPoolTopEdgePastMinimumLaneHeightAndBackPreservesLaneHeight [

	| poolModel lane1Model lane2Model poolShape laneShape1 laneShape2 |
	poolModel := OPBPMNPoolModel new name: 'Pool'.
	lane1Model := OPBPMNLaneModel new name: 'Lane 1'.
	lane2Model := OPBPMNLaneModel new name: 'Lane 2'.
	poolModel addLane: lane1Model.
	poolModel addLane: lane2Model.
	poolShape := OPBPMNPoolShape new.
	poolShape modelElement: poolModel.
	poolShape bounds: (OPNodeBounds withPosition: 0 @ 0 extent: 600 @ 440).
	poolShape renderIn: RSCanvas new.
	laneShape1 := OPBPMNLaneShape new.
	laneShape1 modelElement: lane1Model.
	laneShape2 := OPBPMNLaneShape new.
	laneShape2 modelElement: lane2Model.
	poolShape ownedElements
		add: laneShape1;
		add: laneShape2.
	laneShape1 owningElement: poolShape.
	laneShape2 owningElement: poolShape.
	laneShape1 renderIn: poolShape canvas.
	laneShape2 renderIn: poolShape canvas.
	poolShape layoutLanes.
	"Shrink pool via top edge by 200 px (height from 440 to 240, top from -220 to -20)"
	poolShape roassalShape extent: 600 @ 240.
	poolShape roassalShape translateTo: 0 @ 100.
	"Expand back by 200 px (top back to -220)"
	poolShape roassalShape extent: 600 @ 440.
	poolShape roassalShape translateTo: 0 @ 0.
	self assert: laneShape1 laneHeight equals: 220.
	self assert: laneShape2 laneHeight equals: 220.
	self assert: laneShape1 roassalShape encompassingRectangle top closeTo: poolShape roassalShape encompassingRectangle top
]

{ #category : 'tests - resizing' }
OPBPMNPoolShapeTest >> testResizingPoolWidthPreservesLaneHeights [

	| poolModel lane1Model lane2Model poolShape laneShape1 laneShape2 initialSeparatorY |
	poolModel := OPBPMNPoolModel new name: 'Pool'.
	lane1Model := OPBPMNLaneModel new name: 'Lane 1'.
	lane2Model := OPBPMNLaneModel new name: 'Lane 2'.
	poolModel addLane: lane1Model.
	poolModel addLane: lane2Model.

	poolShape := OPBPMNPoolShape new.
	poolShape modelElement: poolModel.
	poolShape bounds: (OPNodeBounds withPosition: 0 @ 0 extent: 600 @ 440).
	poolShape renderIn: RSCanvas new.

	laneShape1 := OPBPMNLaneShape new.
	laneShape1 modelElement: lane1Model.

	laneShape2 := OPBPMNLaneShape new.
	laneShape2 modelElement: lane2Model.

	poolShape ownedElements
		add: laneShape1;
		add: laneShape2.
	laneShape1 owningElement: poolShape.
	laneShape2 owningElement: poolShape.
	laneShape1 renderIn: poolShape canvas.
	laneShape2 renderIn: poolShape canvas.
	poolShape layoutLanes.

	initialSeparatorY := laneShape1 roassalShape encompassingRectangle bottom.

	"Simulate widening the pool to the right by 100 px (extent: 700@440, translateTo: 50@0)"
	poolShape roassalShape extent: 700 @ 440.
	poolShape roassalShape translateTo: 50 @ 0.

	self assert: laneShape1 laneHeight equals: 220.
	self assert: laneShape2 laneHeight equals: 220.
	self assert: laneShape1 roassalShape encompassingRectangle bottom closeTo: initialSeparatorY.
	self assert: laneShape2 roassalShape encompassingRectangle top closeTo: initialSeparatorY.
	self assert: laneShape1 roassalShape width closeTo: 700 - poolShape nameAreaWidth.
	self assert: laneShape2 roassalShape width closeTo: 700 - poolShape nameAreaWidth
]

{ #category : 'tests - resizing' }
OPBPMNPoolShapeTest >> testTranslatingAndResizingWidthDoesNotChangeLaneHeights [

	| poolModel lane1Model lane2Model poolShape laneShape1 laneShape2 initialSeparatorY |
	poolModel := OPBPMNPoolModel new name: 'Pool'.
	lane1Model := OPBPMNLaneModel new name: 'Lane 1'.
	lane2Model := OPBPMNLaneModel new name: 'Lane 2'.
	poolModel addLane: lane1Model.
	poolModel addLane: lane2Model.
	poolShape := OPBPMNPoolShape new.
	poolShape modelElement: poolModel.
	poolShape bounds: (OPNodeBounds withPosition: 0 @ 0 extent: 600 @ 440).
	poolShape renderIn: RSCanvas new.
	laneShape1 := OPBPMNLaneShape new.
	laneShape1 modelElement: lane1Model.
	laneShape2 := OPBPMNLaneShape new.
	laneShape2 modelElement: lane2Model.
	poolShape ownedElements
		add: laneShape1;
		add: laneShape2.
	laneShape1 owningElement: poolShape.
	laneShape2 owningElement: poolShape.
	laneShape1 renderIn: poolShape canvas.
	laneShape2 renderIn: poolShape canvas.
	poolShape layoutLanes.
	initialSeparatorY := laneShape1 roassalShape encompassingRectangle bottom.
	"Simulate translating by 100 px in Y and resizing width by 100 px without changing height"
	poolShape resizeToRectangle: (Rectangle center: 50 @ 100 extent: 700 @ 440).
	self assert: laneShape1 laneHeight equals: 220.
	self assert: laneShape2 laneHeight equals: 220.
	self assert: laneShape1 roassalShape encompassingRectangle bottom closeTo: initialSeparatorY + 100.
	self assert: laneShape2 roassalShape encompassingRectangle top closeTo: initialSeparatorY + 100
]

{ #category : 'tests - undo' }
OPBPMNPoolShapeTest >> testUndoRemovePoolPreservesLaneOrder [

	| model project diagram undoManager projectController diagramController poolController poolModel removeCmd restoredPoolController restoredPoolModel |
	model := OPBPMNExamples exampleOrderFulfillment.
	project := OPProject new
		           addModel: model;
		           yourself.
	diagram := OPOpenPonkDiagram forModelElement: model.
	project addDiagram: diagram.
	undoManager := OPUndoManager new.
	projectController := OPProjectController forProject: project.
	projectController instVarNamed: #undoManager put: undoManager.
	diagramController := OPBPMNDiagramController new.
	projectController addDiagramController: diagramController.
	diagramController
		canvasPresenter: (OPCanvasPresenter new
				 canvas: RSCanvas new;
				 yourself);
		diagramElement: diagram;
		model: model.
	diagramController showAllElements.

	poolController := diagramController controllers detect: [ :each |
		                  (each isKindOf: OPBPMNPoolController) and: [ each model name = 'Order Fulfillment' ] ].
	poolModel := poolController model.

	self assert: (poolModel lanes collect: #name as: Array) equals: #( 'Sales' 'Warehouse' ).

	undoManager inTransaction: [
			removeCmd := OPRemoveModelElementCommand model: poolModel projectController: projectController.
			undoManager execute: removeCmd ].

	self assert: undoManager undoStack size equals: 1.
	self assert: undoManager canUndo description: 'Removing pool inside transaction must record an undoable command'.
	undoManager undo.

	restoredPoolController := diagramController controllers
		                          detect: [ :each |
		                          (each isKindOf: OPBPMNPoolController) and: [ each model name = 'Order Fulfillment' ] ]
		                          ifNone: [ nil ].
	self assert: restoredPoolController class identicalTo: OPBPMNPoolController.

	restoredPoolModel := restoredPoolController model.
	self assert: (restoredPoolModel lanes collect: #name as: Array) equals: #( 'Sales' 'Warehouse' )
]
