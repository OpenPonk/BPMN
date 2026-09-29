"
I render a BPMN Pool as a complex Roassal bound node. I manage the vertical pool name area and the dynamic layout of horizontal lanes.
"
Class {
	#name : 'OPBPMNPoolShape',
	#superclass : 'OPBoundNode',
	#instVars : [
		'topBox',
		'bottomBox',
		'nameLabel',
		'nameAreaSeparator',
		'lastRectangle',
		'isAdjustingExtent'
	],
	#category : 'OpenPonk-BPMN-DiagramElements',
	#package : 'OpenPonk-BPMN',
	#tag : 'DiagramElements'
}

{ #category : 'layout' }
OPBPMNPoolShape >> adaptBoundsToInnerBounds: anInnerRectangle [
	"Resizes pool shape to encompass inner nodes or lanes, accounting for pool header width."
	| poolShape poolLeft poolRight poolTop poolBottom poolRectangle |
	poolShape := self roassalShape.
	self innerNodeElements ifEmpty: [
		poolShape extent: 650 @ 120.
		^ self ].
	self hasLanes
		ifTrue: [
			poolLeft := anInnerRectangle left - self nameAreaWidth.
			poolRight := anInnerRectangle right.
			poolTop := anInnerRectangle top.
			poolBottom := anInnerRectangle bottom ]
		ifFalse: [
			poolLeft := anInnerRectangle left - (self nameAreaWidth + 30).
			poolRight := anInnerRectangle right + 40.
			poolTop := anInnerRectangle top - 35.
			poolBottom := anInnerRectangle bottom + 35 ].
	poolRectangle := Rectangle left: poolLeft right: poolRight top: poolTop bottom: poolBottom.
	poolShape
		translateTo: poolRectangle center;
		extent: poolRectangle extent.
	self hasLanes ifTrue: [ self layoutLanes ]
]

{ #category : 'interactions' }
OPBPMNPoolShape >> addSelectionDraggableInteraction [
	roassalShape @ (OPRSSelectionDraggableBorder thatAlsoDragsShapesProvidedByBlock: [ self innerDraggableRoassalShapes ])
]

{ #category : 'geometry' }
OPBPMNPoolShape >> adjustExtentToLanes [
	"Adjusts pool extent and position to fit its contained lanes without triggering interactive resize."
	| lanes currentShape targetHeight heightDelta currentPosition targetRectangle newPosition newExtent |
	roassalShape ifNil: [ ^ self ].
	lanes := self laneShapes.
	lanes ifEmpty: [ ^ self ].
	currentShape := self roassalShape.
	targetHeight := (lanes sumNumbers: [ :eachLane | eachLane laneHeight ]) asInteger.
	targetHeight := targetHeight max: 220.
	heightDelta := targetHeight - currentShape height.
	heightDelta abs > 0.5 ifTrue: [
		currentPosition := currentShape position.
		newPosition := currentPosition x @ (currentPosition y + (heightDelta / 2)).
		newExtent := currentShape width @ targetHeight.
		targetRectangle := Rectangle
			origin: (newPosition x - (newExtent x / 2)) @ (newPosition y - (newExtent y / 2))
			extent: newExtent.
		self lastRectangle: targetRectangle.
		isAdjustingExtent := true.
		[
			currentShape extent: newExtent.
			currentShape translateTo: newPosition.
			self updateNameArea
		] ensure: [ isAdjustingExtent := false ].
		bounds ifNotNil: [
			self bounds: (OPNodeBounds withPosition: targetRectangle floatCenter extent: targetRectangle extent) ] ].
	self relocateLanesDisplacingElements: true
]

{ #category : 'reacting' }
OPBPMNPoolShape >> associationCreated: anAssociation [

	"do nothing"
]

{ #category : 'accessing' }
OPBPMNPoolShape >> attachedShapes [

	^ super attachedShapes , {
		  topBox.
		  bottomBox.
		  nameLabel.
		  nameAreaSeparator }
]

{ #category : 'accessing' }
OPBPMNPoolShape >> directNodeRoassalShapes [
	"Answers roassal shapes of direct children: lane shapes if partitioned, or positionable child shapes."
	^ self hasLanes
		ifTrue: [ (self laneShapes collect: [ :eachLane | eachLane roassalShape ]) asGroup ]
		ifFalse: [ super directNodeRoassalShapes ]
]

{ #category : 'geometry' }
OPBPMNPoolShape >> handlePositionChanged [
	"Handles position changes from Roassal. Differentiates between translation (Move) and boundary deformation (Resize)."

	| currentRectangle |
	roassalShape ifNil: [ ^ self ].
	isAdjustingExtent ifTrue: [ ^ self ].
	currentRectangle := roassalShape encompassingRectangle.
	(self lastRectangle isNotNil and: [ (self lastRectangle extent closeTo: currentRectangle extent) not ])
		ifTrue: [ self resizeToRectangle: currentRectangle ]
		ifFalse: [
				self lastRectangle: currentRectangle.
				self relocateLanesDisplacingElements: false ]
]

{ #category : 'testing' }
OPBPMNPoolShape >> hasLanes [
	"Answers whether this pool contains any lane diagram elements."
	^ self laneElements isNotEmpty
]

{ #category : 'initialization' }
OPBPMNPoolShape >> initialize [

	super initialize.
	isAdjustingExtent := false
]

{ #category : 'accessing' }
OPBPMNPoolShape >> innerDraggableRoassalShapes [
	| draggableGroup |
	draggableGroup := RSGroup new.
	self hasLanes ifTrue: [
		self laneShapes do: [ :eachLaneShape |
			eachLaneShape isRendered ifTrue: [
				draggableGroup addAll: eachLaneShape innerDraggableRoassalShapes ] ] ].
	draggableGroup addAll: super innerDraggableRoassalShapes.
	^ draggableGroup asSet asGroup
]

{ #category : 'accessing' }
OPBPMNPoolShape >> innerNodeElements [
	"Answers direct children: lane elements if partitioned, or direct positionable node elements otherwise."
	^ self hasLanes
		ifTrue: [ self laneElements ]
		ifFalse: [ super innerNodeElements ]
]

{ #category : 'testing' }
OPBPMNPoolShape >> isContainer [
	^ true
]

{ #category : 'accessing' }
OPBPMNPoolShape >> laneElements [
	"Answers all lane diagram elements owned by this pool in model order if model is present, or in owned order."
	| lanes |
	lanes := (self ownedElements select: [ :eachElement |
		eachElement isKindOf: OPBPMNLaneShape ]) asOrderedCollection.
	(self modelElement isNotNil and: [ self modelElement respondsTo: #lanes ]) ifTrue: [
		| orderedLanes |
		orderedLanes := self modelElement lanes
			collect: [ :eachLaneModel |
				lanes detect: [ :eachLaneShape | eachLaneShape modelElement == eachLaneModel ] ifNone: [ nil ] ]
			thenSelect: [ :each | each isNotNil ].
		orderedLanes ifNotEmpty: [ ^ orderedLanes ] ].
	^ lanes
]

{ #category : 'accessing' }
OPBPMNPoolShape >> laneShapes [
	"Answers all rendered lane diagram elements owned by this pool."
	^ self laneElements select: [ :eachLane | eachLane isRendered ]
]

{ #category : 'accessing' }
OPBPMNPoolShape >> lastRectangle [
	"Answers the last known encompassing rectangle of this pool."
	^ lastRectangle ifNil: [
		roassalShape ifNotNil: [ lastRectangle := roassalShape encompassingRectangle copy ] ]
]

{ #category : 'accessing' }
OPBPMNPoolShape >> lastRectangle: aRectangle [
	"Sets the last known encompassing rectangle of this pool."
	lastRectangle := aRectangle copy
]

{ #category : 'layouting' }
OPBPMNPoolShape >> layoutLanes [
	"Positions and resizes all contained lane shapes according to their individual lane heights and updates lastRectangle."
	self relocateLanes.
	roassalShape ifNotNil: [ self lastRectangle: roassalShape encompassingRectangle ]
]

{ #category : 'constants' }
OPBPMNPoolShape >> nameAreaWidth [

	^ 30
]

{ #category : 'accessing' }
OPBPMNPoolShape >> nameLabel [
	^ nameLabel
]

{ #category : 'rendering' }
OPBPMNPoolShape >> ownedElement: aDiagramElement renderedIn: aCanvas [
	super ownedElement: aDiagramElement renderedIn: aCanvas.
	(aDiagramElement isKindOf: OPBPMNLaneShape) ifTrue: [
		self adjustExtentToLanes ]
]

{ #category : 'rendering' }
OPBPMNPoolShape >> ownedElementRemovedRender: aDiagramElement [
	super ownedElementRemovedRender: aDiagramElement.
	(aDiagramElement isKindOf: OPBPMNLaneShape) ifTrue: [
		self adjustExtentToLanes ]
]

{ #category : 'geometry' }
OPBPMNPoolShape >> relocateLanes [
	self relocateLanesDisplacingElements: true
]

{ #category : 'geometry' }
OPBPMNPoolShape >> relocateLanesDisplacingElements: aBoolean [
	| lanes poolShape poolLeft poolTop poolInnerWidth currentY |
	lanes := self laneShapes.
	lanes ifEmpty: [ ^ self ].
	poolShape := self roassalShape.
	poolLeft := poolShape position x - (poolShape width / 2).
	poolTop := poolShape position y - (poolShape height / 2).
	poolInnerWidth := (poolShape width - self nameAreaWidth) asInteger.
	currentY := poolTop.

	lanes do: [ :eachLane |
		| currentHeight laneCenterX laneCenterY eachShape oldOrigin newOrigin deltaY |
		eachShape := eachLane roassalShape.
		oldOrigin := (eachShape position x - (eachShape width / 2)) @ (eachShape position y - (eachShape height / 2)).
		currentHeight := eachLane laneHeight asInteger.
		laneCenterX := poolLeft + self nameAreaWidth + (poolInnerWidth / 2).
		laneCenterY := currentY + (currentHeight / 2).
		eachShape
			extent: poolInnerWidth @ currentHeight;
			translateTo: laneCenterX @ laneCenterY.
		currentY := currentY + currentHeight.
		eachLane updatePosition.
		newOrigin := (laneCenterX - (poolInnerWidth / 2)) @ (laneCenterY - (currentHeight / 2)).
		deltaY := newOrigin y - oldOrigin y.
		(aBoolean and: [ (deltaY closeTo: 0) not ]) ifTrue: [
			eachLane translateContainedElementsPositionsBy: (0 @ deltaY) ] ].
	poolShape signalUpdate
]

{ #category : 'removing' }
OPBPMNPoolShape >> removeRender [
	"Unsubscribes from shape events and clears header references."
	self roassalShape ifNotNil: [ :shape | shape announcer unsubscribe: self ].
	super removeRender.
	topBox := nil.
	bottomBox := nil.
	nameLabel := nil.
	nameAreaSeparator := nil
]

{ #category : 'rendering' }
OPBPMNPoolShape >> renderBasicShape [

	^ RSBox new
		  width: 650;
		  height: 400;
		  color: Color transparent;
		  borderColor: Color black
]

{ #category : 'rendering' }
OPBPMNPoolShape >> renderNameArea [

	self renderNameAreaLabel.
	self renderNameAreaInvisibleBoxes.
	self renderNameAreaSeparator
]

{ #category : 'rendering' }
OPBPMNPoolShape >> renderNameAreaInvisibleBoxes [
	topBox := RSBox new
		borderColor: Color transparent;
		width: 0;
		height: 0;
		model: self.
	bottomBox := topBox copy model: self.
	self canvas
		add: topBox;
		add: bottomBox.
	self updateNameArea
]

{ #category : 'rendering' }
OPBPMNPoolShape >> renderNameAreaLabel [
	nameLabel := RSLabel new
		color: Color black;
		model: self;
		rotateByDegrees: -90;
		text: (self modelElement ifNotNil: [ :element | element name ifNil: [ 'Pool' ] ] ifNil: [ 'Pool' ]);
		yourself.
	self canvas add: nameLabel.
	self roassalShape when: RSPositionChangedEvent do: [ self updateNameArea ] for: self.
	self roassalShape when: RSExtentChangedEvent do: [ self updateNameArea ] for: self.
	nameLabel when: RSExtentChangedEvent do: [ self updateNameArea ] for: self
]

{ #category : 'rendering' }
OPBPMNPoolShape >> renderNameAreaSeparator [

	nameAreaSeparator := RSLine new
		                     width: 1;
		                     model: self;
		                     from: topBox;
		                     to: bottomBox.

	roassalShape canvas add: nameAreaSeparator
]

{ #category : 'rendering' }
OPBPMNPoolShape >> renderShapeDetails [
	super renderShapeDetails.
	self renderNameArea.
	self roassalShape
		when: RSPositionChangedEvent
		do: [ self handlePositionChanged ]
		for: self
]

{ #category : 'geometry' }
OPBPMNPoolShape >> resizeToRectangle: aRectangle [
	| oldRectangle deltaTop deltaBottom lanes |
	oldRectangle := self lastRectangle ifNil: [ roassalShape ifNotNil: [ roassalShape encompassingRectangle copy ] ].
	oldRectangle ifNil: [ ^ self ].

	deltaTop := aRectangle top - oldRectangle top.
	deltaBottom := aRectangle bottom - oldRectangle bottom.

	lanes := self laneShapes.
	lanes ifNotEmpty: [
		lanes size = 1
			ifTrue: [ lanes first laneHeight: (lanes first laneHeight - deltaTop + deltaBottom max: 50) ]
			ifFalse: [
				deltaTop abs > 0.5 ifTrue: [ lanes first laneHeight: (lanes first laneHeight - deltaTop max: 50) ].
				deltaBottom abs > 0.5 ifTrue: [ lanes last laneHeight: (lanes last laneHeight + deltaBottom max: 50) ] ] ].

	self lastRectangle: aRectangle.

	roassalShape ifNotNil: [
		(roassalShape extent closeTo: aRectangle extent) ifFalse: [ roassalShape extent: aRectangle extent ].
		(roassalShape position closeTo: aRectangle floatCenter) ifFalse: [ roassalShape translateTo: aRectangle floatCenter ].
		self relocateLanesDisplacingElements: false ].

	bounds ifNotNil: [ self bounds: (OPNodeBounds withPosition: aRectangle floatCenter extent: aRectangle extent) ]
]

{ #category : 'interactions' }
OPBPMNPoolShape >> selectableInteraction [

	^ OPRSSelectable highlightBorderColorBlue
]

{ #category : 'interactions' }
OPBPMNPoolShape >> shouldBeResizableByUser [

	^ true
]

{ #category : 'initialization' }
OPBPMNPoolShape >> updateBorderColorFromStyles [

	self updateBasicShapeBorderColorFromStyles.
	nameAreaSeparator color: self borderColor
]

{ #category : 'updating' }
OPBPMNPoolShape >> updateNameArea [
	roassalShape ifNil: [ ^ self ].
	topBox ifNotNil: [ :box |
		RSLocation new innerX; left; top; offset: self nameAreaWidth @ 0; move: box on: roassalShape ].
	bottomBox ifNotNil: [ :box |
		RSLocation new innerX; left; bottom; offset: self nameAreaWidth @ 0; move: box on: roassalShape ].
	nameLabel ifNotNil: [ :label |
		RSLocation new inner; left; middle; offset: (self nameAreaWidth - label textExtents height / 2) asInteger @ 0; move: label on: roassalShape ].
	nameAreaSeparator ifNotNil: [ :separator |
		separator from: topBox; to: bottomBox; signalUpdate ]
]

{ #category : 'roassal' }
OPBPMNPoolShape >> updateRenderFromBounds [
	"Updates visual render from bounds value object, adapting lane heights if bounds extent changed."
	| targetRectangle |
	bounds ifNil: [ ^ self ].
	roassalShape ifNil: [ ^ self ].
	targetRectangle := Rectangle center: bounds position extent: bounds extent.
	(self lastRectangle isNotNil and: [ (self lastRectangle extent closeTo: targetRectangle extent) not ])
		ifTrue: [ self resizeToRectangle: targetRectangle ]
		ifFalse: [
			self isResizableByUser ifTrue: [ roassalShape extent: bounds extent ].
			self isPositionableByUser ifTrue: [ roassalShape translateTo: bounds position ].
			self lastRectangle: targetRectangle.
			self relocateLanesDisplacingElements: false ]
]

{ #category : 'rendering' }
OPBPMNPoolShape >> updateRenderFromModel [
	nameLabel ifNotNil: [ :label |
		label text: (self modelElement ifNotNil: [ :aModelElement | aModelElement name ifNil: [ '' ] ] ifNil: [ '' ]) ].
	super updateRenderFromModel.
	self isRendered ifTrue: [ self adjustExtentToLanes ].
	roassalShape ifNotNil: [ :shape | shape signalUpdate ]
]
