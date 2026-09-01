"
I render a BPMN Pool as a complex Roassal bound node. I manage the vertical pool name area and the dynamic layout of horizontal lanes.
"
Class {
	#name : 'OPBPMNPoolShape',
	#superclass : 'OPBoundNode',
	#traits : 'OPTBorderColoredAsStroke @ {#updateBasicShapeBorderColorFromStyles->#updateBorderColorFromStyles}',
	#classTraits : 'OPTBorderColoredAsStroke classTrait',
	#instVars : [
		'innerRoassalShapesBlock',
		'topBox',
		'bottomBox',
		'nameLabel',
		'nameAreaSeparator'
	],
	#category : 'OpenPonk-BPMN-DiagramElements',
	#package : 'OpenPonk-BPMN',
	#tag : 'DiagramElements'
}

{ #category : 'updating' }
OPBPMNPoolShape >> addNeededLanes [

	self lanes size >= self modelElement lanes ifTrue: [ ^ self ].

	self lanes size + 1 to: self modelElement lanes do: [ :index |
	OPBPMNPoolLaneShape renderIn: self forIndex: index ]
]

{ #category : 'interactions' }
OPBPMNPoolShape >> addSelectionDraggableInteraction [

	roassalShape
	@ (OPRSSelectionDraggableBorder thatAlsoDragsShapesProvidedByBlock:
			 innerRoassalShapesBlock)
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

{ #category : 'initialization' }
OPBPMNPoolShape >> initialize [

	super initialize.
	innerRoassalShapesBlock := [ :allNodes | allNodes ].
]

{ #category : 'initialization' }
OPBPMNPoolShape >> innerRoassalShapesBlock: aBlock [

	innerRoassalShapesBlock := aBlock
]

{ #category : 'updating' }
OPBPMNPoolShape >> lanes [

	^ self ownedElements select: [ :de |
		  de isKindOf: OPBPMNPoolLaneShape ]
]

{ #category : 'constants' }
OPBPMNPoolShape >> nameAreaWidth [

	^ 30
]

{ #category : 'accessing' }
OPBPMNPoolShape >> nameLabel [
	^ nameLabel
]

{ #category : 'removing' }
OPBPMNPoolShape >> removeRender [

	super removeRender.
	topBox := nil.
	bottomBox := nil.
	nameLabel := nil.
	nameAreaSeparator := nil
]

{ #category : 'updating' }
OPBPMNPoolShape >> removeUnneededLanes [

	self lanes reverseDo: [ :each | each remove ]
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

	RSLocation new
		innerX;
		left;
		top;
		offset: self nameAreaWidth @ 0;
		stick: topBox on: self roassalShape.
	RSLocation new
		innerX;
		left;
		bottom;
		offset: self nameAreaWidth @ 0;
		stick: bottomBox on: self roassalShape
]

{ #category : 'rendering' }
OPBPMNPoolShape >> renderNameAreaLabel [

	| location moveBlock |
	nameLabel := RSLabel new
		             color: Color black;
		             model: self;
		             rotateByDegrees: -90;
		             yourself.
	nameLabel text: 'Pool'.
	self canvas add: nameLabel.

	location := RSLocation new
		            inner;
		            left;
		            middle;
		            offset:
			            (self nameAreaWidth - nameLabel textExtents height / 2)
				            asInteger @ 0.

	moveBlock := [ location move: nameLabel on: self roassalShape ].
	moveBlock value.
	self roassalShape
		when: RSPositionChangedEvent
		do: moveBlock
		for: self.
	nameLabel when: RSExtentChangedEvent do: moveBlock for: self
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
	self renderNameArea
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
OPBPMNPoolShape >> updateLanes [

	self
		removeUnneededLanes;
		addNeededLanes
]

{ #category : 'rendering' }
OPBPMNPoolShape >> updateRenderFromModel [

	nameLabel text: (self modelElement name ifNil: [ '' ]).
	self updateLanes.
	super updateRenderFromModel.
	roassalShape signalUpdate
]
