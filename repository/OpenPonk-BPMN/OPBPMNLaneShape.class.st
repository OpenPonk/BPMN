Class {
	#name : 'OPBPMNLaneShape',
	#superclass : 'OPNode',
	#instVars : [
		'nameLabel',
		'leftBox',
		'rightBox',
		'laneSeparator',
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

{ #category : 'accessing' }
OPBPMNLaneShape >> height [
	"Answers the visual height of this lane, falling back to configured laneHeight when not rendered."
	roassalShape ifNotNil: [ ^ roassalShape height ].
	^ self laneHeight
]

{ #category : 'initialization' }
OPBPMNLaneShape >> initialize [

	super initialize.
	laneHeight ifNil: [ laneHeight := 220 ]
]

{ #category : 'testing' }
OPBPMNLaneShape >> isContainer [
	^ true
]

{ #category : 'testing' }
OPBPMNLaneShape >> isLastLaneInPool [
	^ owningElement isNotNil and: [
		(owningElement respondsTo: #laneElements) and: [
			owningElement laneElements ifNotEmpty: [ :lanes | lanes last == self ] ifEmpty: [ false ] ] ]
]

{ #category : 'accessing' }
OPBPMNLaneShape >> laneHeight [
	^ laneHeight ifNil: [ laneHeight := 220 ]
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

{ #category : 'removing' }
OPBPMNLaneShape >> removeRender [
	"Cleans up attached shapes and visual references when removing render."
	self roassalShape ifNotNil: [ :shape | shape announcer unsubscribe: self ].
	nameLabel ifNotNil: [ :label | label announcer unsubscribe: self ].
	super removeRender.
	nameLabel := nil.
	leftBox := nil.
	rightBox := nil.
	laneSeparator := nil
]

{ #category : 'rendering' }
OPBPMNLaneShape >> renderBasicShape [
	^ RSBox new
		width: 600;
		height: 150;
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
	laneSeparator := RSLine new
		width: 1;
		color: Color black;
		model: self;
		from: leftBox;
		to: rightBox;
		yourself.
	self canvas
		add: leftBox;
		add: rightBox;
		add: laneSeparator.
	laneSeparator pushBack
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
	^ OPRSSelectable highlightBorderColorBlue
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
	laneSeparator ifNotNil: [ :separator |
		separator color: (isLastLane ifTrue: [ Color transparent ] ifFalse: [ Color black ]).
		separator signalUpdate ]
]

{ #category : 'rendering' }
OPBPMNLaneShape >> updateRenderFromModel [
	nameLabel ifNotNil: [ :aLabel |
		aLabel text: (self modelElement ifNotNil: [ :aModelElement | aModelElement name ifNil: [ '' ] ] ifNil: [ '' ]) ].
	super updateRenderFromModel.
	self updatePosition.
	roassalShape signalUpdate
]
