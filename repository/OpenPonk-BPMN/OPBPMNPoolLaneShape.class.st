Class {
	#name : 'OPBPMNPoolLaneShape',
	#superclass : 'OPDiagramElement',
	#instVars : [
		'rightBox',
		'leftBox',
		'laneSeparator',
		'index'
	],
	#category : 'OpenPonk-BPMN-DiagramElements',
	#package : 'OpenPonk-BPMN',
	#tag : 'DiagramElements'
}

{ #category : 'instance creation' }
OPBPMNPoolLaneShape class >> renderIn: anOwner forIndex: anInteger [

	^ (self in: anOwner)
		  index: anInteger;
		  renderIn: anOwner canvas;
		  yourself
]

{ #category : 'accessing' }
OPBPMNPoolLaneShape >> attachedShapes [

	^ super attachedShapes , {
		  leftBox.
		  rightBox.
		  laneSeparator }
]

{ #category : 'accessing' }
OPBPMNPoolLaneShape >> color [

	^ self strokeColor
]

{ #category : 'rendering' }
OPBPMNPoolLaneShape >> createInvisibleBox [

	^ RSBox new
		  color: Color transparent;
		  extent: 0 @ 0;
		  model: self;
		  yourself
]

{ #category : 'accessing' }
OPBPMNPoolLaneShape >> defaultStrokeColor [

	^ Color black
]

{ #category : 'accessing' }
OPBPMNPoolLaneShape >> index [
	^ index
]

{ #category : 'accessing' }
OPBPMNPoolLaneShape >> index: anInteger [ 
	index := anInteger
]

{ #category : 'removing' }
OPBPMNPoolLaneShape >> removeRender [

	self owningElement roassalShape ifNotNil: [ :ownerShape |
		ownerShape announcer unsubscribe: self ].
	super removeRender.
	leftBox := nil.
	rightBox := nil.
	laneSeparator := nil
]

{ #category : 'rendering' }
OPBPMNPoolLaneShape >> renderBasicShape [

	^ RSLabel new
		  color: Color black;
		  model: self;
		  rotateByDegrees: -90;
		  yourself
]

{ #category : 'rendering' }
OPBPMNPoolLaneShape >> renderShapeDetails [

	leftBox := self createInvisibleBox.
	rightBox := self createInvisibleBox.
	laneSeparator := RSLine new
		                 color: Color transparent;
		                 from: leftBox;
		                 to: rightBox;
		                 yourself.
	self canvas
		add: leftBox;
		add: rightBox;
		add: laneSeparator.
	laneSeparator pushBack.

	self updatePosition.

	self owningElement roassalShape
		when: RSPositionChangedEvent
		do: [ self updatePosition ]
		for: self.

]

{ #category : 'accessing' }
OPBPMNPoolLaneShape >> strokeColor [

	^ self
		  stylePropertyNamed: #strokeColor
		  ifAbsent: [ self defaultStrokeColor ]
]

{ #category : 'initialization' }
OPBPMNPoolLaneShape >> updateColorFromStyles [

	self updateRoassalShapeColor
]

{ #category : 'rendering' }
OPBPMNPoolLaneShape >> updatePosition [

	| lanesCount lanesBelow poolRectangle poolLanesAreaRectangle nameAreaWidth laneHeight left right bottom labelX labelY |
	lanesCount := self modelElement lanes.
	lanesBelow := lanesCount - self index.

	poolRectangle := self owningElement encompassingRectangle.
	nameAreaWidth := self owningElement nameAreaWidth.
	poolLanesAreaRectangle := poolRectangle withLeft:
		                          poolRectangle left + nameAreaWidth.
	laneHeight := poolLanesAreaRectangle height / lanesCount.
	left := poolLanesAreaRectangle left.
	right := poolLanesAreaRectangle right.
	bottom := poolLanesAreaRectangle bottom - (lanesBelow * laneHeight).
	labelX := left + (nameAreaWidth / 2).
	labelY := bottom - (laneHeight / 2).

	leftBox translateTo: left @ bottom.
	rightBox translateTo: right @ bottom.
	self roassalShape translateTo: labelX @ labelY
]

{ #category : 'rendering' }
OPBPMNPoolLaneShape >> updateRenderFromModel [

	self roassalShape text: (self modelElement laneNameAt: self index).
	self updateRoassalShapeColor.
	self updatePosition.
	super updateRenderFromModel
]

{ #category : 'initialization' }
OPBPMNPoolLaneShape >> updateRenderFromStyles [

	self isRendered ifFalse: [ ^ self ].
	self updateColorFromStyles.
	super updateRenderFromStyles.
	laneSeparator signalUpdate
]

{ #category : 'initialization' }
OPBPMNPoolLaneShape >> updateRoassalShapeColor [

	laneSeparator color: (self index = self modelElement lanes
			 ifTrue: [ Color transparent ]
			 ifFalse: [ self color ])
]
