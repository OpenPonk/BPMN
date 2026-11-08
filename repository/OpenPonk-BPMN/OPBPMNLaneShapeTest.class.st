Class {
	#name : 'OPBPMNLaneShapeTest',
	#superclass : 'TestCase',
	#instVars : [
		'laneShape',
		'canvas'
	],
	#category : 'OpenPonk-BPMN-Tests',
	#package : 'OpenPonk-BPMN',
	#tag : 'Tests'
}

{ #category : 'running' }
OPBPMNLaneShapeTest >> setUp [
	super setUp.
	canvas := RSCanvas new.
	laneShape := OPBPMNLaneShape new
]

{ #category : 'running' }
OPBPMNLaneShapeTest >> tearDown [

	laneShape ifNotNil: [ :shape |
			shape isRendered ifTrue: [ shape removeRender ].
			laneShape := nil ].
	canvas := nil.
	super tearDown
]

{ #category : 'tests' }
OPBPMNLaneShapeTest >> testAttachedShapesContainsHorizontalSeparatorAndNoVerticalSeparator [
	laneShape renderIn: canvas.
	self assert: (laneShape instVarNamed: #laneSeparator) isNotNil.
	self assert: (laneShape instVarNamed: #leftBox) isNotNil.
	self assert: (laneShape instVarNamed: #rightBox) isNotNil.
	self assertCollection: laneShape attachedShapes hasSameElements: {
		(laneShape instVarNamed: #nameLabel).
		(laneShape instVarNamed: #leftBox).
		(laneShape instVarNamed: #rightBox).
		(laneShape instVarNamed: #laneSeparator) }
]

{ #category : 'tests' }
OPBPMNLaneShapeTest >> testAttachedShapesIncludesHeaderElements [
	laneShape renderIn: canvas.
	self assertCollection: laneShape attachedShapes hasSameElements: {
		(laneShape instVarNamed: #nameLabel).
		(laneShape instVarNamed: #leftBox).
		(laneShape instVarNamed: #rightBox).
		(laneShape instVarNamed: #laneSeparator) }
]

{ #category : 'tests - interaction' }
OPBPMNLaneShapeTest >> testClickingNameLabelForwardsClickToRoassalShape [
	| clickAnnounced nameLabel |
	laneShape renderIn: canvas.
	nameLabel := laneShape instVarNamed: #nameLabel.
	clickAnnounced := false.
	laneShape roassalShape when: RSMouseClick do: [ clickAnnounced := true ] for: self.
	nameLabel announce: (RSMouseClick new shape: nameLabel; yourself).
	self assert: clickAnnounced
]

{ #category : 'tests' }
OPBPMNLaneShapeTest >> testDoesNotHaveBoundsSlot [
	self deny: (OPBPMNLaneShape allInstVarNames includes: 'bounds')
]

{ #category : 'tests' }
OPBPMNLaneShapeTest >> testDoesNotUpdatePositionOnExtentChangedEvent [
	| initialLabelPosition intermediateLabelPosition |
	laneShape renderIn: canvas.
	laneShape roassalShape
		extent: 600 @ 150;
		translateTo: 100 @ 200.
	laneShape updatePosition.
	initialLabelPosition := (laneShape instVarNamed: #nameLabel) position copy.

	laneShape roassalShape extent: 700 @ 150.
	intermediateLabelPosition := (laneShape instVarNamed: #nameLabel) position copy.

	self assert: intermediateLabelPosition equals: initialLabelPosition
]

{ #category : 'tests' }
OPBPMNLaneShapeTest >> testInheritsFromOPNode [
	self assert: OPBPMNLaneShape superclass equals: OPNode
]

{ #category : 'tests' }
OPBPMNLaneShapeTest >> testIsNotPositionableByUser [
	self deny: laneShape shouldBePositionableByUser
]

{ #category : 'tests' }
OPBPMNLaneShapeTest >> testIsNotResizableByUser [
	self deny: laneShape shouldBeResizableByUser
]

{ #category : 'tests' }
OPBPMNLaneShapeTest >> testLaneLabelPositionedInsideLaneHeader [
	| laneLeft expectedLabelX nameLabel |
	laneShape renderIn: canvas.
	laneShape roassalShape
		extent: 600 @ 150;
		translateTo: 100 @ 200.
	laneShape updatePosition.
	nameLabel := laneShape instVarNamed: #nameLabel.
	laneLeft := laneShape roassalShape position x - (laneShape roassalShape width / 2).
	expectedLabelX := laneLeft + (laneShape nameAreaWidth / 2).
	self assert: nameLabel position x equals: expectedLabelX.
	self assert: nameLabel position y equals: 200
]

{ #category : 'tests - geometry' }
OPBPMNLaneShapeTest >> testLaneShapeHasLaneHeightAndSerializesToSton [

	| poolShape laneShape1 laneShape2 stonString materializedPool materializedLane1 materializedLane2 |
	poolShape := OPBPMNPoolShape new.
	poolShape bounds: (OPNodeBounds withPosition: 0 @ 0 extent: 600 @ 440).

	laneShape1 := OPBPMNLaneShape new.
	laneShape2 := OPBPMNLaneShape new.

	poolShape ownedElements
		add: laneShape1;
		add: laneShape2.
	laneShape1 owningElement: poolShape.
	laneShape2 owningElement: poolShape.
	laneShape1 laneHeight: 260.
	laneShape2 laneHeight: 180.

	self assert: laneShape1 laneHeight equals: 260.
	self assert: laneShape2 laneHeight equals: 180.

	stonString := STON toStringPretty: poolShape.
	self assert: (stonString includesSubstring: 'laneHeight').

	materializedPool := STON fromString: stonString.
	materializedLane1 := materializedPool ownedElements first.
	materializedLane2 := materializedPool ownedElements second.

	self assert: materializedLane1 laneHeight equals: 260.
	self assert: materializedLane2 laneHeight equals: 180
]

{ #category : 'tests - visual' }
OPBPMNLaneShapeTest >> testRenderBasicShapeHasTransparentBorderAndFill [
	| basicShape |
	basicShape := laneShape renderBasicShape.
	self assert: basicShape borderColor equals: Color transparent.
	self assert: basicShape color equals: Color transparent
]

{ #category : 'tests - interaction' }
OPBPMNLaneShapeTest >> testSelectableInteractionIsSelectable [
	| interaction |
	interaction := laneShape selectableInteraction.
	self assert: (interaction isKindOf: OPRSSelectable).
	self deny: (interaction isKindOf: OPRSNoInteraction)
]

{ #category : 'tests - interaction' }
OPBPMNLaneShapeTest >> testSelectingLaneShowsSeparatorHandleOnAdjacentInternalSeparatorsAndDeselectingRemovesIt [
	| poolModel lane1Model lane2Model lane3Model poolShape laneShape1 laneShape2 laneShape3 selectable1 selectable2 selectable3 handle1 handle2 |
	poolModel := OPBPMNPoolModel new name: 'Pool'.
	lane1Model := OPBPMNLaneModel new name: 'Lane 1'.
	lane2Model := OPBPMNLaneModel new name: 'Lane 2'.
	lane3Model := OPBPMNLaneModel new name: 'Lane 3'.
	poolModel
		addLane: lane1Model;
		addLane: lane2Model;
		addLane: lane3Model.

	poolShape := OPBPMNPoolShape new.
	poolShape modelElement: poolModel.
	poolShape bounds: (OPNodeBounds withPosition: 0 @ 0 extent: 600 @ 660).
	poolShape renderIn: canvas.

	laneShape1 := OPBPMNLaneShape in: poolShape forModelElement: lane1Model.
	laneShape2 := OPBPMNLaneShape in: poolShape forModelElement: lane2Model.
	laneShape3 := OPBPMNLaneShape in: poolShape forModelElement: lane3Model.
	laneShape1 renderIn: canvas.
	laneShape2 renderIn: canvas.
	laneShape3 renderIn: canvas.
	poolShape layoutLanes.

	self assert: (laneShape1 respondsTo: #separatorHandle).
	self assert: laneShape1 separatorHandle isNil.
	self assert: laneShape2 separatorHandle isNil.
	self assert: laneShape3 separatorHandle isNil.

	selectable1 := laneShape1 roassalShape propertyAt: OPRSSelectable.
	selectable2 := laneShape2 roassalShape propertyAt: OPRSSelectable.
	selectable3 := laneShape3 roassalShape propertyAt: OPRSSelectable.

	"1. Select first lane -> only separator 1-2 has handle"
	selectable1 doHighlight: laneShape1 roassalShape.
	handle1 := laneShape1 separatorHandle.
	self assert: handle1 isNotNil.
	self assert: handle1 isInACanvas.
	self assert: handle1 class equals: RSEllipse.
	self assert: handle1 extent equals: 14 @ 14.
	self assert: handle1 color equals: Color white.
	self assert: handle1 border width equals: 2.
	self assert: handle1 border color equals: Color blue.
	self assert: handle1 position equals: laneShape1 laneSeparator position.
	self assert: laneShape2 separatorHandle isNil.
	self assert: laneShape3 separatorHandle isNil.

	"2. Select middle lane -> both separator 1-2 and separator 2-3 have handles"
	selectable2 doHighlight: laneShape2 roassalShape.
	handle1 := laneShape1 separatorHandle.
	handle2 := laneShape2 separatorHandle.
	self assert: handle1 isNotNil.
	self assert: handle1 isInACanvas.
	self assert: handle2 isNotNil.
	self assert: handle2 isInACanvas.
	self assert: handle2 position equals: laneShape2 laneSeparator position.
	self assert: laneShape3 separatorHandle isNil.

	"3. Select bottom lane -> only separator 2-3 (owned by lane 2) has handle"
	selectable3 doHighlight: laneShape3 roassalShape.
	self assert: laneShape1 separatorHandle isNil.
	self assert: laneShape2 separatorHandle isNotNil.
	self assert: laneShape2 separatorHandle isInACanvas.
	self assert: laneShape3 separatorHandle isNil.

	"4. Unhighlight all -> all handles removed"
	selectable3 unhighlightRecordedShapes: canvas.
	self assert: laneShape1 separatorHandle isNil.
	self assert: laneShape2 separatorHandle isNil.
	self assert: laneShape3 separatorHandle isNil
]

{ #category : 'tests - interaction' }
OPBPMNLaneShapeTest >> testSeparatorHandleStaysInFrontOfInnerNodesAndRemainsDraggableAtMinimumHeight [
	| poolModel lane1Model lane2Model taskModel poolShape laneShape1 laneShape2 taskShape selectable1 handle pixelPoint hitShape |
	poolModel := OPBPMNPoolModel new name: 'Pool'.
	lane1Model := OPBPMNLaneModel new name: 'Lane 1'.
	lane2Model := OPBPMNLaneModel new name: 'Lane 2'.
	taskModel := OPBPMNActivityModel new name: 'Overlapping Task'.
	lane1Model add: taskModel.
	poolModel
		addLane: lane1Model;
		addLane: lane2Model.

	poolShape := OPBPMNPoolShape new.
	poolShape modelElement: poolModel.
	poolShape bounds: (OPNodeBounds withPosition: 0 @ 0 extent: 600 @ 440).
	poolShape renderIn: canvas.

	laneShape1 := OPBPMNLaneShape in: poolShape forModelElement: lane1Model.
	laneShape2 := OPBPMNLaneShape in: poolShape forModelElement: lane2Model.
	laneShape1 renderIn: canvas.
	laneShape2 renderIn: canvas.
	poolShape layoutLanes.

	taskShape := OPBPMNActivityShape in: laneShape1 forModelElement: taskModel.
	taskShape renderIn: canvas.
	taskShape roassalShape translateTo: laneShape1 laneSeparator position.

	self deny: laneShape1 laneSeparator hasEventCallback.

	selectable1 := laneShape1 roassalShape propertyAt: OPRSSelectable.
	selectable1 doHighlight: laneShape1 roassalShape.
	handle := laneShape1 separatorHandle.
	self assert: handle isNotNil.

	pixelPoint := canvas camera fromSpaceToPixel: handle position.
	hitShape := canvas shapeWithAction: RSMouseLeftDragStart forPositionInPixels: pixelPoint.
	self assert: hitShape equals: handle.

	"Drag all the way up to minimumHeight = 50"
	handle announce: (RSMouseLeftDragStart new
		shape: handle;
		canvas: canvas;
		position: pixelPoint;
		yourself).
	handle announce: (RSMouseDragging new
		shape: handle;
		canvas: canvas;
		position: handle position + (0 @ -300);
		step: 0 @ -300;
		yourself).
	handle announce: (RSMouseDragEnd new
		shape: handle;
		canvas: canvas;
		position: handle position;
		yourself).

	"Even after layout/updatePosition, handle must remain topmost hit target at separator position"
	laneShape1 laneHeight: 50.
	laneShape2 laneHeight: 390.
	poolShape relocateLanesDisplacingElements: false.

	pixelPoint := canvas camera fromSpaceToPixel: handle position.
	hitShape := canvas shapeWithAction: RSMouseLeftDragStart forPositionInPixels: pixelPoint.
	self assert: hitShape equals: handle
]

{ #category : 'tests' }
OPBPMNLaneShapeTest >> testUpdatePositionAlignsSeparatorAndLabelWithoutDrift [
	| expectedLeft expectedRight expectedBottom |
	laneShape renderIn: canvas.
	laneShape roassalShape
		extent: 600 @ 150;
		translateTo: 100 @ 200.
	laneShape updatePosition.
	expectedLeft := 100 - (600 / 2).
	expectedRight := 100 + (600 / 2).
	expectedBottom := 200 + (150 / 2).
	self assert: (laneShape instVarNamed: #leftBox) position equals: expectedLeft @ expectedBottom.
	self assert: (laneShape instVarNamed: #rightBox) position equals: expectedRight @ expectedBottom.
	self assert: (laneShape instVarNamed: #nameLabel) position y equals: 200
]
