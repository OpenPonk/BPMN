Class {
	#name : 'OPBPMNPoolShape',
	#superclass : 'OPBoundNode',
	#instVars : [
		'label',
		'laneLines',
		'laneLabels',
		'b1',
		'b2',
		'borderColor'
	],
	#category : 'OpenPonk-BPMN-DiagramElements',
	#package : 'OpenPonk-BPMN',
	#tag : 'DiagramElements'
}

{ #category : 'adding' }
OPBPMNPoolShape >> addLanes: aNumber [

	| b4 b5 e2 w h lb |
	self removeLaneLines.
	w := roassalShape width.
	h := roassalShape height.
	2 to: aNumber do: [ :i | 
		b4 := RSBox new size: 0.01.
		b5 := RSBox new size: 0.01.
		roassalShape add: b4.
		roassalShape add: b5.
		roassalShape adjustToChildren.
		b4 position:
			b1 width / 2 @ (i - 1 / aNumber * 2 * b1 height - b1 height / 2).
		b5 position: b1 width / 2 - b1 width + b2 width
			@ (i - 1 / aNumber * 2 * b1 height - b1 height / 2).
		"b5 position: (w/2)-w+(30) @ (((i-1)/ aNumber*2*(b1 height))- b1 height/2)."

		e2 := RSLine new
			      from: b4;
			      to: b5;
					addInteraction: OPRSDraggableControlPoints.

		self canvas add: e2.
		laneLines add: e2 ].

	aNumber > 1 ifTrue: [ 
		1 to: aNumber do: [ :i | 
			lb := RSLabel new
				rotateByDegrees: -90.
			roassalShape add: lb.
			laneLabels add: lb.
			lb position:
				b1 width / 2 - b1 width + b2 width + 8 @ ((i - 1 / aNumber * 2 * b1 height - b1 height / 2) + (b1 height/aNumber/2)) ] ]
]

{ #category : 'accessing' }
OPBPMNPoolShape >> addSelectionDraggableInteraction [

	roassalShape
	@ OPRSSelectionDraggableBorder thatAlsoDragsContainedShapes
]

{ #category : 'removing' }
OPBPMNPoolShape >> attachedShapes [

	^ super attachedShapes , laneLines , laneLabels , {
		  label.
		  b1.
		  b2 }
]

{ #category : 'accessing' }
OPBPMNPoolShape >> borderColor [

	^ borderColor
]

{ #category : 'accessing' }
OPBPMNPoolShape >> borderColor: aColor [

	borderColor := aColor
]

{ #category : 'accessing' }
OPBPMNPoolShape >> color [

	^ self stylePropertyNamed: #fillColor ifAbsent: [ Color transparent ]
]

{ #category : 'accessing' }
OPBPMNPoolShape >> color: aColor [

	^ self stylePropertyNamed: #fillColor put: aColor
]

{ #category : 'accessing' }
OPBPMNPoolShape >> createRoassalShape [
| com |
com := RSComposite new.
b1 := RSBox new width: 650; height: 400; color: Color white; borderColor: Color black.
b2 := RSBox new width: 30; height: 400; color: Color white; borderColor: Color black.
com add: b1.
com add: b2.

com adjustToChildren.
b2 position: -310@0. 
	^ com
]

{ #category : 'initialization' }
OPBPMNPoolShape >> initialize [
	super initialize.
	laneLines := OrderedCollection new.
	laneLabels := OrderedCollection new.
]

{ #category : 'accessing' }
OPBPMNPoolShape >> label [

	^ label
]

{ #category : 'removing' }
OPBPMNPoolShape >> removeLaneLines [

	laneLines do: [ :each | self canvas removeShape: each. ].
	"laneLabels do: [ :each | self canvas removeShape: each. ]."
	laneLabels do: [ :each | self roassalShape removeShape: each. ].
	laneLines removeAll.
	laneLabels removeAll.
]

{ #category : 'removing' }
OPBPMNPoolShape >> removeRender [

	self removeLaneLines.
	super removeRender.
	label := nil.
	b1 := nil.
	b2 := nil
]

{ #category : 'accessing' }
OPBPMNPoolShape >> renderBasicShape [

	^ self createRoassalShape model: self
]

{ #category : 'accessing' }
OPBPMNPoolShape >> renderShapeDetails [

	label := RSLabel new
		         rotateByDegrees: -90;
		         color: Color black.
	self roassalShape add: label.
	label position: b1 width / 2 - b1 width + 11 @ 0.
	"self canvas add: label.
	RSLocation new
		stick: label on: self roassalShape;
		left;
		offset: 4 @ 0.
	self roassalShape when: RSShapeRemovedEvent do: [ label remove ]."

	"roassalShape @ OPRSSelectionDraggable.
	roassalShape @ RSTransformable.
	selectable := OPRSSelectable new.
	self setupHighlight: selectable.
	roassalShape @ selectable.
	self updateRenderFromModel."

	self roassalShape
		pushBack;
		@ RSTransformable.
	self updateRenderFromModel
]

{ #category : 'interactions' }
OPBPMNPoolShape >> resizableInteractionTarget [

	^ b1
]

{ #category : 'accessing' }
OPBPMNPoolShape >> selectableInteraction [

	^ OPRSSelectable highlightBorderColorBlue
]

{ #category : 'accessing' }
OPBPMNPoolShape >> shouldBePositionableByUser [

	^ true
]

{ #category : 'interactions' }
OPBPMNPoolShape >> shouldBeResizableByUser [

	^ true
]

{ #category : 'accessing' }
OPBPMNPoolShape >> updateRenderFromModel [
	| aCnt |
	self modelElement name ifNotNil: [ 
		label text: self modelElement name ].
	"roassalShape width: self modelElement width.
	roassalShape height: self modelElement height.
	lane width: self modelElement width.
	lane height: self modelElement height/2."
	self addLanes: self modelElement lanes.
	aCnt := 1.
	self modelElement laneNames do: [ :each | (laneLabels at: aCnt) text: each. aCnt := aCnt + 1. ].
	super updateRenderFromModel.
	roassalShape signalUpdate
]

{ #category : 'accessing' }
OPBPMNPoolShape >> updateRenderFromSelf [

	self isRendered ifFalse: [ ^ self ].
	roassalShape color: self color.
	super updateRenderFromSelf
]
