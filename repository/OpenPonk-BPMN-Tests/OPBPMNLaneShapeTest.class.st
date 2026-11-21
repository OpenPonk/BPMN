"
Verifies visual rendering, label interaction forwarding, and structural constraints of lane shapes on the Roassal canvas.
"
Class {
	#name : 'OPBPMNLaneShapeTest',
	#superclass : 'TestCase',
	#instVars : [
		'laneShape',
		'canvas'
	],
	#category : 'OpenPonk-BPMN-Tests-DiagramElements',
	#package : 'OpenPonk-BPMN-Tests',
	#tag : 'DiagramElements'
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

{ #category : 'tests - geometry' }
OPBPMNLaneShapeTest >> testAdaptBoundsToInnerBoundsForEmptyAndPopulatedLane [

	| innerTaskShape innerRectangle expectedWidth expectedHeight |
	laneShape renderIn: canvas.
	laneShape adaptBoundsToInnerBounds: (Rectangle center: 0 @ 0 extent: 100 @ 50).
	self assert: laneShape roassalShape extent equals: 620 @ 150.

	innerTaskShape := OPBPMNActivityShape in: laneShape forModelElement: (OPBPMNActivityModel new
			                   name: 'Task';
			                   yourself).
	innerTaskShape renderIn: canvas.
	innerRectangle := Rectangle
		                  left: 100
		                  right: 210
		                  top: 50
		                  bottom: 120.
	laneShape adaptBoundsToInnerBounds: innerRectangle.

	expectedWidth := 210 + 40 - (100 - (laneShape nameAreaWidth + 30)).
	expectedHeight := 120 + 45 - (50 - 40).
	self assert: laneShape roassalShape extent equals: expectedWidth @ expectedHeight
]

{ #category : 'tests' }
OPBPMNLaneShapeTest >> testAttachedShapesContainsHorizontalSeparatorAndNoVerticalSeparator [

	laneShape renderIn: canvas.
	self assert: (laneShape instVarNamed: #laneSeparator) class identicalTo: OPBPMNLaneSeparatorLine.
	self assert: (laneShape instVarNamed: #leftBox) class identicalTo: RSBox.
	self assert: (laneShape instVarNamed: #rightBox) class identicalTo: RSBox.
	self assert: (laneShape instVarNamed: #nameLabel) class identicalTo: RSLabel.
	self assertCollection: laneShape attachedShapes hasSameElements: {
			(laneShape instVarNamed: #nameLabel).
			(laneShape instVarNamed: #leftBox).
			(laneShape instVarNamed: #rightBox).
			(laneShape instVarNamed: #laneSeparator) }
]

{ #category : 'tests - interaction' }
OPBPMNLaneShapeTest >> testClickingNameLabelForwardsClickToRoassalShape [

	| forwardedEvents nameLabel |
	laneShape renderIn: canvas.
	nameLabel := laneShape instVarNamed: #nameLabel.
	forwardedEvents := OrderedCollection new.
	laneShape roassalShape when: RSMouseClick do: [ :eachEvent | forwardedEvents add: eachEvent ] for: self.
	nameLabel announce: (RSMouseClick new
			 shape: nameLabel;
			 yourself).
	self assert: forwardedEvents size equals: 1.
	self assert: forwardedEvents first shape identicalTo: laneShape roassalShape
]

{ #category : 'tests' }
OPBPMNLaneShapeTest >> testDoesNotHaveBoundsSlot [

	self denyCollection: OPBPMNLaneShape allInstVarNames includesAny: { 'bounds' }
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

	self deny: laneShape shouldBePositionableByUser description: 'BPMN lane shape must not be positionable directly by user'
]

{ #category : 'tests' }
OPBPMNLaneShapeTest >> testIsNotResizableByUser [

	self deny: laneShape shouldBeResizableByUser description: 'BPMN lane shape must not be resizable directly by user'
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
OPBPMNLaneShapeTest >> testLaneQueriesAndGuardsWhenUnrenderedOrOutsidePool [

	| poolShape nonPoolOwner innerTaskShape |
	self deny: laneShape isLaneHighlighted description: 'Unrendered lane must not be highlighted'.
	self deny: laneShape shouldShowSeparatorHandle description: 'Unrendered lane must not show separator handle'.
	self assert: laneShape previousLaneShape identicalTo: nil.
	laneShape updatePosition.
	self deny: laneShape isRendered description: 'Calling updatePosition on unrendered lane must be a no-op'.

	poolShape := OPBPMNPoolShape new
		             bounds: (OPNodeBounds withPosition: 0 @ 0 extent: 600 @ 310);
		             yourself.
	laneShape owningElement: poolShape.
	self assert: laneShape defaultLaneHeight equals: 310.

	nonPoolOwner := OPBPMNActivityShape new.
	laneShape owningElement: nonPoolOwner.
	innerTaskShape := OPBPMNActivityShape in: laneShape forModelElement: (OPBPMNActivityModel new
			                   name: 'Task';
			                   yourself).
	laneShape evacuateOwnedElementsToPoolIfLastLane.
	self assert: innerTaskShape owningElement identicalTo: laneShape
]

{ #category : 'tests - geometry' }
OPBPMNLaneShapeTest >> testLaneShapeHasLaneHeightAndSerializesToSton [

	| poolShape laneShape1 laneShape2 stonString serializedLaneHeightLines materializedPool materializedLane1 materializedLane2 |
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
	serializedLaneHeightLines := (stonString lines
		                              select: [ :eachLine | eachLine trimBoth beginsWith: '#laneHeight :' ]
		                              thenCollect: #trimBoth) asArray.
	self assert: serializedLaneHeightLines equals: #( '#laneHeight : 260' '#laneHeight : 180' ).

	materializedPool := STON fromString: stonString.
	self assert: materializedPool class identicalTo: OPBPMNPoolShape.
	self assert: materializedPool ownedElements size equals: 2.
	materializedLane1 := materializedPool ownedElements first.
	materializedLane2 := materializedPool ownedElements second.
	self assert: materializedLane1 class identicalTo: OPBPMNLaneShape.
	self assert: materializedLane2 class identicalTo: OPBPMNLaneShape.
	self assert: materializedLane1 laneHeight equals: 260.
	self assert: materializedLane2 laneHeight equals: 180
]

{ #category : 'tests - geometry' }
OPBPMNLaneShapeTest >> testRenderAndUpdateNameLabelHandlesNilNameAndExtentChange [

	| nameLabel |
	laneShape modelElement: (OPBPMNLaneModel new
			 name: nil;
			 yourself).
	laneShape renderIn: canvas.
	nameLabel := laneShape instVarNamed: #nameLabel.
	self assert: nameLabel text equals: ''.

	laneShape updateRenderFromModel.
	self assert: nameLabel text equals: ''.

	laneShape roassalShape
		extent: 600 @ 150;
		translateTo: 100 @ 200.
	nameLabel text: 'Updated Longer Lane Name'.
	self assert: nameLabel position y equals: 200
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
	self assert: interaction class identicalTo: OPRSSelectable.
	self deny: interaction class identicalTo: OPRSNoInteraction
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

	self assert: laneShape1 separatorHandle identicalTo: nil.
	self assert: laneShape2 separatorHandle identicalTo: nil.
	self assert: laneShape3 separatorHandle identicalTo: nil.

	selectable1 := laneShape1 roassalShape propertyAt: OPRSSelectable.
	selectable2 := laneShape2 roassalShape propertyAt: OPRSSelectable.
	selectable3 := laneShape3 roassalShape propertyAt: OPRSSelectable.

	"1. Select first lane -> only separator 1-2 has handle"
	selectable1 doHighlight: laneShape1 roassalShape.
	handle1 := laneShape1 separatorHandle.
	self assert: handle1 class identicalTo: RSEllipse.
	self assert: handle1 canvas identicalTo: canvas.
	self assert: handle1 extent equals: 14 @ 14.
	self assert: handle1 color equals: Color white.
	self assert: handle1 border width equals: 2.
	self assert: handle1 border color equals: Color blue.
	self assert: handle1 position equals: laneShape1 laneSeparator position.
	self assert: laneShape2 separatorHandle identicalTo: nil.
	self assert: laneShape3 separatorHandle identicalTo: nil.

	"2. Select middle lane -> both separator 1-2 and separator 2-3 have handles"
	selectable2 doHighlight: laneShape2 roassalShape.
	handle1 := laneShape1 separatorHandle.
	handle2 := laneShape2 separatorHandle.
	self assert: handle1 class identicalTo: RSEllipse.
	self assert: handle1 canvas identicalTo: canvas.
	self assert: handle2 class identicalTo: RSEllipse.
	self assert: handle2 canvas identicalTo: canvas.
	self assert: handle2 position equals: laneShape2 laneSeparator position.
	self assert: laneShape3 separatorHandle identicalTo: nil.

	"3. Select bottom lane -> only separator 2-3 (owned by lane 2) has handle"
	selectable3 doHighlight: laneShape3 roassalShape.
	self assert: laneShape1 separatorHandle identicalTo: nil.
	self assert: laneShape2 separatorHandle class identicalTo: RSEllipse.
	self assert: laneShape2 separatorHandle canvas identicalTo: canvas.
	self assert: laneShape3 separatorHandle identicalTo: nil.

	"4. Unhighlight all -> all handles removed"
	selectable3 unhighlightRecordedShapes: canvas.
	self assert: laneShape1 separatorHandle identicalTo: nil.
	self assert: laneShape2 separatorHandle identicalTo: nil.
	self assert: laneShape3 separatorHandle identicalTo: nil
]

{ #category : 'tests - geometry' }
OPBPMNLaneShapeTest >> testSeparatorHandleMouseEnterAndLeaveUpdatesTemporaryCursor [

	| poolModel lane1Model lane2Model poolShape laneShape1 laneShape2 selectable1 handle |
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

	selectable1 := laneShape1 roassalShape propertyAt: OPRSSelectable.
	selectable1 doHighlight: laneShape1 roassalShape.
	handle := laneShape1 separatorHandle.

	[
		handle announce: (RSMouseEnter new
				 shape: handle;
				 yourself).
		self currentWorld ifNotNil: [ :world |
				self
					assert: world currentHand temporaryCursor isNotNil
					description: 'Hovering separator handle must set a temporary resize cursor' ].
		handle announce: (RSMouseLeave new
				 shape: handle;
				 yourself).
		self currentWorld ifNotNil: [ :world | self assert: world currentHand temporaryCursor identicalTo: nil ] ] ensure: [
		self currentWorld ifNotNil: [ :world | world currentHand showTemporaryCursor: nil ] ]
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

	self
		deny: laneShape1 laneSeparator hasEventCallback
		description: 'Lane separator line must not intercept pointer events directly'.

	selectable1 := laneShape1 roassalShape propertyAt: OPRSSelectable.
	selectable1 doHighlight: laneShape1 roassalShape.
	handle := laneShape1 separatorHandle.
	self assert: handle class identicalTo: RSEllipse.
	self assert: handle canvas identicalTo: canvas.

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
