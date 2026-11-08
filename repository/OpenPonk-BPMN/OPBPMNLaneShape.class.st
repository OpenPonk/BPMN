Class {
	#name : 'OPBPMNLaneShape',
	#superclass : 'OPNode',
	#instVars : [
		'nameLabel',
		'leftBox',
		'rightBox',
		'laneSeparator',
		'separatorHandle',
		'laneHeight'
	],
	#category : 'OpenPonk-BPMN-DiagramElements',
	#package : 'OpenPonk-BPMN',
	#tag : 'DiagramElements'
}

{ #category : 'constants' }
OPBPMNLaneShape class >> minimumHeight [
	^ 50
]

{ #category : 'ston-core' }
OPBPMNLaneShape class >> stonAllInstVarNames [
	"Answers all instance variable names serialized by STON."
	^ super stonAllInstVarNames , #( #laneHeight )
]

{ #category : 'layout' }
OPBPMNLaneShape >> adaptBoundsToInnerBounds: anInnerRectangle [
	"Resizes lane shape to encompass inner flow nodes, accounting for lane header width."
	| laneShape laneLeft laneRight laneTop laneBottom laneRectangle |
	laneShape := self roassalShape.
	self innerNodeElements ifEmpty: [
		laneShape extent: 600 @ 120.
		^ self ].
	laneLeft := anInnerRectangle left - (self nameAreaWidth + 30).
	laneRight := anInnerRectangle right + 40.
	laneTop := anInnerRectangle top - 35.
	laneBottom := anInnerRectangle bottom + 35.
	laneRectangle := Rectangle left: laneLeft right: laneRight top: laneTop bottom: laneBottom.
	laneShape
		extent: laneRectangle extent;
		translateTo: laneRectangle center
]

{ #category : 'connecting' }
OPBPMNLaneShape >> associationCreated: anAssociation [
	"Hook called when an association connected to this shape is rendered. No specific visual reaction needed."
	
]

{ #category : 'accessing' }
OPBPMNLaneShape >> attachedShapes [
	"Answers all visual decoration shapes attached to this lane shape."
	^ super attachedShapes , {
		nameLabel.
		leftBox.
		rightBox.
		laneSeparator }
]

{ #category : 'rendering' }
OPBPMNLaneShape >> createInvisibleBox [
	^ RSBox new
		color: Color transparent;
		extent: 0 @ 0;
		model: self;
		yourself
]

{ #category : 'rendering' }
OPBPMNLaneShape >> createSeparatorHandle [
	| handle |
	handle := RSEllipse new
		color: Color white;
		border: (RSBorder new
			width: 2;
			color: Color blue;
			yourself);
		size: 14;
		model: self;
		yourself.
	self registerSeparatorHandleEventsOn: handle.
	^ handle
]

{ #category : 'accessing' }
OPBPMNLaneShape >> defaultLaneHeight [
	self owningElement ifExists: [ :owner |
		((owner isKindOf: OPBPMNPoolShape) and: [
			(owner isRendered or: [ owner bounds isNotNil ]) and: [
				owner laneElements size <= 1 and: [
					owner modelElement isNil or: [ owner modelElement lanes size <= 1 ] ] ] ])
			ifTrue: [ ^ owner height ] ].
	^ 220
]

{ #category : 'private' }
OPBPMNLaneShape >> evacuateOwnedElementsToPoolIfLastLane [
	| poolElement remainingLanes |
	poolElement := self owningElement.
	poolElement ifNotExists: [ ^ self ].
	(poolElement respondsTo: #laneElements) ifFalse: [ ^ self ].
	((poolElement respondsTo: #isRemovingRender) and: [ poolElement isRemovingRender ])
		ifTrue: [ ^ self ].
	remainingLanes := poolElement laneElements copyWithout: self.
	remainingLanes ifNotEmpty: [ ^ self ].
	self ownedElements copy do: [ :eachElement |
		eachElement owningElement: poolElement ]
]

{ #category : 'interactions' }
OPBPMNLaneShape >> handleHighlighted: anEvent [
	roassalShape ifNotNil: [ :shape |
		shape propertyAt: #isLaneHighlighted put: true ].
	self updateAdjacentSeparatorHandles
]

{ #category : 'interactions' }
OPBPMNLaneShape >> handleUnhighlighted: anEvent [
	roassalShape ifNotNil: [ :shape |
		shape propertyAt: #isLaneHighlighted put: false ].
	self updateAdjacentSeparatorHandles
]

{ #category : 'accessing' }
OPBPMNLaneShape >> height [
	"Answers the visual height of this lane, falling back to configured laneHeight when not rendered."
	roassalShape ifNotNil: [ ^ roassalShape height ].
	^ self laneHeight
]

{ #category : 'testing' }
OPBPMNLaneShape >> isContainer [
	^ true
]

{ #category : 'testing' }
OPBPMNLaneShape >> isLaneHighlighted [
	^ roassalShape
		ifNotNil: [ :shape | shape propertyAt: #isLaneHighlighted ifAbsent: [ false ] ]
		ifNil: [ false ]
]

{ #category : 'testing' }
OPBPMNLaneShape >> isLastLaneInPool [
	^ owningElement isNotNil and: [
		(owningElement respondsTo: #laneElements) and: [
			owningElement laneElements ifNotEmpty: [ :lanes | lanes last == self ] ifEmpty: [ false ] ] ]
]

{ #category : 'accessing' }
OPBPMNLaneShape >> laneHeight [
	^ laneHeight ifNil: [ laneHeight := self defaultLaneHeight ]
]

{ #category : 'accessing' }
OPBPMNLaneShape >> laneHeight: aNumber [
	"Sets the height of this lane in points. Nil for last/only lane"

	laneHeight := aNumber
]

{ #category : 'accessing' }
OPBPMNLaneShape >> laneSeparator [
	"Answers the line representing the separator at the bottom of this lane."
	^ laneSeparator
]

{ #category : 'constants' }
OPBPMNLaneShape >> minimumHeight [
	^ self class minimumHeight
]

{ #category : 'accessing' }
OPBPMNLaneShape >> nameAreaWidth [
	^ 30
]

{ #category : 'accessing' }
OPBPMNLaneShape >> nextLaneShape [
	| poolShape lanes currentIndex |
	poolShape := self owningElement.
	(poolShape isNotNil and: [ poolShape respondsTo: #laneShapes ]) ifFalse: [ ^ nil ].
	lanes := poolShape laneShapes.
	currentIndex := lanes indexOf: self.
	(currentIndex > 0 and: [ currentIndex < lanes size ]) ifFalse: [ ^ nil ].
	^ lanes at: currentIndex + 1
]

{ #category : 'accessing' }
OPBPMNLaneShape >> previousLaneShape [
	| poolShape lanes currentIndex |
	poolShape := self owningElement.
	(poolShape isNotNil and: [ poolShape respondsTo: #laneShapes ]) ifFalse: [ ^ nil ].
	lanes := poolShape laneShapes.
	currentIndex := lanes indexOf: self.
	currentIndex > 1 ifFalse: [ ^ nil ].
	^ lanes at: currentIndex - 1
]

{ #category : 'rendering' }
OPBPMNLaneShape >> registerSeparatorHandleEventsOn: aHandleShape [

	| rawDeltaY initialFirstHeight initialSecondHeight nextShape |
	nextShape := self nextLaneShape.
	rawDeltaY := 0.0.
	initialFirstHeight := self laneHeight.
	initialSecondHeight := nextShape ifNil: [ 0 ] ifNotNil: [ :theShape | theShape laneHeight ].
	aHandleShape
		when: RSMouseEnter do: [ :event | self showSeparatorResizeCursor ] for: self;
		when: RSMouseLeave do: [ :event | self removeSeparatorResizeCursor ] for: self;
		when: RSMouseLeftDragStart do: [ :event |
				nextShape := self nextLaneShape.
				nextShape ifNotNil: [
							rawDeltaY := 0.0.
							initialFirstHeight := self laneHeight.
							initialSecondHeight := nextShape laneHeight ] ]
		for: self;
		when: RSMouseDragging do: [ :event |
				nextShape ifNotNil: [
							| stepDeltaY currentDelta maxShrinkFirst maxShrinkSecond clampedDelta |
							stepDeltaY := (event camera distanceFromPixelToSpace: event step) y.
							rawDeltaY := rawDeltaY + stepDeltaY.
							currentDelta := rawDeltaY rounded.
							maxShrinkFirst := initialFirstHeight - self minimumHeight max: 0.
							maxShrinkSecond := initialSecondHeight - nextShape minimumHeight max: 0.
							clampedDelta := (currentDelta min: maxShrinkSecond) max: maxShrinkFirst negated.
							self laneHeight: initialFirstHeight + clampedDelta.
							nextShape laneHeight: initialSecondHeight - clampedDelta.
							self owningElement ifExists: [ :pool | pool relocateLanesDisplacingElements: false ] ] ]
		for: self;
		when: RSMouseDragEnd do: [ :event |
				nextShape ifNotNil: [
							| effectiveDelta |
							effectiveDelta := (self laneHeight - initialFirstHeight) asInteger.
							self laneHeight: initialFirstHeight.
							nextShape laneHeight: initialSecondHeight.
							nextShape := nil.
							effectiveDelta isZero ifFalse: [ self announcer announce: (OPBPMNLaneSeparatorMoved delta: effectiveDelta) ] ] ]
		for: self
]

{ #category : 'removing' }
OPBPMNLaneShape >> remove [
	self evacuateOwnedElementsToPoolIfLastLane.
	super remove
]

{ #category : 'removing' }
OPBPMNLaneShape >> removeRender [
	"Cleans up attached shapes and visual references when removing render."
	self evacuateOwnedElementsToPoolIfLastLane.
	self removeSeparatorHandle.
	self roassalShape ifNotNil: [ :shape |
		shape propertyAt: #isLaneHighlighted put: false.
		shape announcer unsubscribe: self ].
	nameLabel ifNotNil: [ :label | label announcer unsubscribe: self ].
	super removeRender.
	nameLabel := nil.
	leftBox := nil.
	rightBox := nil.
	laneSeparator := nil
]

{ #category : 'removing' }
OPBPMNLaneShape >> removeSeparatorHandle [
	separatorHandle ifNil: [ ^ self ].
	self removeSeparatorResizeCursor.
	separatorHandle announcer unsubscribe: self.
	separatorHandle remove.
	separatorHandle := nil
]

{ #category : 'cursor' }
OPBPMNLaneShape >> removeSeparatorResizeCursor [
	self currentWorld ifNotNil: [ :world |
		world currentHand showTemporaryCursor: nil ]
]

{ #category : 'rendering' }
OPBPMNLaneShape >> renderBasicShape [

	^ RSBox new
		  width: 600;
		  height: self laneHeight;
		  color: Color transparent;
		  borderColor: Color transparent;
		  yourself
]

{ #category : 'rendering' }
OPBPMNLaneShape >> renderNameArea [
	self renderNameAreaLabel
]

{ #category : 'rendering' }
OPBPMNLaneShape >> renderNameAreaLabel [
	nameLabel := RSLabel new
		color: Color black;
		model: self;
		rotateByDegrees: -90;
		yourself.
	nameLabel text: (self modelElement ifNotNil: [ :aModelElement | aModelElement name ifNil: [ '' ] ] ifNil: [ '' ]).
	self canvas add: nameLabel.
	self addEventForwardingFrom: nameLabel to: self roassalShape.
	nameLabel when: RSExtentChangedEvent do: [ self updatePosition ] for: self
]

{ #category : 'rendering' }
OPBPMNLaneShape >> renderSeparator [
	leftBox := self createInvisibleBox.
	rightBox := self createInvisibleBox.
	laneSeparator := OPBPMNLaneSeparatorLine new
		width: 1;
		color: Color black;
		model: self;
		from: leftBox;
		to: rightBox;
		yourself.
	self canvas
		add: leftBox;
		add: rightBox;
		add: laneSeparator
]

{ #category : 'rendering' }
OPBPMNLaneShape >> renderShapeDetails [
	super renderShapeDetails.
	self renderNameArea.
	self renderSeparator.
	self updatePosition.
	self roassalShape
		when: RSPositionChangedEvent
		do: [ self updatePosition ]
		for: self
]

{ #category : 'interactions' }
OPBPMNLaneShape >> selectableInteraction [
	| interaction |
	interaction := OPRSSelectable highlightBorderColorBlue.
	interaction
		when: RSHighlightEvent send: #handleHighlighted: to: self;
		when: RSUnHighlightEvent send: #handleUnhighlighted: to: self.
	^ interaction
]

{ #category : 'accessing' }
OPBPMNLaneShape >> separatorHandle [
	^ separatorHandle
]

{ #category : 'testing' }
OPBPMNLaneShape >> shouldShowSeparatorHandle [
	| adjacentLane |
	self isRendered ifFalse: [ ^ false ].
	self isLastLaneInPool ifTrue: [ ^ false ].
	adjacentLane := self nextLaneShape.
	adjacentLane ifNil: [ ^ false ].
	^ self isLaneHighlighted or: [ adjacentLane isLaneHighlighted ]
]

{ #category : 'cursor' }
OPBPMNLaneShape >> showSeparatorResizeCursor [
	self currentWorld ifNotNil: [ :world |
		world currentHand showTemporaryCursor: Cursor resizeTop ]
]

{ #category : 'geometry' }
OPBPMNLaneShape >> translateContainedElementsPositionsBy: aDeltaPoint [
	"Translates direct positionable rendered elements contained in this lane by the given delta."
	| positionableElements |
	positionableElements := self innerNodeElements select: [ :eachChild |
		eachChild isPositionableByUser and: [ eachChild isRendered ] ].
	positionableElements do: [ :eachPositionable |
		eachPositionable translateBy: aDeltaPoint ]
]

{ #category : 'updating' }
OPBPMNLaneShape >> updateAdjacentSeparatorHandles [
	self updateSeparatorHandle.
	self previousLaneShape ifNotNil: [ :previousLane |
		previousLane updateSeparatorHandle ].
	roassalShape ifNotNil: [ :shape | shape signalUpdate ]
]

{ #category : 'updating' }
OPBPMNLaneShape >> updatePosition [
	| laneLeft laneRight laneBottom labelX labelY isLastLane |
	roassalShape ifNil: [ ^ self ].
	laneLeft := roassalShape position x - (roassalShape width / 2).
	laneRight := roassalShape position x + (roassalShape width / 2).
	laneBottom := roassalShape position y + (roassalShape height / 2).
	leftBox ifNotNil: [ :box | box translateTo: laneLeft @ laneBottom ].
	rightBox ifNotNil: [ :box | box translateTo: laneRight @ laneBottom ].
	labelX := laneLeft + (self nameAreaWidth / 2).
	labelY := roassalShape position y.
	nameLabel ifNotNil: [ :label | label translateTo: labelX @ labelY ].
	isLastLane := self isLastLaneInPool.
	self pushBack.
	self owningElement ifExists: [ :owner | owner pushBack ].
	laneSeparator ifNotNil: [ :separator |
		separator color: (isLastLane ifTrue: [ Color transparent ] ifFalse: [ Color black ]).
		separator signalUpdate.
		isLastLane ifFalse: [ separator pushFront ] ].
	self updateSeparatorHandle
]

{ #category : 'rendering' }
OPBPMNLaneShape >> updateRenderFromModel [
	nameLabel ifNotNil: [ :aLabel |
		aLabel text: (self modelElement ifNotNil: [ :aModelElement | aModelElement name ifNil: [ '' ] ] ifNil: [ '' ]) ].
	super updateRenderFromModel.
	self updatePosition.
	roassalShape signalUpdate
]

{ #category : 'updating' }
OPBPMNLaneShape >> updateSeparatorHandle [
	| separatorCenter |
	self shouldShowSeparatorHandle ifFalse: [
		self removeSeparatorHandle.
		^ self ].
	separatorHandle ifNil: [
		separatorHandle := self createSeparatorHandle.
		self canvas add: separatorHandle ].
	separatorCenter := laneSeparator
		ifNotNil: [ :separator | separator position ]
		ifNil: [ roassalShape position x @ (roassalShape position y + (roassalShape height / 2)) ].
	separatorHandle translateTo: separatorCenter.
	separatorHandle pushFront
]
