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
