Class {
	#name : 'OPBPMNPoolShapeTest',
	#superclass : 'TestCase',
	#category : 'OpenPonk-BPMN-Tests',
	#package : 'OpenPonk-BPMN',
	#tag : 'Tests'
}

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
