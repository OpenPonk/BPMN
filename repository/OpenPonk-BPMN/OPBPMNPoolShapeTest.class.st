Class {
	#name : 'OPBPMNPoolShapeTest',
	#superclass : 'TestCase',
	#category : 'OpenPonk-BPMN-Tests',
	#package : 'OpenPonk-BPMN',
	#tag : 'Tests'
}

{ #category : 'tests - interactions' }
OPBPMNPoolShapeTest >> testClickingNameLabelForwardsClickToRoassalShape [
	| poolShape clickAnnounced nameLabel |
	poolShape := OPBPMNPoolShape new.
	poolShape renderIn: RSCanvas new.
	nameLabel := poolShape instVarNamed: #nameLabel.
	clickAnnounced := false.
	poolShape roassalShape when: RSMouseClick do: [ clickAnnounced := true ] for: self.
	nameLabel announce: (RSMouseClick new shape: nameLabel; yourself).
	self assert: clickAnnounced
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

	"Simulace posunu poolu po plátně (Move) o 50 @ 50 bez změny extent"
	poolShape roassalShape translateTo: 50 @ 50.

	self assert: laneShape1 laneHeight equals: 220.
	self assert: laneShape2 laneHeight equals: 220.
	self assert: laneShape1 roassalShape encompassingRectangle bottom closeTo: initialSeparatorY + 50.
	self assert: laneShape2 roassalShape encompassingRectangle top closeTo: initialSeparatorY + 50
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
	self assert: (laneShape2 roassalShape encompassingRectangle bottom closeTo: poolShape roassalShape encompassingRectangle bottom)
]

{ #category : 'tests - resizing' }
OPBPMNPoolShapeTest >> testResizingPoolFromBottomEdgeExpandsLastLaneAndPreservesOtherLanes [

	| poolModel lane1Model lane2Model poolShape laneShape1 laneShape2 initialSeparatorY initialPoolRect |
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

	initialPoolRect := poolShape roassalShape encompassingRectangle.
	initialSeparatorY := laneShape1 roassalShape encompassingRectangle bottom.
	self assert: initialSeparatorY closeTo: 0.

	"Simulace tahu spodní hranou v Roassalu (posun bottom z 220 na 320 o 100 px dolů)"
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

	| poolModel lane1Model lane2Model poolShape laneShape1 laneShape2 initialSeparatorY initialPoolRect |
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

	initialPoolRect := poolShape roassalShape encompassingRectangle.
	initialSeparatorY := laneShape1 roassalShape encompassingRectangle bottom.
	self assert: initialSeparatorY closeTo: 0.

	"Simulace tahu horní hranou v Roassalu (posun top z -220 na -320 o 100 px nahoru)"
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
	self assert: (laneShape1 roassalShape encompassingRectangle top closeTo: poolShape roassalShape encompassingRectangle top)
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

	"Simulace rozšíření poolu doprava o 100 px (extent: 700@440, translateTo: 50@0)"
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
	self assert: (laneShape1 roassalShape encompassingRectangle bottom closeTo: initialSeparatorY + 100).
	self assert: (laneShape2 roassalShape encompassingRectangle top closeTo: initialSeparatorY + 100)
]

{ #category : 'tests - undo' }
OPBPMNPoolShapeTest >> testUndoRemovePoolPreservesLaneOrder [
	| model project diagram undoManager projectController diagramController poolController poolModel removeCmd restoredPoolController restoredPoolModel |
	model := OPBPMNExamples exampleOrderFulfillment.
	project := OPProject new addModel: model; yourself.
	diagram := OPOpenPonkDiagram forModelElement: model.
	project addDiagram: diagram.
	undoManager := OPUndoManager new.
	projectController := OPProjectController forProject: project.
	projectController instVarNamed: #undoManager put: undoManager.
	diagramController := OPBPMNDiagramController new.
	projectController addDiagramController: diagramController.
	diagramController
		canvasPresenter: (OPCanvasPresenter new canvas: RSCanvas new; yourself);
		diagramElement: diagram;
		model: model.
	diagramController showAllElements.

	poolController := diagramController controllers
		detect: [ :each | (each isKindOf: OPBPMNPoolController) and: [ each model name = 'Order Fulfillment' ] ].
	poolModel := poolController model.

	self
		assert: (poolModel lanes collect: #name) asArray
		equals: #('Sales' 'Warehouse').

	undoManager inTransaction: [
		removeCmd := OPRemoveModelElementCommand model: poolModel projectController: projectController.
		undoManager execute: removeCmd ].

	self assert: undoManager canUndo.
	undoManager undo.

	restoredPoolController := diagramController controllers
		detect: [ :each | (each isKindOf: OPBPMNPoolController) and: [ each model name = 'Order Fulfillment' ] ]
		ifNone: [ nil ].
	self
		assert: restoredPoolController isNotNil
		description: [ 'Restored pool controller must be present in diagram controllers after undo' ].

	restoredPoolModel := restoredPoolController model.
	self
		assert: (restoredPoolModel lanes collect: #name) asArray
		equals: #('Sales' 'Warehouse')
]
